---
layout: post
title: 浏览器打开 Goog​​le.com 中涉及的 DNS 查找
tags: Network DNS
date: 2020-03-29 14:54 +0800
---
## DNS 查询路径

1. 从浏览起缓存里找。
2. 从系统缓存里找。
3. 从系统 Host 里找。
4. 从系统配置的 DNS 服务器缓存找。
    1. 使用路由器提供的公共 DNS。
    2. 使用用户自己修改的公共 DNS。
    3. 使用运营商提供的 Local DNS。
5. 转发 DNS。如果本地缓存没有相应的域名结果，将查询请求转发给另外一台 DNS 服务器。
6. 递归 DNS。从根域名 “.” 服务器，顶级域名服务器（“.com”），一级域名服务器（“google.com”）等一级一级递归查询，直到最终找到权威服务器取得结果。

## 浏览器缓存

### Firefox(v74.0)

`about:config` 中的相关设置是 `network.dnsCacheEntries` 和 `network.dnsCacheExpiration`，默认都是 60s。

### Chrome(v80.0.3987.149)

关于 Chrome DNS 缓存多久，没有找到具体的来源。这个问题 [how-long-google-chrome-and-firefox-cache-dns-records](https://stackoverflow.com/questions/36917513/how-long-google-chrome-and-firefox-cache-dns-records) 说是 60s。

`chrome://net-internals/#dns` 可以清理缓存。

## 系统缓存

本地系统的缓存通常是 1 小时，根据与 DNS 记录关联的 TTL，本地解析 DNS 服务器的缓存可以运行数天。

[Default Time To Live (TTL) values](https://web.archive.org/web/20150206054041/http://www.binbert.com/blog/2009/12/default-time-to-live-ttl-values/)

[关于各个系统如何清理 DNS](https://stackoverflow.com/a/17757735/7275527)
