---
title: HTML5 秘籍
date: 2017.05.10 11:22
tags: HTML5

---

# HTML5 秘籍

## 2 构建网页新方式

### 2.3 语义元素

+ `<header>` 页眉, `<footer>` 页脚, `<article>` 文章
+ `<hgroup>` 副标题
+ `<figure>` 插图, `<figcaption>` 图题

    + `<img>` 中的元素 alt 不能设置为空字符串。这意味者你的图片纯粹是装饰用的，屏幕阅读器会忽略不读。
+ `<aside>` 与周围文本没有密切相关的内容。页面中一个完全独立的区块，作为页面主要内容的陪衬。如：附注

### 2.4 使用语义元素

+ 网页中可以包含多个 <header> 元素（通常应该如此），即使相应的区块在页面中角色不一样。
+ 独立区块完全可以重新建立标题级别。（多个 `<h1>` ）
+ `<nav>` 包装一组链接，通常只用于页面中最大主要的导航区
+ `<section>` 适合任何以标题开头的内容区块

    + 与页面主体内容并列显示的小内容块
    + 独立性内容
    + 分组内容
    + 比较长的文档中的一部分
+ `<details>`, `<summary>` 折叠框

### 2.5 HTML5 纲要

## 有意义的标记

+ 使用  `<time>` 标注日期和时间

    ```Java
    The party starts <time datetime="2012-03-21T16:30+8:00">March 21<sup>st</sup>at 4:30 p.m.</time>
    // +8:00 代表时区
    
    Published on <time datetime="2011-03-21" pubdate>March 31, 2011</time>
    // pubdate 当前内容对应一个发表日期
    ```

+ `<output>` 标注 JavaScript 返回值
+ `<mark>` 标注突显文本（添加黄色背景），标注重要的内容或关键字

### 其他语义标准

#### ARIA 无障碍富因特网应用

#### RDFa 资源描述框架

#### Microformats 微格式

#### Microdata 微数据

### Google Rich Snippets

+ SEO（Search Engine Optimization，搜索引擎优化）
+ [结构化数据测试工具](https://search.google.com/structured-data/testing-tool)

