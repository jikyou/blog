---
title: 关于 if/else 和 for 的可读性问题
tags:
- Code Quality
- Refactoring
date: 2022-03-15 22:12:49 +0800
---

谈谈关于代码中 if/else 和 for 语句的可读性问题。

可读性意味着可维护性，可维护性又关联着个人和他人维护的效率。维护代码过程中，我们阅读代码的时间肯定要比写代码的时间长，部分决定了 Bug 需要花多长的时间去接口，所以可读性还是很重要的。

（在和朋友讨论的过程中，发生了一个争论，关于可读性和性能的优先级，从而有了重写这篇博客的想法。主要改动了结构和增加了关于可读性和性能的讨论。）

<!--more-->

## 问题

![](images/1.jpg)

首先看一张很久以前见过，非常耸人听闻的嵌套代码。图中代码的问题是，嵌套层级太深，会导致读代码读到中间的时候已经忘记之前的判定条件是什么。

在我们项目的代码里虽然没有这么夸张，但是嵌套三/四层有时候还是会见到的。虽然在早期公司商业模式没有验证，代码质量比较差可以理解，但是给后来的同学给出来不好的榜样。

所以我们的重构目标就是要去掉多层的缩进，减少阅读代码的负担。

## if/else

上面的例子太夸张，这里举一些简单一些的例子，重构手法是一致的。

### 例子一

这是一段做 EPUB 格式的电子书分发的代码。需要根据书的 id 查询出所有的电子书版本，然后判定书籍的电子版的有效性，有效的话需要去注册 ISBN 信息，注册成功的版本需要发出通知。

这里问题是有三层嵌套，要简化逻辑，我们要拆掉嵌套。

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

要拆嵌套，我们先想到的是可以把循环里面抽出一个函数出来。（这里的循环我们在下面重构）

```js
function distributeEpubs1(bookId) {
    let epubs = getEpubsByBookId(bookId);
    for (let epub of epubs) {
        distributeEpub(epub);
    }
}

function distributeEpub() {
    if (epub.isValid()) {
        let registered = registerIsbn(epub);
        if (registered) {
            sendEpub(epub);
        }
    }
}
```

其次 if 嵌套可以先把处理完的返回，一般都是先把错误情况处理完就返回。

```js
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

只有一层嵌套，非常漂亮。

### 例子二

这是一个网络聊天室，只有两个人都连接上才能聊天。这里还是嵌套的问题，还有 else 的问题。

```js
function ConnectPeer2Peer(pA, pB, manager) {
    if (pA.isConnected()) {
        manager.Prepare(pA);
        if (pB.isConnected()) {
            manager.Prepare(pB);
            if (manager.ConnectTogther(pA, pB)) {
                pA.Write("connected");
                pB.Write("connected");
                return S_OK;
            } else {
                return S_ERROR;
            }

        } else {
            pA.Write("Peer is not Ready, waiting...");
            return S_RETRY;
        }
    } else {
        if (pB.isConnected()) {
            pB.Write("Peer is not Ready, waiting...");
            return S_RETRY;
        } else {
            pA.Close();
            pB.Close();
            return S_ERROR;
        }
    }
}
```

按照我的习惯，会把有预期的错误都处理完，最后可以无嵌套的处理成功的情况。

```js
function ConnectPeer2Peer(pA, pB, manager) {

    if (!pA.isConnected() || !pB.isConnected()) {
        pA.Close();
        pB.Close();
        return S_ERROR;
    }

    if (pA.isConnected() && !pB.isConnected()) {
        manager.Prepare(pA);
        pA.Write("Peer is not Ready, waiting...");
        return S_RETRY;
    }

    if (!pA.isConnected() && pB.isConnected()) {
        manager.Prepare(pB);
        pB.Write("Peer is not Ready, waiting...");
        return S_RETRY;
    }

    if (!manager.ConnectTogther(pA, pB)) {
        return S_ERROR;
    }

    pA.Write("connected");
    pB.Write("connected");
    return S_OK;
}
```

### 例子三

这个坏味道在我们的代码中也比较常见，就是重复的 if/else 或者 switch/case 。

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

这里重复的问题是缺少关于 level 的模型，我们可以通过增加 UserLevel 的模型把重复的 if/else 去掉。我这里给出 typescrite 的版本，通过显示的接口说明对外屏蔽细节。

```typescript
interface IUserLevel {
    getBookPrice: (book: Book) => number
    getEpubPrice: (epub: Epub) => number
}

class RegularUserLevel implements IUserLevel {
    getBookPrice(book: Book) {
        return book.getPrice();
    }
    getEpubPrice(epub: Epub) {
        return epub.getPrice();
    }
}
class SilverUserLevel implements IUserLevel {
    getBookPrice(book: Book) {
        return book.getPrice() * 0.9;
    }
    getEpubPrice(epub: Epub) {
        return epub.getPrice() * 0.85;
    }
}
class GoldUserLevel implements IUserLevel {
    getBookPrice(book: Book) {
        return book.getPrice() * 0.8;
    }
    getEpubPrice(epub: Epub) {
        return epub.getPrice() * 0.85;
    }
}
class PlatinumUserLevel implements IUserLevel {
    getBookPrice(book: Book) {
        return book.getPrice() * 0.75;
    }
    getEpubPrice(epub: Epub) {
        return epub.getPrice() * 0.8;
    }
}

function getBookPrice(user: IUser, book: Book) {
    let level = user.getUserLevel()
    return level.getBookPrice(book);
}

function getEpubPrice(user: IUser, epub: Epub) {
    let level = user.getUserLevel()
    return level.getEpubPrice(epub);
}
```

[完整代码参考](https://github.com/jikyou/readable-about-if-else-for/blob/main/if-else-polymorphism/refactoring/example1.ts) / [js 版本](https://github.com/jikyou/readable-about-if-else-for/blob/main/if-else-polymorphism/refactoring/example1.js)

### 小结

1. 嵌套和 else 都是一种坏味道，能不写就不写。
1. 这种快速返回的处理方法叫卫语句，一般把容易处理的情况快速返回达到减少分支的目的，从而最后可以无嵌套的处理正常情况。
1. 重复的 if/else 可以通过多态屏蔽重复的代码。实现上通过接口屏蔽细节，在需要使用的时候根据类型传入相应的接口实现，从而让使用方不需要关系这些不同的类型。

## for

### 例子一

for 循环的问题是代码是过程式的，需要人脑一个元素一个元素的取出来去跑函数体，我们可以通过 map filter reduce 的写法达到声明式效果，只需要告诉程式要做什么而不是怎么做。

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

### 例子二

还有经常可以看到的代码是，一个循环里面做了太多的事情。

```js
let averageAge = 0;
let totalSalary = 0;
for (const p of people) {
  averageAge += p.age;
  totalSalary += p.salary;
}
averageAge = averageAge / people.length;
```

一般我们会把 for 循环里面做的不同的事情拆到不同的函数中去，这里例子在这里不太好，不过这不是我们的最终版本。

```js
let averageAge = 0;
let totalSalary = 0;
for (const p of people) {
  averageAge = calAverageAge(p.age, averageAge);
  totalSalary = calTotalSalary(p.salary, totalSalary);
}

function calAverageAge(age, totalAge) {
    return age + totalAge;
}
function calTotalSalary(salary, totalSalary) {
    return salary + totalSalary;
}

averageAge = averageAge / people.length;
```

有一个在大家看来比较激进的做法，用两个 for 循环去做这两件事，大家会担心性能的问题。有几个观点可以和大家讨论下。

1. 性能瓶颈是压测出来的，在一开始开发的时候，可以把可读性放到性能的前面。
1. 函数拆小后，可以提高可读性，一个函数只做一件事。
1. 函数拆小后，可以提供更高的复用性。

```js
let totalSalary = 0;
for (const p of people) {
  totalSalary += p.salary;
}

let averageAge = 0;
for (const p of people) {
  averageAge += p.age;
}
averageAge = averageAge / people.length;
```

### 小结

1. 通过一些基本的函数式函数 map filter reduce 来简化 for 循环，从而达到声明式写法的简洁。
1. 过程式是描述怎么做，声明式是描述做什么，抽象层级更高。
1. 某些情况我们可以拆分循环函数，把函数拆小，让函数只做一件事，因为只有小函数才有更有可能去复用。

## 总结

1. 我们可以通过卫语句，多态，声明式编程，降低代码的复杂度，提高的代码的可读性和可维护性。
1. 有一个方式可以计算一个函数的复杂度，叫做圈复杂度 [Cyclomatic complexity](https://en.wikipedia.org/wiki/Cyclomatic_complexity)。我们可以通过一些工具来检查代码是否有复杂度太高的函数。
    1. [Javascript ESLint](https://eslint.org/docs/rules/complexity#complexity)
    1. [Java Checkstyle](https://checkstyle.sourceforge.io/config_metrics.html#CyclomaticComplexity)
1. 更多例子可以参考 [Github 地址](https://github.com/jikyou/readable-about-if-else-for)。

## References

1. [重构（第2版）](https://book.douban.com/subject/30468597/)
    1. 以卫语句取代嵌套的条件表达式 [Replace Nested Conditional with Guard Clauses](https://refactoring.com/catalog/replaceNestedConditionalWithGuardClauses.html)
    1. 以多态取代条件表达式 [Replace Conditional with Polymorphism](https://refactoring.com/catalog/replaceConditionalWithPolymorphism.html)
    1. 以管道取代循环 [Replace Loop with Pipeline](https://refactoring.com/catalog/replaceLoopWithPipeline.html)
    1. 拆分循环 [Split Loop](https://refactoring.com/catalog/splitLoop.html)
1. [Refactoring Catalog](https://refactoring.com/catalog/)
1. [代码之丑](https://time.geekbang.org/column/intro/100068401)
1. [如何重构“箭头型”代码](https://coolshell.cn/articles/17757.html)
1. [编程的智慧](http://www.yinwang.org/blog-cn/2015/11/21/programming-philosophy)
