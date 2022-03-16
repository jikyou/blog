---
title: MetaprogrammingRuby
date: 2018-02-11 16:53
tags: Ruby
---

## The Object Model

### Open Classes

#### Inside Class Definitions

+ `class` 关键字的核心任务是把你带到类的上下文中，让你可以在里面定义方法
+ 重新打开已存在的类并对之进行动态修改。

#### The Problem with Open Classes

+ 打开 `irb` 命令行解释器 `[].methods.grep /^re/` 查找 Arrays 类中所有以 `re` 开头的方法。
+ 覆盖原有的 replace 方法
+ 猴子补丁 (Monkeypatch)

### Inside the Object Model

#### Inside the Object Model

+ 一个对象的实例变量存在于对象本身之中，而一个对象的方法存在对象本身的类中。

#### The Truth About Classes

+ 类本身也是对象。
+ 类像其他对象一样，也有自己的类，它的名字就是 `Class`。


