# KCPTUN acceleration tutorial for Shadowsocks beginners

# Issues

❓ If you have any questions about this article, you can post them at: https://github.com/zhaoweih/Shadowsocks-Tutorial/issues

# Preface

  I previously published an article about using domestic VPS for relay acceleration. Although the speed improvement was significant, it required purchasing multiple servers, which was more expensive. This wasn't wallet-friendly. This tutorial explains how to accelerate your existing shadowsocks (hereinafter referred to as ss) server, saving the cost of an additional server. The acceleration effect is also very good. For example, my server on Vultr had issues even opening YouTube in the evening. It could only connect, but was incredibly slow. After using this method, I could watch 1080p videos on YouTube without a hitch in the evening. Now, let's skip the chit-chat and get to the tutorial.

# Prerequisite

  This tutorial mainly explains how to use kcptun to accelerate ss. I'm assuming you've already purchased a server and set up a working ss. If you haven't set up ss, you can refer to my article [Shadowsocks Guide for Beginners](./README.md). For example, my server is set up with the IP address 8.8.8.8 and port 447.
  ![](./images/kcptun/16.png)

# Installing the KCPTUN server

## SSH into your server

**Note: My tutorial environment uses Debian 10. If you encounter unsolvable issues, try using the same environment as mine.**

  If you've already set up ss, you should know how to SSH into your server. You can use any SSH tool. Here, I use Putty as an example.
  ![](./images/kcptun/1.png)

After logging in, copy and paste the following commands into your server and press Enter:

```bash
wget --no-check-certificate https://github.com/kuoruan/shell-scripts/raw/master/kcptun/kcptun.sh
chmod +x ./kcptun.sh
./kcptun.sh
```

![](./images/kcptun/2.png)

First, you need to input the kcptun server port. There's a default of 29900. It's best not to use the default. Choose a port you prefer [1~65535]. For instance, I chose 10234. Press Enter.

![](./images/kcptun/3.png)

Next, you need to input the IP. Using the default is fine. Press Enter.

![](./images/kcptun/4.png)

Now, you need to specify the port you want to accelerate. Here, you should input your **ss (shadowsocks) port**. For instance, mine is 447. Press Enter.

![](./images/kcptun/5.png)

Set the password for kcptun. For example, mine is abc123456. Press Enter.

![](./images/kcptun/6.png)

Next, configure the encryption method. You can choose either aes or no encryption. Here, I chose the default aes. Just press Enter.

![](./images/kcptun/7.png)

For the following options, just choose the default. Press Enter. ***Note**: When you get to the step of whether to turn off data compression, pause and input 'y' then press Enter to turn off data compression.

![](./images/kcptun/9.png)

![](./images/kcptun/10.png)

For the rest, just choose the default and press Enter. At the end, just press Enter to continue the installation.

![](./images/kcptun/11.png)

The installation process might take some time. Now's a good time for a cup of tea 🍵. After installation, the following screen will be displayed. **Remember to copy and save the parameters for the mobile side, you'll need them later**.

![](./images/kcptun/12.png)

At this point, the kcptun server configuration is completed. Finish your tea, take a break, and then proceed to the next steps.

# Configuring the kcptun client

## Taking Windows as an example

If you've followed and configured all the steps above correctly, it means your kcptun is set up. Next, is the client software configuration.

First, go to https://github.com/shadowsocks/kcptun/releases

Download your client software. For example, I use Windows 64-bit, so I need to download the file kcptun-windows-amd64-20170718.tar.gz.

![](./images/kcptun/13.png)

After downloading and extracting, copy `client_windows_amd64.exe` and rename the copy to `kcptun.exe`.

![](./images/kcptun/14.png)

Copy `kcptun.exe` to the same directory as `shadowsocks.exe`.

![](./images/kcptun/15.png)

Next, modify the shadowsocks configuration:

**1 Change to the kcptun port. Note: it's not your ss (shadowsocks) port**

**2 Change it to kcptun**

**3 Paste the previously copied mobile parameters into it**

Then confirm, restart ss and you should experience the accelerated effect.

![](./images/kcptun/17.png)

## Other clients

**MAC: The Mac shadowsocks client comes with the kcptun plugin. Just input kcptun and fill in the mobile parameters.**

![](./images/kcptun/mac.png)

**Android: First, search for kcptun in Google Play and install it. Then select the kcptun plugin and input the mobile parameters.**

![](./images/kcptun/android.jpg)

# Attention

1. Using kcptun consumes several times more data than usual. If you're using broadband, it's fine. But if you're using mobile data, be mindful of the data consumption.

# Contact

Email: zhaoweihao.dev@gmail.com

