---
title: 总结命令行代理的方式
tags:
- CommandLine
  - Proxy
date: 2021-03-06 18:10:00 +0800
---

目前我主要通过 export 和软件的方式，来代理。

<!--more-->

## 一、Export 命令

```sh
export https_proxy=http://my.local:6152
export http_proxy=http://my.local:6152
export all_proxy=socks5://my.local:6153
```

1. 可以设置到 `.profile` 为当前用户配置代理。
2. 通过设置 `/etc/environment` 文件为所有用户代理。

> [Mac OSX 终端走 shadowsocks 代理](https://github.com/mrdulin/blog/issues/18)

### 缺点

1. `git` `npm` 的代理需要单独设置。
    + zsh 可以通过参考这个插件简化设置。[zsh-proxy](https://github.com/SukkaW/zsh-proxy)

2. 由于工作在表示层，所以只能代理应用层的协议，代理不了网络层的协议，可以通过下面的软件来解决。

## 二、软件的严格模式

通过以下两款软件提供的严格模式，可以实现类似 VPN 全局代理的效果。

+ [Clashx Pro](https://install.appcenter.ms/users/clashx/apps/clashx-pro/distribution_groups/public)
+ [Surge](https://nssurge.com/)

大概的原理是通过建立一个虚拟 IP，同时让所有流量转发到这个 IP，从而实现给所有流量代理包括网络层的协议。
