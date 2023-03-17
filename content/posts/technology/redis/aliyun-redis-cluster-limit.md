---
title: 阿里云集群模式下的 Redis 对 Lua 脚本存在限制
tags: 
- Redis
- Aliyun
date: 2023-03-17 19:54:35 +0900
---

去年年初工作时的一篇记录。

遇到一个关于 Redis 集群模式下的问题，是阿里云对 Lua 脚本的限制导致的，但是 `node-redlock` 包把错误吞掉了，抛出了一个重试失败的错误，导致我定位了好久…

被吞掉的错误信息：

```
-ERR bad lua script for redis cluster, all the keys that the script uses should be passed using the KEYS array
```

https://help.aliyun.com/document_detail/92942.htm?spm=a2c4g.11186623.0.0.2c555c7dYsASSH#section-8f7-qgv-dlv

## 解决方式

1. 在阿里云后台关闭 `script_check_enable` 这个设置。
2. 或者改造脚本，只向 Redis 传递对 KEYS 的引用，而不是变量。

## 反思自我的问题

未知的错误，网上搜索不到直接的解决方案，加上定位问题的时间不够，导致我没有定位问题的耐心，非常焦躁，希望有人可以帮我解决掉问题...

另一方面没有从原理的角度去思考，`node-redlock` 只是调用 Redis 的库，他的问题会有哪些地方。
