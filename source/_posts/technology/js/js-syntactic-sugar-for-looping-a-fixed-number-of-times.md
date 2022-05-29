---
title: JS 中实现循环固定次数的语法糖
tags: JavaScript
date: 2022-05-29 21:57:48 +0800
---

有一些场景需要循环固定次数来执行一些操作，比如失败重试固定次数，制造固定数量的假数据等。

在 JS 中实现的时候，我一直使用最简单的 for 版本，但是一方面他是我代码中为数不多的声明式的循环写法，同时也产生了不必要的变量，相比声明式的写法可读性也稍微差一些。

<!--more-->

之前一直使用的循环版本。

```js
for (let i = 1; i < 10; i++) {
    doSomething();
}
```

在其他语言中，比如 Ruby 中可以这么实现。

```ruby
5.times { print "1" }
```

漂亮的声明式写法。

最近在写 JS 中又遇到这个问题，搜索一番，综合各家方案，我选择一个具有声明式，同时可读性也不差的写法。

```js
Array.from({length: 3}).map(() => doSomething());
```

当然所有简化写法的目标都是围绕着制造一个有固定数量的 undefined 元素的数组而做的。

更简洁但是可读性差一些的方案。

```js
[...Array(3)].map(() => doSomething());
```

## References

https://stackoverflow.com/questions/30452263/is-there-a-mechanism-to-loop-x-times-in-es6-ecmascript-6-without-mutable-varia
