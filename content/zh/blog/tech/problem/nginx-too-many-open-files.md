---
title: Nginx Too many open files
tags:
- Nginx
date: 2022-01-15T23:22:00+08:00
---

工作中遇到两次 Nginx 报 24: Too many open files，每次都给业务带来一些损失，记录一下。

<!--more-->

## 问题

报错原因是达到句柄限制，一般是 Nginx 配置问题。

## 解决方案

### 1. 系统句柄设置

```md
# /etc/security/limits.conf
```

### 2. /etc/nginx/nginx.conf

```md
# worker_rlimit_nofile 30000;
# https://nginx.org/en/docs/ngx_core_module.html#worker_rlimit_nofile
```

### 3. 使用 Systemd 管理的进程需要额外的设置进程的句柄数量

```md
# /etc/systemd/system/nginx.service
# LimitNOFILE=500000
```

## References

[Nginx socket() failed (24: Too many open files)](https://www.claudiokuenzler.com/blog/850/nginx-socket-failed-24-too-many-open-files)
