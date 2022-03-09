---
title: 「团队分享」如何重构滥用控制语句循环语句的代码？
tags:
    - Code Quality
    - Refactoring
date: 2022-03-07 22:48 +0800
---

代码首选是写给人看的（包括自己），其次才是给机器运行的，所以可读性很重要。（当然这里不包括写完就扔的代码）

<!--more-->

## 问题

![](assets/img/16465519953875.jpg)

上述代码的问题是，嵌套层级太深，会导致读代码读到中间的时候已经忘记之前的判定条件是什么。

## 目标

所以我们的目标就是要去掉多层的缩进，减少阅读代码的负担。

## 坏味道一 if/else 嵌套

### 例子一

```js
function distributeEpubs(bookId) {
    let epubs = getEpubsByBookId(bookId);
    for (let epub of epubs) {
        if (epub.isValid()) {
            let registered = registerIsbn(epub);
            if (registered) {
                sendEpub(epub);
            }
        }
    }
}
```

通过抽出独立的函数快速返回去掉 if 嵌套，重构后：

```js
function distributeEpubs1(bookId) {
    let epubs = getEpubsByBookId(bookId);
    for (let epub of epubs) {
        distributeEpub(epub);
    }
}

function distributeEpub() {
    if (!epub.isValid()) {
        return;
    }
    let registered = registerIsbn(epub);
    if (!registered) {
        return;
    }
    sendEpub(epub);
}
```

### 例子二

```js
function getPayAmount() {
    let result;
    if (isDead) {
        result = deadAmount();
    } else {
        if (isSeparated) {
            result = separatedAmount();
        } else {
            if (isRetired) {
                result = retiredAmount();
            } else {
                result = normalPayAmount();
            }
        }
    }
    return result;
}
```

通过快速返回去掉 if/else 嵌套，重构后：

```js
function getPayAmount1() {
    if (isDead) {
        return deadAmount();
    }
    if (isSeparated) {
        return separatedAmount();
    }
    if (isRetired) {
        return retiredAmount();
    }
    return normalPayAmount();
}
```

### 方法论

1. 以卫语句取代嵌套的条件表达式 [Replace Nested Conditional with Guard Clauses](https://refactoring.com/catalog/replaceNestedConditionalWithGuardClauses.html)。
2. 这种快速返回的处理方法叫卫语句，一般把容易处理的情况快速返回达到减少分支的目的。
3. 遇到需要处理的异常情况比较多，通过把异常流程快速返回，最后处理正常流程。

## 坏味道二 for 循环

for 循环的问题是代码是过程式的，需要人脑一个元素一个元素的取出来去跑函数体，我们可以通过 map filter reduce 达到声明式效果。

### 例子

```js
function toParameters(chapters) {
    let parameters = [];
    for (const chapter of chapters) {
        if (chapter.isApproved()) {
            parameters.add(toChapterParameter(chapter));
        }
    }
    return parameters;
}
```

通过 filter map 重构后：

```js
function toParameters(chapters) {
    return chapters
        .filter(chapter => chapter.isApproved())
        .map(chapter => toChapterParameter(chapter));
}
```

### 方法论

1. 以管道取代循环 [Replace Loop with Pipeline](https://refactoring.com/catalog/replaceLoopWithPipeline.html)。
2. 通过一些基本的函数式函数 map filter reduce 来简化 for 循环，从而达到声明式写法的简洁。

> 过程式是描述怎么做，声明式是描述做什么，抽象层级更高。

## 坏味道三重复的 switch/case

代码中有时候会出现很多重复的 switch/case，这时候我们要通过多态的方式来去掉 switch/case。

### 例子

```js
function getBookPrice(user, book) {
    let price = book.getPrice();
    switch (user.getLevel()) {
        case UserLevel.SILVER:
            return price * 0.9;
        case UserLevel.GOLD:
            return price * 0.8;
        case UserLevel.PLATINUM:
            return price * 0.75;
        default:
            return price;
    }
}

function getEpubPrice(user, epub) {
    let price = epub.getPrice();
    switch (user.getLevel()) {
        case UserLevel.SILVER:
            return price * 0.95;
        case UserLevel.GOLD:
            return price * 0.85;
        case UserLevel.PLATINUM:
            return price * 0.8;
        default:
            return price;
    }
}
```

通过多态的方式抽象后：

```js
class RegularUserLevel {
    getBookPrice(book) {
        return book.getPrice();
    }
    getEpubPrice(epub) {
        return epub.getPrice();
    }
}
class GoldUserLevel {
    getBookPrice(book) {
        return book.getPrice() * 0.8;
    }
    getEpubPrice(epub) {
        return epub.getPrice() * 0.85;
    }
}
class SilverUserLevel {
    getBookPrice(book) {
        return book.getPrice() * 0.9;
    }
    getEpubPrice(epub) {
        return epub.getPrice() * 0.85;
    }
}
class PlatinumUserLevel {
    getBookPrice(book) {
        return book.getPrice() * 0.75;
    }
    getEpubPrice(epub) {
        return epub.getPrice() * 0.8;
    }
}

function getBookPrice(user, book) {
    let level = user.getUserLevel()
    return level.getBookPrice(book);
}

function getEpubPrice(user, epub) {
    let level = user.getUserLevel()
    return level.getEpubPrice(epub);
}
```

### 方法论

1. 以多态取代条件表达式 [Replace Conditional with Polymorphism](https://refactoring.com/catalog/replaceConditionalWithPolymorphism.html)。
2. 面向对象比较常见的抽象方式，在使用的时候传入

## 检查工具

1. 有一个方式可以计算一个函数的复杂度，叫做圈复杂度 [Cyclomatic complexity](https://en.wikipedia.org/wiki/Cyclomatic_complexity)。
2. 我们可以通过一些工具来检查代码是否有复杂度太高的函数。
    1. [Javascript ESLint](https://eslint.org/docs/rules/complexity#complexity)
    1. [Java Checkstyle](https://checkstyle.sourceforge.io/config_metrics.html#CyclomaticComplexity)

## 总结

1. 我们可以通过上述几种方式来减少 if/else 嵌套，旧风格的 for 循环，重复的 switch/case，从而降低代码的复杂度，提高的代码的可读性和可维护性。
1. 更多例子可以参考 [Github 地址](https://github.com/lanlyhs/refactoring-abuse-control-and-loop-statements)。

## References

1. [重构（第2版）](https://book.douban.com/subject/30468597/)
1. [Refactoring Catalog](https://refactoring.com/catalog/)
1. [代码之丑](https://time.geekbang.org/column/intro/100068401)
1. [如何重构“箭头型”代码](https://coolshell.cn/articles/17757.html)
1. [编程的智慧](http://www.yinwang.org/blog-cn/2015/11/21/programming-philosophy)
