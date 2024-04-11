---
title: Ruby 中的 `Array.new` 中的默认值参数，指向的同一个对象
tags:
- Ruby
date: 2024-04-11T15:32:42+09:00
---

今天写 Ruby 遇到的小坑，最后在测试下发现问题，仔细查看文档发现是我理解错了。

## What

在做 Advent Of Code [这一题](https://adventofcode.com/2015/day/6)的时候，需要构建一个比较大的初始值为 false 的二维数组。

本来打算双重循环构建的，但想想 Ruby 的语法糖这么多的语言应该有更加便利的方式。

于是找到了，`Array.new`，构建了如下的初始化表达式。

`Array.new(1000, Array.new(1000, false))`

但是遇到一个奇怪的问题，在修改二维数组中某一个值的时候，导致其他二维数组的同一个位置也会跟着修改。

## Why

重现问题并验证。

```rb
a = Array.new(3, Array.new(3, false))
# => [[false, false, false], [false, false, false], [false, false, false]]
a[0][0] = true
# => [[true, false, false], [true, false, false], [true, false, false]]
a[0].equal?(a[1])
# true
```

子数组是同一个数组，导致修改一个子数组，其他数组也会跟着修改。

查看[原始文档](https://ruby-doc.org/3.2.2/Array.html#method-c-new)，发现确实是说默认值是同一个。

## How

```rb
Array.new(1000) { Array.new(1000, false) }
```

## Summary

导致理解错了的原因可能是，我还没有转化到 Ruby 中一切皆对象的思维，不再区分什么是基础类型，对象类型。在这个例子中我还在下意识的认为会对传统意义上的对象做特殊处理。

还是 Ruby 代码写的太少了，要多写写，习惯这种一切皆对象的思维方式。
