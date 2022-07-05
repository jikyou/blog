---
title: Refactoring
date: 2017-10-08 22:19:00 +0800
tags:
- Java
- Refactoring
---

+ 重构是

> 在不改变软件可观察行为的前提下改善其内部结构。

## 案例

+   变量名称是代码清晰的关键。
+   最好不要在另一个对象的属性基础上运用 switch 语句。

## 重构原则

+   消除重复代码，确定所有事物和行为在代码中只表述一次。

### 何时重构

#### 三次法则

+   事不过三，三则重构。

#### 添加功能时重构

+   代码的设计无法帮助我轻松添加我所需要的特性。

#### 修补错误时重构

#### 复审代码时重构

### 重构的难题

+   数据库
+   修改接口
    +   不要过早发布接口，请修改你的代码所有权政策，使重构更顺畅。
+   难以通过重构手法完成的设计改动
+   何时不该重构

## 代码的坏味道

### Duplicated Code（重复代码）

+ Method

    + Extract Method (110)
    + Pull Up Method (332)
    + Form Template Method (345)
    + Substitute Algorithm (139)
    + Extract Class (149)

### Long Method （过长函数）

+ Method

    + Extract Method (110)
    + Replace Temp with Query (120)
    + Introduce Parameter Object (295)
    + Preserve Whole Object (135)
    + Decompose Condition (238)

### Long Class （过长的类）

+ Method

    + Extract Class (149)
    + Extract Subclass (330)
    + Extract Interface (341)
    + Duplicate Observed Data (189)

### Long Parameter List （过长参数列）

+ Method

    + Replace Parameter with Method (292)
    + Preserve Whole Object (288)
    + Introduce Parameter Object (295)

### Divergent Change （发散式变化）

+ 一个类受多种变化的影响。

+ 针对某一外界变化的所有相应修改，都只应该发生在单一类中，而这个新类内的所有内容都应该反应此变化。

+ Method
    
    + Extract Class (149)

### Shotgun Surgery （霰弹式修改）

+ 一个变化引起多个类相应的修改。

+ Method

    + Move Method (142)
    + Move Field (146)
    + Inline Class (154)

### Feature Envy（依恋情结）

+ 函数对某个类的兴趣高过对自己所处类的兴趣。
+ 一个函数会用到几个类的功能：判断哪个类拥有最多被此函数使用的数据，然后就把这个函数和那些数据摆在一起。

+ Method

    + Move Method (142)
    + Extract Method (110)

### Data Clumps （数据泥团）

+ 不必在意 Data Clumps 只用上新对象的一部分字段。

+ Method

    + Extract Class (149)
    + Introduce Parameter Object (295)
    + Preserve Whole Object (288)

### Primitive Obsession （基本类型偏执）

+ Method

    + Replace Data Value with Object (175)
    + Replace Type Code with Class (218)
    + Replace Type Code with Subclasses (223)
    + Replace Type Code with State/Strategy (227)

### Switch Statements （switch 惊悚现身）

+ Switch 语句的问题在于重复

+ Method

    + Extract Method (110)
    + Move Method (142)
    + Replace Type Code with Subclasses (223)
    + Replace Type Code with State/Strategy (227)
    + Replace Conditional with Polymorphism (255)
    + Replace Parameter with Explicit Methods (285)
    + Introduce Null Object (260)

### Parallel Inheritance Hierarchies （平行继承体系）

+ 让一个继承体系的实例引用另一个继承体系的实例

+ Method

    + Move Method (142)
    + Move Field (146)

### Lazy Class （冗赘类）

+ Method

    + Collapse Hierarchy (344)
    + Inline Class (154)

### Speculative Generality （夸夸其谈未来性）

+ 如果函数和类的唯一用户是测试用例。

+ Method

    + Collapse Hierarchy (344)
    + Inline Class (154)
    + Remove Parameter (277)
    + Rename Method (273)

### Temporary Field （令人迷惑的暂时字段）

+ Method

    + Extract Class (149)
    + Introduce Null Object (260)

### Message Chains （过度耦合的消息链）

+ 客户代码将与查找过程中的导航结构紧密结合。

+ Method

    + Hide Delegate (157)
    + Extract Method (110)
    + Move Method (142)

### Middle Man （中间人）

+ 过度使用委托。

+ Method

    + Remove Middle Method (160)
    + Inline Method (117)
    + Replace Delegation with Inheritance (355)

### Inappropriate Intimacy （狎xia昵ni关系）

+ 两个类过于亲密
+ Method

    + Move Method (142)
    + Change Bidirectional Association to Unidirectional (200)
    + Extract Class (149)
    + Hide Delegate (157)
    + Replace Inheritance with Delegation (352)

### Alternative Classes with Different Interfaces （异曲同工的类）

+ 如果两个函数做同一件事，却有着不用的签名。

+ Method

    + Rename Method (273)
    + Move Method (142)
    + Extract Superclass (336)

### Incomplete Library Class （不完美的库类）

+ Method

    + Introduce Foreign Method (162)
    + Introduce Local Extension (164) 

### Data Class （纯稚的数据类）

+ 不会说话的数据容器

+ Method

    + Encapsulate Field (206)
    + Encapsulate Collection (208)
    + Remove Setting Method (300)
    + Move Method (142)
    + Extract Method (110)
    + Hide Method (303)

### Refused Bequest （被拒绝的馈赠）

+ Method

    + Push Down Method (208)
    + Push Down Field (329)
    + Replace Inheritance with Delegation (352)

### Comments （过多的注释）

+ 当你感觉需要撰写注释时，请先尝试重构，试着让所有注释都变得多余。

+ Method

    + Extract Method (110)
    + Rename Method (273)
    + Introduce Assertion (267)

## 构筑测试体系

+ 频繁运行测试
+ 编写测试代码时，往往一开始先让它们失败
+ 每当收到 bug 报告时，请写一个单元测试来暴露这个 bug
+ 测试你最担心出错的部分
+ 考虑可能出错的边界条件 （包括特殊的，可能导致测试失败的情况）
+ 当事情被认为应该会出错时，别忘了检查是否抛出了预期的异常

## 重构列表

### 重构记录的格式

+ 名称 (name)
+ 概要 (summary)
+ 动机 (motivation)
+ 做法 (mechanics)
+ 范例 (examples)

### 重构手法有多成熟

+ 小步前进，频繁测试
+ 设计模式为重构行为提供了目标

## 重新组织函数

+ Extract Method （提炼函数）

    + 局部变量

+ Inline Method （内联函数）

+ Inline Temp （内联临时变量）

+ Replace Temp with Query （以查询取代临时变量）
