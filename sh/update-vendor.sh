#!/usr/bin/env bash
#
# Refresh vendor/ from the upstream projects and regenerate the checksums that
# sh/shadowsocks-all.sh verifies against.
#
# Run this on Linux (needs GNU tar for a reproducible simple-obfs tarball):
#   sh/update-vendor.sh          # download files that are missing
#   sh/update-vendor.sh --force  # re-download everything
#
# Then review `git status`, and commit vendor/ together with sh/shadowsocks-all.sh.

set -euo pipefail

repo_dir=$(cd "$(dirname "$0")/.." && pwd)
vendor_dir="${repo_dir}/vendor"
script="${repo_dir}/sh/shadowsocks-all.sh"
force=0
[ "${1:-}" == '--force' ] && force=1

# Keep these in sync with the *_file / *_upstream variables in sh/shadowsocks-all.sh.
# Format: <file name in vendor/>|<upstream url>
files=(
    'shadowsocks-libev-3.3.5.tar.gz|https://github.com/shadowsocks/shadowsocks-c/releases/download/v3.3.5/shadowsocks-libev-3.3.5.tar.gz'
    'libsodium-1.0.18.tar.gz|https://github.com/jedisct1/libsodium/releases/download/1.0.18-RELEASE/libsodium-1.0.18.tar.gz'
    'mbedtls-2.16.12.tar.gz|https://github.com/Mbed-TLS/mbedtls/archive/refs/tags/v2.16.12.tar.gz'
    'libev-4.33.tar.gz|https://dist.schmorp.de/libev/Attic/libev-4.33.tar.gz'
)
# simple-obfs has no release tarball and pulls libcork in as a git submodule,
# so we pin a commit and pack the fully checked-out tree ourselves.
simple_obfs_repo='https://github.com/shadowsocks/simple-obfs.git'
simple_obfs_commit='486bebd9208539058e57e23a12f23103016e09b4'
simple_obfs_file="simple-obfs-${simple_obfs_commit:0:7}.tar.gz"

if ! tar --version 2>/dev/null | grep -q 'GNU tar'; then
    echo 'GNU tar is required (run this on Linux).' >&2
    exit 1
fi

mkdir -p "${vendor_dir}"
cd "${vendor_dir}"

for entry in "${files[@]}"; do
    name=${entry%%|*}
    url=${entry#*|}
    if [ -f "${name}" ] && [ "${force}" -eq 0 ]; then
        echo "${name} [kept]"
        continue
    fi
    echo "${name} <- ${url}"
    wget -q -t3 -T60 -O "${name}.part" "${url}"
    mv "${name}.part" "${name}"
done

if [ ! -f "${simple_obfs_file}" ] || [ "${force}" -eq 1 ]; then
    echo "${simple_obfs_file} <- ${simple_obfs_repo}@${simple_obfs_commit:0:7}"
    tmp=$(mktemp -d)
    git clone -q "${simple_obfs_repo}" "${tmp}/simple-obfs"
    git -C "${tmp}/simple-obfs" checkout -q "${simple_obfs_commit}"
    git -C "${tmp}/simple-obfs" submodule update -q --init --recursive
    commit_time=$(git -C "${tmp}/simple-obfs" log -1 --format=%ct)
    find "${tmp}/simple-obfs" -name .git -prune -exec rm -rf {} +
    # deterministic archive: same input tree -> same bytes -> same checksum
    tar --sort=name --mtime="@${commit_time}" --owner=0 --group=0 --numeric-owner \
        -C "${tmp}" -cf - simple-obfs | gzip -n > "${simple_obfs_file}"
    rm -rf "${tmp}"
fi

# stale files from older versions
for f in *.tar.gz; do
    keep=0
    for entry in "${files[@]}"; do [ "${f}" == "${entry%%|*}" ] && keep=1; done
    [ "${f}" == "${simple_obfs_file}" ] && keep=1
    [ "${keep}" -eq 0 ] && echo "warning: ${f} is not referenced any more, delete it by hand" >&2
done

sha256sum -- *.tar.gz > SHA256SUMS
echo "wrote ${vendor_dir}/SHA256SUMS"

# Every vendored file must be referenced by the install script, otherwise the two
# drift apart. Names may be assembled from a version variable there, so the
# version/commit part of the file name is enough.
while read -r _ name; do
    base=${name%.tar.gz}
    if ! grep -q -- "${base}" "${script}" && ! grep -q -- "${base##*-}" "${script}"; then
        echo "error: ${name} is not referenced in ${script}" >&2
        exit 1
    fi
done < SHA256SUMS

# Regenerate the checksum table embedded in the install script.
block=$(printf "    ['%s']='%s'\n" $(awk '{print $2, $1}' SHA256SUMS))
awk -v block="${block}" '
    /^# BEGIN VENDOR CHECKSUMS/ { print; print "declare -A vendor_sha256=("; print block; print ")"; skip=1; next }
    /^# END VENDOR CHECKSUMS/   { skip=0 }
    !skip { print }
' "${script}" > "${script}.tmp" && mv "${script}.tmp" "${script}"
chmod +x "${script}"
echo "updated checksum table in ${script}"
