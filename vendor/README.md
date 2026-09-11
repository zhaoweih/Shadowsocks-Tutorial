# vendor/

`sh/shadowsocks-all.sh` 编译安装时需要的全部源码包都放在这里，脚本会优先从本仓库下载（或直接使用 `git clone` 下来的本地副本），并用 sha256 校验；上游地址只作为最后的兜底。这样上游项目改名、删 release、个人站点关闭都不会让脚本失效。

All source tarballs needed by `sh/shadowsocks-all.sh` live here. The script fetches them from this repository first (or uses the local copy of a `git clone`), verifies them with sha256, and only falls back to the upstream URLs as a last resort.

| 文件 / File | 版本 / Version | 上游 / Upstream | 许可证 / License |
|---|---|---|---|
| `shadowsocks-libev-3.3.5.tar.gz` | 3.3.5 (2020-09, 最后一个 release) | https://github.com/shadowsocks/shadowsocks-libev (仓库已改名为 shadowsocks-c) | GPL-3.0 |
| `libsodium-1.0.18.tar.gz` | 1.0.18 | https://github.com/jedisct1/libsodium | ISC |
| `mbedtls-2.16.12.tar.gz` | 2.16.12 | https://github.com/Mbed-TLS/mbedtls | Apache-2.0 |
| `simple-obfs-486bebd.tar.gz` | commit `486bebd` (2019-08, 含子模块 libcork) | https://github.com/shadowsocks/simple-obfs | GPL-3.0 |
| `libev-4.33.tar.gz` | 4.33（仅 CentOS 无法从 EPEL 安装 libev-devel 时使用） | https://dist.schmorp.de/libev/ | BSD-2-Clause / GPL-2.0+ |

`SHA256SUMS` 与脚本内嵌的校验表由 `sh/update-vendor.sh` 生成。

## 脚本的查找顺序 / Lookup order

1. 当前目录已有的同名文件（校验通过才用）
2. 脚本所在目录的 `../vendor/`（`git clone` 整个仓库后可以完全离线安装）
3. `https://raw.githubusercontent.com/zhaoweih/Shadowsocks-Tutorial/main/vendor/`，可用环境变量 `SS_VENDOR_URL` 指向镜像或 fork 的分支
4. 上游原始地址

每一级下载后都会用脚本内嵌的 sha256 校验，校验失败会删除并尝试下一级。

## 更新 / Refresh

在 Linux 上运行（需要 GNU tar 以生成可复现的 simple-obfs 包）：

```bash
sh/update-vendor.sh          # 补齐缺失的文件
sh/update-vendor.sh --force  # 全部重新下载
```

脚本会重新下载、重新生成 `SHA256SUMS`，并改写 `sh/shadowsocks-all.sh` 里 `BEGIN/END VENDOR CHECKSUMS` 之间的校验表。要升级某个组件，改 `sh/shadowsocks-all.sh` 和 `sh/update-vendor.sh` 里对应的版本号后再运行一次即可。
