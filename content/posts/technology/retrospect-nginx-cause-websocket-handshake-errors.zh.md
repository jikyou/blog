---
title: 回顾 Nginx 配置问题导致 Websocket 握手错误
tags:
- Nginx
- Websocket
date: 2020-08-29 12:42:00 +0800
---

Websocket 协议是通过需要 http Upgrade 头切换过来的。

<!--more-->

## 事故

18 年的这个时候，作为公司官网的服务端，在上线时，出了一个事故。

官网上线后，首页的一个用来展示 Telegram 群组消息的功能用不了，这个功能是用 Websocket 实现的。我们在 Chrome 控制台发现一个报错 `failed: Error during WebSocket handshake: Unexpected response code: 404`

当时对 Websocket 和 Nginx 停留在能用的阶段，对其中的原理不甚了解。问题最后在秋哥的帮助下解决了这个问题。感谢秋哥。

当时在测试网上测试的时候并没有发现这个问题，我模糊的记忆里是由于测试网没有使用 Nginx 所以没有发现这个问题。

## 复现

现在我想对这个问题重新梳理一下，在本地模拟当时线上的情况，最终会有 `HTTPS + Nginx + Node Websocket Server`。

**[参考例子仓库](https://github.com/jkyochen/retrospect-nginx-cause-websocket-handshake-errors)**

### 准备一个带有 HTTPS 域名

我们使用 [mkcert](https://github.com/FiloSottile/mkcert) 来模拟本地 HTTPS。

```sh
# 生成 love.cat 的 HTTPS 证书用来给 Nginx 使用。
mkcert love.cat
```

### 修改 Host，让假域名只在本地解析

```sh
# 在 /etc/hosts 文件里添加下面一行，用来域名解析，强制解析到本地
127.0.0.1 love.cat
```

### 准备 Node Websocket Server

```js
app.ws("/chat", function (ws, req) {
    ws.send("Hello, World!");

    ws.on("close", function () {
        console.log("close");
        triggerSetInterval.closeInterval();
    });
});
```

### Nginx 配置

```conf
server {
    listen 443 ssl http2;
    server_name love.cat;

    ssl_certificate cert/love.cat.pem;
    ssl_certificate_key cert/love.cat-key.pem;

    location / {
        proxy_pass http://127.0.0.1:3000;
    }
}
```

### 启动

```sh
# 1. Start Node Server
node app.js

# 2. Start Nginx
nginx -p $PWD/etc/nginx/ -c nginx.conf
```

打开 `https://love.cat`，发现控制台报 Websocket 握手错误。

## 解决方法

通过在 `nginx.conf` 添加一些请求头和设置 HTTP 版本。

```conf
location /chat {
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "Upgrade";
    proxy_pass http://127.0.0.1:3000;
}
```

## 原因

参考 [NGINX as a WebSocket Proxy](https://www.nginx.com/blog/websocket-nginx/)

> There are some challenges that a reverse proxy server faces in supporting WebSocket. One is that WebSocket is a hop‑by‑hop protocol, so when a proxy server intercepts an Upgrade request from a client it needs to send its own Upgrade request to the backend server, including the appropriate headers. Also, since WebSocket connections are long lived, as opposed to the typical short‑lived connections used by HTTP, the reverse proxy needs to allow these connections to remain open, rather than closing them because they seem to be idle.

Nginx 没有直接对升级 Websocket 的请求做支持。但是可以通过手动加上请求头和版本号来支持 HTTP 切换 Websocet 请求。
