---
title: Client-Side JavaScript
date: 2017-09-16 08:28:00 +0800
tags:
- JavaScript
- Book
---

# Web 浏览器中的 JavaScript

## 客户端 JavaScript

+ Window对象是所有客户端 JavaScript 特性和API的主要接入点。

+ Window 对象有一个引用自身的属性，叫做 window。

+ Window 对象中其中一个最重要的属性是 document，它引用 Document 对象。

+ JavaScript 在 Web 应用里会比在 Web 文档里显得更加重要。JavaScript 增强了 Web 文档，但是设计良好的文档需要在禁用 JavaScript 后还能继续工作。
+ Web 应用本质上就是 JavaScript 程序，后者使用由 Web 浏览器提供的操作系统类型的服务，并且不用期望它们在禁用浏览器脚本后还能正常工作。

## 在 HTML 里嵌入 JavaScript

1. 内联，放置在 `<script>` 和 `</script>` 标签对之间
2. 放置在由 `<script>` 标签的 src 属性指定的外部文件中 （结束的 `</script>` 不能丢）
3. 放置在 HTML 事件处理程序中
4. 放在一个 URL 中，这个 URL 使用特殊的 "javascript:" 协议

+ 内容 （HTML）和行为 （JavaScript 代码） 应该尽量地保持分离。

+ `<script>` language 属性已经被废弃，不应该再使用了。

## JavaScript 程序的执行

+ 两个阶段

    + 载入文档内容
    + 异步的，由事件驱动的。

+ 核心 JavaScript 和客户端 JavaScript 都有一个单线程执行模型。脚本和事件处理程序（无论如何）在同一个时间只能执行一个，没有并发性。

+ deferred.js 使得浏览器延迟脚本的执行，知道文档的载入和解析完成。
+ async.js 是的浏览器可以尽快地执行脚本，而不用在下载脚本时阻塞文档解析。

+ 时间线

    + document.readyState 属性的值是 "loading"
    + 当 HTML 解析器遇到没有 async 和 defer 属性
    + 当解析器设置了 async 属性的 `<script>` 元素时
    + 文档解析完成，document.readyState 属性变成 "interactive"
    + 执行所有由 defer 属性的脚本
    + 浏览器在 Document 对象上触发 DOMContentLoaded 事件，标志程序执行从同步脚本执行阶段转换到了异步事件驱动阶段。
    + 文档完全解析完成，浏览器等待其他内容载入
    + 调用异步事件

## 兼容性和互用性

+ 功能检测
+ 怪异模式和标准模式
+ 浏览器测试
+ Internet Explorer 里的条件注释
+ 可访问性

## 安全性

+ JavaScript 不能做什么
+ 同源策略

    + 脚本只能读取和所属文档来源相同的窗口和文档的属性。
    + 文档来源包含协议，主机，以及载入文档的 URL 端口。

+ 脚本化插件和 ActiveX 控件
+ 跨站脚本
+ 拒绝服务攻击

## 客户端框架

+ jQuery
+ Prototype
+ Dojo
+ YUI
+ Closure
+ GWT

# Window 对象

## 计时器

```js
var t = setTimeout(updateClock, 6000) // 指定时间调用
clearTimeout(t) // 取消函数的执行
setInterval() // 重复调用
clearInterval() // 取消函数的后续调用
```

## 浏览器定位和导航
