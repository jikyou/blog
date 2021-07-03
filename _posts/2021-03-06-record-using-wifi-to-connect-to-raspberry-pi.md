---
layout: post
title: 记录使用 WIFI 连接树莓派
tags: RaspberryPi
date: 2021-03-06 17:20 +0800
---
前年玩过树莓派，今天又开始玩的时候，又重复踩坑了，记录一下，不再浪费时间了...

## 准备系统

使用 [Raspberry Pi Imager](https://www.raspberrypi.org/software/) 或者 [Etcher](https://www.balena.io/etcher/) 安装。

## 设置 WIFI

1. 在 SD 卡的根目录（boot）建立 `wpa_supplicant.conf` 文件。
2. 在文件中输入 WIFI 的信息。

```conf
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="SCHOOLS NETWORK NAME"
    psk="SCHOOLS PASSWORD"
    id_str="school"
}

network={
    ssid="HOME NETWORK NAME"
    psk="HOME PASSWORD"
    id_str="home"
}
```

> [Setting up a Raspberry Pi headless](https://www.raspberrypi.org/documentation/configuration/wireless/headless.md)
>
> [Setting up a wireless LAN via the command line](https://www.raspberrypi.org/documentation/configuration/wireless/wireless-cli.md)

## 开启 SSH

1. 在 SD 卡的根目录（boot）建立 `ssh` 文件。

> [SSH (Secure Shell)](https://www.raspberrypi.org/documentation/remote-access/ssh/README.md)

## 连接

```sh
# test
ping raspberrypi.local

# ssh
ssh pi@raspberrypi.local
# password: raspberry

# Copy public key
ssh-copy-id pi@raspberrypi.local
```

> [SSH using Linux or Mac OS](https://www.raspberrypi.org/documentation/remote-access/ssh/unix.md)

## 代理

```sh
sudo vi /etc/environment

# 输入代理信息
export http_proxy="http://username:password@proxyipaddress:proxyport"
export https_proxy="http://username:password@proxyipaddress:proxyport"
export no_proxy="localhost, 127.0.0.1"
# Like this
# export http_proxy="http://computer.local:6152"

# 重启
sudo reboot

# Test
curl google.com
```

> [Using a proxy server](https://www.raspberrypi.org/documentation/configuration/use-a-proxy.md)
