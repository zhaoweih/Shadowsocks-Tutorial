# 给小白的PAC规则替换教程

# 问题

❓如果对文章有任何疑问可以提到:https://github.com/zhaoweih/Shadowsocks-Tutorial/issues
或者发送邮件给我:zhaoweihao.dev@gmail.com

# 前言

  因为现在被墙的网站越来越多了，官方自带的GFWLIST已经满足不了我平常的需求了，看一些冷门的网站基本都会匹配不到黑名单规则而直接走的直连模式，导致需要经常切换全局模式，所以我用白名单规则了，黑名单规则和白名单规则的区别就是：例如google.com在黑名单规则里头，那样google.com就会走代理，所以基本黑名单里头都是被墙的国外网站，黑名单外一律直连，所以当你访问一个冷门国外网站，而这个网站没有在黑名单里头，这样就会走直连会变得非常慢，而用白名单规则就会只有在白名单里头的中国网站会走直连，其他一律直接走代理，会很大程度提高幸福感，但是这样子会有的问题就是1）消耗更多的流量2）部分冷门中国网站会走代理变慢，首先这两点对我来说完全OK，流量跟网站浏览体验对比，我选择浏览体验，而且经过一段时间使用，流量其实也没多多少。所以分享我平常用的白名单规则PAC文件，用不用就随君选择了。

# 使用教程

  ## Windows

1)首先下载[PAC文件](https://raw.githubusercontent.com/zhaoweih/Shadowsocks-Tutorial/master/pac/pac.txt)

2)如果你的windows客户端端口没有改过，用的默认的1080端口那就不用改，如果是改了其他端口需要打开下载的pac.txt文件，修改第一行1080端口为你自己设置的端口，例如我的是1086端口，我就要修改成`var wall_proxy = "SOCKS5 127.0.0.1:1086";`然后保存修改

3)打开Shadowsocks.exe所在目录，你会发现有一个pac.txt的文件，先备份一份然后拉过去替换掉就行，替换完重新启动一下shadowsocks就行

## Mac

1)首先下载[PAC文件](https://raw.githubusercontent.com/zhaoweih/Shadowsocks-Tutorial/master/pac/gfwlist.js)

2)如果你的Mac客户端端口没有改过，用的默认的1086端口那就不用改，如果是改了其他端口需要打开下载的gfwlist.js文件，修改第一行1086端口为你自己设置的端口，例如我的是1086端口，我就要修改成`var wall_proxy = "SOCKS5 127.0.0.1:1086";`然后保存修改

3)在访达打开`~/.ShadowsocksX-NG/`目录,你会发现有一个gfwlist.js的文件，先备份一份然后拉过去替换掉就行，替换完重新启动一下shadowsocks就行

# 联系

邮箱：zhaoweihao.dev@gmail.com
