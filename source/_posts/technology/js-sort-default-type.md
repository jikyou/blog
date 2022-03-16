---
title: "[10, 2, 1].sort() 在 JS 中会输出什么"
tags: JavaScript
date: 2022-03-16 23:40:56 +0800
---

在准备面试题的时候，想起了一个在 18 年掉过的坑。关于 JavaScript 中 `Array.prototype.sort()` 的默认排序数据类型。

<!--more-->

（希望问别人这个问题，不会在背后被人骂。）

## 是什么

一些没掉过坑的同学，可能会说当然是 `[1, 2, 10]` 啦。

但是如果你看过 MDN 的关于 [`Array.prototype.sort()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/sort) 的文档，你就会知道这个结果是错误的，文档中的第一句话和第二例子就是对这个问题的描述。

那么，答案是什么呢，答案是 `[ 1, 10, 2 ]`。

为什么呢，看 MDN 原文：

> The default sort order is ascending, built upon converting the elements into strings, then comparing their sequences of UTF-16 code units values.

`sort()` 函数的默认排序是正序，以及排序的的时候会把所有元素都转化成字符串，然后再排序。

然而编译器为什么要这么做呢？

## 为什么

首先当然是语言的标准定义这么做的，编译器只是对标准的实现。在 JS 中这个标准就是 [ECMAScript](https://tc39.es/ecma262/multipage/) 。

在 [`Array.prototype.sort()`](https://tc39.es/ecma262/multipage/indexed-collections.html#sec-array.prototype.sort) 的标准定义中说：

```md
d. If comparefn is not undefined, then
    i. Let v be ? ToNumber(? Call(comparefn, undefined, « x, y »)).
    ii. If v is NaN, return +0𝔽.
    iii. Return v.
e. Let xString be ? ToString(x).
f. Let yString be ? ToString(y).
g. Let xSmaller be ! IsLessThan(xString, yString, true).
```

上面的意思是说，如果 sort 中没有传入比较函数，那么就将需要比较的元素，进行 `ToString()` 转化后在比较。

那么为什么标准需要这么处理呢？

这里我大胆的猜一猜，找一找借口...。

1. 首先 `sort()` 函数并不是指针对数字进行排序的，还有其他所有类型都可以传入，为了保证函数的语意明确，统一进行 `ToString()` 操作。
2. 其次我们看下 [`ToString()`](https://tc39.es/ecma262/multipage/abstract-operations.html#sec-tostring) 在规范中的定义，除了对 Symbol 类型调用 `ToString()` 会抛异常，其他类型都是可以使用 `ToString()` 转化的，所以这也是一个的把未知转化成已知类型的操作，非常干净。

所以为什么不对数字进行特殊处理呢？这就不知道了，不过我们可以站语言标准的制定者的角度思考的问题角度，你愿意在标准中让一些方法对一个类型进行特殊处理吗？

题外话，基于以上 `ToString()` 的例子，我想到有些很奇怪的面试考就是考你的对特殊类型的加号操作符会输出什么。

## 怎么做

那么就传入排序函数吧。

```js
[10, 2, 1].sort((a, b) => a - b);
```
