---
title: 使用 nrm 来切换 npm 源
tags: npm
date: 2021-07-03 12:06 +0800
---

一般公司都会自建 npm 源，而在家使用公司的源需要连接 VPN，非常的麻烦。

之前在第三极的时候使用 [nrm](https://github.com/Pana/nrm) 来切换 npm 源，非常方便。记录一下，我的老年人记忆。

<!--more-->

## 新增源

```sh
nrm add example https://registry.npm.example.com
```

## 查看所有源

```sh
nrm ls
```

## 对所有所有源测速

```sh
nrm test
```
