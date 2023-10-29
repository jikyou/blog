---
title: DOM Scripting
date: 2017-06-06T16:55:00+08:00
tags:
- JavaScript
---

# JavaScript 简史

## JavaScript 的起源

+ `ECMA` 欧洲计算机制造商协会
+ `BOM` 浏览器对象模型

## DOM

+ DOM 是一套对文档的内容进行抽象和概念化的方法。

## 浏览器战争

### DHTML

+ `DHTML` Dynamic HTML(动态 HTML )的简介。

    + 描述 HTML，CSS，和 JavaScript 技术组合的术语。

### 浏览器之间的冲突

```JavaScript
// Netscape Navigator 4 浏览器
var xpos = document.layers['myelement'].left;

// IE 4
var xops = document.all['myelement'].leftpos;
```

## 指定标准

```JavaScript
var xpos = document.getElementById('myelement').style.left;
```

### 浏览器以外的考虑

+ DOM 是一种 API （应用编程接口）

    + API 就是一组已经得到有关各方共同认可的基本约定。
    + 在现实世界中，相当于 API 的例子包括摩尔斯码，国际时区，化学元素，周期表。

+ W3C 对 DOM 的定义是“一个与系统平台和编程语言无关的接口，程序和脚本可以通过这个接口动态地访问和修改文档的内容，结构和样式。”

### 浏览器战争的结局

+ WaSP Web标准计划的小组应运而生。

### 崭新的起点

+ WebKit 是 Safari 和 Chrome 采用的一个开源 Web 浏览器引擎。
+ Gecko 是 Firefox 的核心。
+ Trident 是 IE 的核心。

# JavaScript 语法

## 准备工作

+ JavaScript 编写的代码的位置

    + 放在文档 `<head>` 标签中的 `<script>` 标签之间
    + 存为一个扩展名为 .js 的独立文件。典型的做法是在文档的 `<head>` 部分放一个 `<script>` 标签，并把它的 src 属性指向该文件。
    + 最好的做法是把 `<script>` 标签放到 HTML 文档的最后，`</body>` 标签之前。这样能使浏览器更快地加载页面。

+ `<script>` 脚本默认是 JavaScript，梅比哟啊指定 type

+ 对于 JavaScript 语言，在互联网环境下，Web 浏览器负责完成有关的解释和执行工作。浏览器中的 JavaScript 解释器将直接读入源代码并执行。
+ 解释型语言代码中的错误只有等到解释器执行到有关代码时才能发现。

## 语法

+ 英语是一种解释型语言。

### 语句

+ 建议在每条语句的末尾都加上一个分号。
+ 让每条语句独占一行的做法能更容易跟踪 JavaScript 脚本的执行顺序。

### 注释

```JavaScript
//

/*
*/

// HTML 风格的注释，但这种做法适用于单行注释
<!--  // JavaScript 解释器对 `<!--` 和 `//` 的处理一样。

<!-- --> // HTML 注释可以多行

// 建议使用上面两种
```

### 变量

+ 虽然 JavaScript 没有强制要求程序员必须提前声明变量（未声明变量，赋值操作将自动声明该变量），但提前声明变量是一种良好的编程习惯。

```JavaScript
var mood = "happy", age = 33; // 一条语句
```

+ 变量和其他语法元素的名字都是区分字母大小写的。
+ 不允许变量名中包含空格或标点符号（美元符号 "$" 例外）
+ JavaScript 变量名允许包含字母，数字，美元符号和下划线（但第一个字符不允许是数字）
    + 为了让比较长的变量名更容易阅读，可以在变量名中的适当位置插入下划线。
    + 另一种方式是驼峰格式（camel case）

+ 驼峰格式是函数名，方法名和对象属性名命名的首选格式。

### 数据类型

+ 弱类型 可以在任何阶段改变变量的数据类型。

#### 字符串

+ 字符串由零个或多个字符构成。字符包括（但不限于）字母，数字，标点符号和空格。

```JavaScript
// 转义（escaping）
var mood = 'don\'t ash';
var height = "about 5'10\" tall";
```

+ 不管选择用双引号还是单引号，请在整个脚本中保持一致。

#### 数值

#### 布尔值

+ 从某种意义上讲，为计算机设计程序就是与布尔值打交道。作为最基本的事实，所有的电子电路只能识别和使用布尔数据：电路中有电流或是没有电流。

### 数组

+ 字符串，数值和布尔值都是标量（scalar）。

```JavaScript
// Array 关键字声明
var beatles = Array(4); // 长度
var beatles = Array(); // 可变长

beatles[0] = "John";

var beatles = Array("John", "Paul", "George", "Ringo");
var beatles = ["John", "Paul", "George", "Ringo"];
var lennon = ["John", 1940, false]; // 3 种数据类型混在一起存入一个数组
```

+ 存放数据的首选方式：将数据保存为对象。

#### 关联数组

+ 如果在填充数组时只给出了元素的值，这个数组就将是一个传统数组，它的各个元素的下标将自动创建和刷新。
+ 可以通过在填充数组时为每个新元素明确地给出下标来改变这种默认的行为。在为新元素给出下标时，不必局限于使用整数数字。

```JavaScript
// 可以使用字符串
var lennon = Array();
lennon["name"] = "John";
lennon["year"] = 1940;
lennon["living"] = false;
// 关联数组。由于可以使用字符串来代替数字值，因而代码更具有可读性。
// 但是这种方法不是个好习惯，不推荐使用。
```

+ 所有的变量实际上都是某种类型的对象。（一个布尔值就是一个 Boolean 类型的对象，一个数组就是一个 Array 类型的对象。）
+ 本质上，在创建关联数组时，你创建的是 Array 对象的属性。理想情况下，不应该修改 Array 对象的属性，而应该使用通用的对象。

### 对象

+ 对象的每个值都是对象的一个属性。

```JavaScript
// 创建对象使用 Object 关键字
var lennon = Object();
lennon.name = "John";
lennon.year = 1940;
lennon.living = false;

// 花括号语法
{ propertyName:value, propertyName:value }

var lennon = { name:"John", year:1940, living:false };
// 属性名与 JavaScript 变量的命名规则有相同之处，属性值可以是任何 JavaScript 值，包括其他对象。
```

+ 用对象来替代传统数组的做法意味着可以通过元素的名字而不是下标数字来引用它们。这大大提高了脚步的可读性。

## 操作

### 算术运算符

```JavaScript
year = year + 1;
year++;
year--;

// 数值和字符串拼接在一起，数值将被自动转换为字符串：
var year = 2005;
var message = "The year is " + year;
message += year;
```

## 条件语句

```JavaScript
if (condition)
{
    statements;
} else
{
}

// 如果 if 语句中的花括号部分只包含着一条语句的话，那就可以不使用花括号。
if (1 > 2) alert("The world has gone mad!");
```

+ 花括号可以提高脚本的可读性，所以在 if 语句中总是使用花括号是个好习惯。

### 比较操作符

+ 单个等号（=）是用于完成赋值操作的。如果在条件语句的某个条件里使用了单个等号，那么只要相应的赋值操作取得成功（且这个值不是 false），那个条件的求职结果就将是 true。

```JavaScript
ToNumber(false) === ToNumber("") // 都是 0 ，Number(false);
```

### 逻辑操作符

## 循环语句

```JavaScript
do
{
    statements;
} while (condition);

initialize;
while (condition)
{
    statements;
    increments;
}

for (initial condition; test condition; alter condition)
{
    statements;
}
```

## 函数

+ 函数（funtion）就是一组允许在你的代码里随时调用的语句。事实上，每个函数实际上是一个短小的脚本。
+ 作为一个良好的编程习惯，应该对函数作出定义再调用它们。
+ 内建函数 alert(argument);

+ 函数的真正价值体现在，我们还可以把它们当作一种数据类型来使用，这意味着可以把一个函数的调用结果赋值给一个变量。
+ 函数名 驼峰命名法

### 变量的作用域

+ 全局变量的作用域是整个脚本。
+ 局部变量的作用域仅限于某个特定的函数。
+ var 关键字明确地为函数变量设定作用域。
+ 如果没有使用 var ，那个变量就将被视为一个全局变量。

+ 函数在行为方面应该像一个自给自足的脚本，在定义一个函数时，我们一定要把它内部的变量全都明确地声明为局部变量。避免任何形式的二义性隐患。

## 对象

+ 对象是自包含的数据集合，包含在对象里的数据可以通过两种形式访问——属性（property）和方法（method）

    + 属性是隶属于某个特定对象的变量
    + 方法是只有某个特定对象才能调用的函数

+ 对象就是由一些属性和方法组合在一起而构成的一个数据实体。

```JavaScript
// 在 JavaScript 里，属性和方法都使用“点”语法来访问
Object.property
Object.method()

// 实例 是对象的具体个体
var jeremy = new Person;
```

+ 用户定义对象（user-defined object）
+ 内建对象（native object）

### 内建对象

```JavaScript
// 数组就是其中一种内建对象。
// 创建一个 Array 对象的实例
var beatles = new Array();

Math.routnd(7.561);

var current_date = new Date();
```

### 宿主对象

+ 由浏览器提供的预定义对象被称为宿主对象（host object）
+ Form, Image, Element
+ document

# DOM

## 文档：DOM 中的“D”

+ document
+ 把编写的网页文档转换为一个文档对象

## 对象：DOM中的“O”

+ JavaScript 语言里的对象可以分为三种类型

    + 用户定义对象（user-defined object）
    + 内建对象（native object），内建在 JavaScript 语言里的对象，如 Array,Math,Date等
    + 宿主对象（host object）浏览器提供的对象

        + window 对象对应着浏览器窗口本身，这个对象的属性和方法通常称为 BOM （浏览器对象模型），Window Object Model（窗口对象模型）

## 模型：DOM 中的“M”

+ 节点树

## 节点

+ 文档是由节点构成的集合

+ 三种 元素节点，文本节点，属性节点

### 元素节点

+ DOM 的原子是元素节点。
+ 标签的名字就是元素的名字。
+ 根元素 `<html>`

### 文本节点

+ 在XHTML文档里，文本节点总是被被包含在元素节点的内部。但并非所有的元素节点都包含文本节点。

### 属性节点

+ 用来对元素做出了更具体的描述。

### CSS

```CSS
selector
{
    property: value;
}
```

+ 继承（inheritance），节点树上的各个元素将继承其父元素的样式属性。

#### class 属性

+ 在样式表里，可以为 class 属性值相同的所有元素定义同一种样式。

#### id 属性

+ id 属性的用途是给网页里的某个元素加上一个独一无二的标识符。

### 获取元素

+ 3 种 DOM 方法获取元素节点。元素 ID，标签名字，类名字

#### getElementById

+ 返回一个与那个有着给定 id 属性值的元素节点对应的对象。

```JavaScript
var purchases = document.getElementById("purchases");

typeof(purchases); // object
```

#### getElementsByTagName

+ 返回一个对象数组。

```JavaScript
element.getElementsByTagName(tag);

document.getElementsByTagName("li");

// getElementsByTagName 允许把一个通配符作为它的参数
document.getElementsByTagName("*");

var shopping = document.getElementById("purchases");
var items = shopping.getElementsByTagName("*");
```

#### getElementsByClassName

+ 返回一个具有相同类名的元素的数组

```JavaScript
document.getElementsByClassName("sale");
document.getElementsByClassName("important sale"); // 与类名的实际顺序无关

var shopping = document.getElementById("purchases");
var sales = shopping.getElementsByClassName("sale");
```

+ 实现 getElementsByClassname

```JavaScript
// 不适用于多个类名
function getElementsByClassName(node, classname)
{
    if(node.getElementByClassName)
    {
        return node.getElementsByClassName(classname);
    } else
    {
        var results = new Array();
        var elems = node.getElementsByTagName("*");
        for (var i = 0; i < elems.length; i++)
        {
            if (elems[i].className.indexOf(className) != -1)
            {
                results[results.length] = elems[i];
            }
        }
        return results;
    }
}
```

+ 每个节点都是一个对象。

## 获取和设置属性

### getAttribute

```JavaScript
object.getAttribute(attribute)

if(something) 等价于 if(something != null) 完全等价
```

### setAttribute

```JavaScript
object.setAttribute(attribute, value)

var shopping = document.getElementById("purchases");
shopping.setAttribute("title", "a list of goods");
```

+ 可以覆盖已有属性的值

# 案例研究：JavaScript 图片库

+ DOM 是一种适用于多种环境和多种程序设计语言的通用型 API。
+ 若一个站点用到多个 JavaScript 文件，为了减少对站点的请求次数（提高性能），应该把这些 `.js` 文件合并到一个文件中。

## 事件处理函数

+ 在特定事件发生时调用特定的 JavaScript 代码。

```JavaScript
event = "Javascript statement(s)"
// JavaScript 代码包含在一对引号之间。我们可以把任意数量的 JavaScript 语句放在这对引号之间，只要把各条语句用分号隔开即可。
```

+ `onmouseover`
+ `onmouseout`
+ `onclick`

+ 在给某个元素添加了事件处理函数后，一旦事件发生，相应的 JavaScript 代码就会得到执行。被调用的 JavaScript 代码可以返回一个值，这个值将被传递给那个事件处理函数。

```JavaScipt
onclick="return false"; // 点击不会触发
```

## 函数扩展

### childNodes 属性

+ 在一棵节点树，chindNodes 属性可以用来获取任何一个元素的所有子元素。
+ 它是一个包含这个元素全部子元素的数组 `element.chindNodes`

### nodeType 属性

+ `node.nodeType`
+ nodeType 属性总共有 12 种可取值，但其中仅有 3 种具有实用价值。

    + 元素节点的 nodeType 属性值是 1
    + 属性节点的 nodeType 属性值是 2
    + 文本节点的 nodeType 属性值是 3

### nodeValue 属性

+ 得到和设置文本节点的值 `node.nodeValue`

```JavaScript
description.nodeValue; // null
// 文本也是另一种节点，是 description 节点的第一个子节点
description.childNodes[0].nodeValue;
```

### firstChild 和 lastChild 属性

+ `node.firstChild` 等价于 `node.childNodes[0]`
+ `node.lastChild`  `node.childNodes[node.childNodes.length - 1]`

# 最佳实践

## 过去的错误

### 不要怪罪 JavaScript

### Flash 的遭遇

### 质疑一切

## 平稳退化

+ 如果正确地使用了 JavaScript 脚本，就可以让访问者在他们浏览器不支持 JavaScript （或者禁用 JavaScript ）的情况下任能顺利地浏览你网站。
+ 虽然某些功能无法使用，但最基本的操作仍能顺利完成。

+ 应该只在绝对必要的情况下才使用弹出窗口，因为这将牵涉到网页的可访问性问题。
+ 如果网页上的某个链接将弹出新窗口，最好在这个链接本身的文字中予以说明。

+ JavaScript 使用 window 对象的 open() 方法来创建新的浏览器窗口。

```JavaScript
window.open(url, name, features)
// 三个参数都是可选的
// url 是想在新窗口里打开的网页的 URL 地址。如果省略这个参数，屏幕上将弹出一个空白的浏览器窗口
// name 是新窗口的名字。可以在代码中通过这个名字与新窗口进行通信。
// features 是一个以逗号分隔的字符串，其内容是新窗口的各种属性。新窗口的尺寸以及新窗口被启用或禁用的各种浏览功能。（新窗口的浏览功能要少而精）

function popUp(winURL)
{
    window.open(winURL, "popup", "width=320, height=480");
}
```

+ open() 方法是使用 BOM 的一个好案例，它的功能对文档的内容也无任何影响（那是 DOM 的地盘）。这个方法只与浏览环境有关。

+ 调用 popUp 函数的一个办法是使用伪协议（ pseudo-protocol ）

### "javascript:" 伪协议

+ "真"协议用来在因特网上的计算机之间传输数据包，如 HTTP 协议(http://)，FTP 协议(ftp://) 等。
+ 伪协议则是一种非标准化的协议。"javascript:" 伪协议让我们通过一个链接来调用 JavaScript 函数。

```JavaScript
<a href="javascript:popUp('http://www.example.com/');">Example</a>
// 这条语句在支持 "javascript:" 伪协议的浏览器中运行正常
// 较老的浏览器则会去尝试打开那个链接但失败
// 支持这种伪协议但禁用了 JavaScript 功能的浏览器会什么也不做。
```

+ 在 HTML 文档里通过 "javascript:" 伪协议调用 JavaScript 代码的做法非常不好。

### 内嵌的事件处理函数

```JavaScript
<a href="#" onclick="popUp('http://www.example.com/'); return false;">Example</a>

// # 符号是一个仅供文档内部使用的链接记号（单就这条指令而言，"#" 是未指向任何目标的内部链接）。在某些浏览器里，"#" 链接指向当前文档的开头。
// 把 href 属性设置为 "#" 只是为了创建一个空链接。
```

+ 这个技巧与用 "javascript:" 伪协议调用 JavaScript 代码的做法同样糟糕，因为它们都不能平稳退化。
+ 如果用户禁用了浏览器的 JavaScript 功能，这样的链接将毫无用处。

### 谁关心这个

+ 如果你的 JavaScript 网页不能平稳退化，它们在搜索引擎上的排名就可能大受损害。

```JavaScript
// 为其中的 JavaScript 代码预留出退路，在链接里把 href 属性设置为真实存在的 URL 地址，让它成为一个有效的链接。
<a href="http://www.example.com/" onclick="popUp('http://www.example.com'); return false;">Example</a>

<a href="http://www.example.com/" onclick="popUp(this.getAttribute('href'));return false;">Example</a>

// 使用 DOM 提供的 this.href 属性
<a href="http://www.example.com/" onclick="popUp(this.href); return false;">Example</a>
```

+ 在把 href 属性设置为真实存在的 URL 地址后，即使 JavaScript 已被禁用（或遇到搜索机），这个链接也是可用的。
+ 不足

    + 每当需要打开新窗口时，就不得不把一些 JavaScript 代码嵌入标记文档中。
    + 如果能把包括事件处理函数在内的所有 JavaScript 代码全都放在外部文件里，这个技巧将更加完善。

## 向 CSS 学习

### 结构与样式的分离

+ CSS 层叠样式表
+ CSS 技术的最大优点是，它能够帮助你将 Web 文档的内容结构（标记）和版面设计（样式）分离开来。
+ 真正从 CSS 技术获益的方法，是把样式全部转移到外部文件中去。

+ 文档结构与文档样式的分离可以确保网页都能平稳退化。

### 渐进增强

+ 标记良好的内容就是一切
+ CSS 指令构成了一个表示层。
+ 渐进增强，就是用一些额外的信息层去包裹原始数据。按照 "渐进增强" 原则创建出来的网页几乎（如果不是 "全部" 的话）都符合 "平稳退化" 原则。

+ JavaScript 和 DOM 提供的所有功能也应该构成了一个额外的指令层。CSS 代码负责提供关于 "表示" 的信息，JavaScript 代码负责提供关于 "行为" 的信息。
+ 行为层的应用方式与表示层一样。
+ 推荐做法，先把样式信息存入一个外部文件，再在文档的 head 部分用 <link> 标签来调用这个文件。
+ class 属性是样式与文档内容之间的联结纽带。

## 分离 JavaScript

+ 在 HTML 文档里使用诸如 onclick 之类的属性也是一种即没有效率又容易引发问题的做法。
+ 如果我们用一个 "挂钩"， 就像 CSS 机制中的 class 或 id 属性那样，把 JavaScript 代码调用行为与 HTML 文档的结构和内容分离开，网页就会健壮多。

```JavaScript
element.event = action...
getElementById(id).event = action

// 多个元素
getElementByTagName 和 getAttribute 把事件添加到有特定属性的一组元素上。

var links = document.getElementsByTagName("a");
for (var i = 0; i < links.length; i++)
{
    if (links[i].getAttribute("class") === "popup")
    {
        links[i].onclick = function()
        {
            popUp(this.getAttribute("href"));
            return false;
        };
    }
}
```

+ `var links = document.getElementByTagName("a")` 存入外部 JavaScript 文件，它们将无法正常运行。

    + 这条语句将在 JavaScript 文件被加载时立刻执行。
    + 如果 JavaScript 文件是在从 HTML 文档的 `<head>` 部分用 `<script>` 标签调用的，它将在 HTML 文档之前加载到浏览器。
    + 如果 `<script>` 标签位于文档底部 `</body>` 之前，就不能保证哪个文件最先结束加载（浏览器可能一次加载多个）。
    + 因为脚被加载时文档可能不完整，所以模型也不完整。没有完整的 DOM，getElementsByTagName 等方法就不能正常工作。

+ 必须让这些代码在 HTML 文档全部加载到浏览器之后马上开始执行。

    + HTML 文档全部加载完毕时将触发一个事件，这个事件有它自己的事件处理函数。
    + 文档将被加载到一个浏览器窗口里，document 对象又是 window 对象的一个属性。当 window 对象触发 onload 事件时，document 对象已经存在。

```JavaScript
// 把这个函数添加到 window 对象的 onload 事件上去。
window.onload=prepareLinks;
function prepareLinks()
{
    var links = document.getElementByTagName("a");
    ..
}
```

## 向后兼容

+ 比较古老的浏览器却很可能无法理解 DOM 提供的方法和属性。

### 对象检测

+ 检测浏览器对 JavaScript 的支持程度。
+ 只要把某个方法打包在一个 if 语句里，就可以根据这条 if 语句的条件表达式的求值结果是 true （存在） 还是 false（不存在）来决定应该采取怎样的行动。这种检测称为对象检测（object detection）

```JavaScript
// 在使用对象检测时，一定要删掉方法名后面的圆括号，如果不删掉，测试的将是方法的结果，无论方法是否存在。
function myFunction()
{
    if (document.getElementById)
    {
        statements using getElementById
    }
}
```

+ 不足

    + 如此编写出来的函数会增加一对花括号。如果需要在检测多个 DOM 方法和属性是否存在，这个函数中最重要的语句就会被深埋在一层又一层的花括号里。这样的代码很难阅读和理解。

+ 测试条件改为 "如果你不理解这个方法，请离开" 则更简单。

```JavaScript
if (!getElementById) return false;
if (!getElementById || !getElementById) return false;

if (!document.getElementByTagName) return false;
```

### 浏览器嗅探技术

+ 通过提取浏览器供应商提供的信息来解决向后兼容问题。
+ 理论上讲，可以通过 JavaScript 代码检索关于浏览器品牌和版本的信息，这些信息可以用来改善 JavaScript 脚本代码的向后兼容性，但这是一种风险非常大的技术。

+ 首先，浏览器有时会 "撒谎"。因为历史原因，有些浏览器会把自己报告为另外一种浏览器，还有一些浏览器允许用户任意修改这些信息。

## 性能考虑

### 尽量少访问 DOM 和尽量减少标记

```JavaScript
if (document.getElementsByTagName("a").length > 0)
{
    var links = document.getElementsByTagName("a");
    for (var i = 0; i < links.length; i++)
    {
        //..
    }
}
// 只要是查询 DOM 中的某些元素，浏览器都会搜索整个 DOM 树，从中查找可能匹配的元素。
// 这段代码使用两次 getElementByTagName 方法去执行相同的操作，浪费一次搜索。应该把搜索结果存到变量中，重用。
```

+ 在多个函数都会取得一组类似元素的情况下，可以考虑重构代码，把搜索结果保存在一个全局变量里，或者把一组元素直接以参数形式传递给函数。

+ 减少文档中的标记数量。过多不必要的元素只会增加 DOM 树的规模，进而增加遍历 DOM 树以查找特定的元素的时间。

### 合并和放置脚本

```JavaScript
<script src="script/function.js"></script>
```

+ 合并到一个脚本文件中。可以减少加载页面时发送的请求数量。
+ 脚本在标记中的位置对页面的初次加载时间也有很大影响。

    + 传统上，我们把脚本放在文档的 `<head>` 区域，这种放置方法有一个问题。位于 `<head>` 块中的脚本会导致浏览器无法并行加载其他文件（如图像或其他急脚本）。
    + 一般来说，根据 HTTP 规范，浏览器每次从同一个域名中最多只能同时下载两个文件。而在下载脚本期间，浏览器不会下载其他任何文件，即使是来自不同域名的文件也不会下载，所有其他资源都要等脚本加载完毕后才能下载。

+ 把所有 `<script>` 标签都放到文档的末尾，`</body>` 标记之前，就可以让页面变得更快。

### 压缩脚本

+ 把脚本文件中不必要的字节，如空格和注释，统统删除，从而达到"压缩" 文件的目的。
+ 多数情况下，你应该有两个版本，一个时工作副本，可以修改代码并添加注释；另一个时精简副本，用于放在站点上。
+ 最好在精简副本的文件名中加上 min 字样。`scriptName.min.js`

+ 代码压缩工具

    + Douglas Crockford 的 JSMin
    + 雅虎的 YUI Compressor
    + 谷歌的 Closure Compiler

# 案例研究：图片库改进版

+ 如果想用 JavaScript 给某个网页添加一些行为，就不应该让 JavaScript 代码对这个网页的结构有任何依赖。

+ 结构话程序设计

    + 函数应该只有一个入口和一个出口。

+ 在实际工作中，过分拘泥于这项原则往往会使代码变得非常难以阅读。如果为了避免留下多个出口点而去改写那些 if 语句的话，这个函数的核心代码就会被掩埋在一层又一层的花括号里。
+ 如果一个函数有多个出口，只要这些出口集中出现在函数的开头部分，就是可以接受的。

+ 把充当循环计数器的变量命名为 "i" 是一种传统做法。字母 "i" 在这里的含义是 "increment" (递增) 。

### 共享 onload 事件

```JavaScript
// 让这个函数在网页加载完毕之后立刻执行。
window.onload = prepareGallery;

// 多个绑定函数
window.onload = firstFunction;
window.onload = secondFunction; // 它们当中只有最后那个才会被实际执行，每个事件处理函数只能绑定一条指令。

window.onload = function()
{
    firstFunction();
    secondFunction();
} // 在需要绑定的函数不是很多的场合，这是最简单的解决方案。
```

+ 弹性解决方案：不管加载完毕时执行多少个函数，它都可以应付自如。
+ addLoadEvent 函数，只有一个参数，打算在页面加载完毕时执行的函数的名字。

    + 把现有的 window.onload 事件处理函数的值存入变量 oldonload
    + 如果在这个处理函数上还没有绑定任何函数，就像平时那样把新函数添加给它
    + 如果在这个处理函数上已经绑定了一些函数，就把新函数追加到现有指令的末尾

```JavaScript
function addLoadEvent(func)
{
    var oldonload = window.onload;
    if (typeof window.onload != 'function')
    {
        window.onload = func;
    } else
    {
        window.onload = function()
        {
            oldonload();
            func();
        }
    }
}

// 这将把那些在页面加载完毕时执行的函数创建为一个队列。
```

## 不要做太多的假设

```JavaScript
links[i].onclick = function ()
{
  return !showPic(this);
};
// 如果 showPic 返回 true 我们就返回 false,浏览器不会打开那个链接
// 如果 showPic 返回 false ，那么我们认为图片没有更新，于是返回 true 以允许默认行为发生。
```

## 优化

```JavaScript
if (whichpic.getAttribute("title"))
{
    var text = whichpic.getAttribute("title");
} else
{
    var text = "";
}

var text = whichpic.getAttribute("title") ? whichpic.getAttribute("title") : "";

variable = condition ? if true : if false;

if (placeholder.nodeName != "IMG") return false;
// nodeName 属性总是返回一个大写字母的值，即使元素在 HTML 文档里是小写字母。
```

+ 在实际工作中，你要自己决定是否真的需要这些检查。它们针对的是 HTML 文档有可能不在你控制范围内的情况。

## 键盘访问

+ 并非所有的用户都使用鼠标。
+ 键盘上的 Tab 键可以让我们从个这个链接移动到另一个链接，按下回车键将启用当前链接。
+ 按下键盘上任何一个键都会触发 onkeypress 事件。

```JavaScript
// 让 onkeypress 事件与 onclick 事件触发同样的行为
// 复制一份
links[i].onclick = function()
{
    return showPic(this) ? false : true;
}
links[i].onkeypress = function()
{
    return showPic(this) ? false : true;
}
// 或者
links[i].onkeypress = links[i].onclick;
```

+ 小心 onkeypress

    + 几乎所有浏览器里，用 Tab 键移动到某个链接然后按下回车键的动作也会触发 onclick 事件。
    + 最好不要使用 onkeypress 事件处理函数。

## 把 JavaScript 与 CSS 结合起来

+ 挂钩 - id

## DOM Core 和 HTML-DOM

```JavaScript
getElementById
getElementByTagName
getAttribute
setAttribute
// 这些方法是 DOM Core 的组成部分。它们并不专属于 JavaScript ，支持 DOM 的任何一种程序设计语言都可以使用它们。
// 可以处理任何一种标记语言（xml）编写处理啊的文档。

// 在 JavaScript 语言和 DOM 为 HTML 文件编写脚本时，还有许多属性可供选用。

// HTML-DOM提供了一个 forms 对象
document.getElementByTagName("form")
document.forms

// HTML-DOM 还提供了许多描述各种 HTML 元素的属性。
element.getAttribute("src")
element.src
```

+ 这些方法和属性可以相互替换。同样的操作可以只使用 DOM Core 来实现，也可以使用 HTML-DOM 来实现。
+ HTML-DOM 代码通常会更短，它们只能用来处理 Web 文档。

```JavaScript
var source = whichpic.href;
placeholder.src = source;
```

## 小结

+ 尽量让我的 JavaScript 代码不再依赖于那些没有保证的假设，为此我引入了许多项测试和检查。这些测试和检查使我的 JavaScript 代码能够平稳退化。
+ 没有使用 onkeypress 事件处理函数，这使我的 JavaScript 代码的可访问性得到了保证。
+ 最重要的是把事件处理函数从标记文档分离到了一个外部的 JavaScript 文件。这使我的 JavaScript 代码不再依赖于 HTML 文档的内容和结构。

+ 结构与行为的分离程度越大越好。

# 动态创建标记

+ 网页的结构由标记负责创建，JavaScript 函数只用来改变某些细节而不改变其底层结构。JavaScript 也可以用来改变网页的结构和内容。

## 一些传统方法

### document.write

+ document 对象的 write() 方法可以方便快捷地把字符串插入到文档里。

```JavaScript
document.write("<p>This is inserted.</p>")
// 违背了 "行为应该与表现分离" 的原则。
```

+ JavaScript 和 HTML 代码混杂在一起是一种很不好的做法。
+ MIME 类型 application/xhtml+xml 与 document.write 不兼容，浏览器在呈现这种 XHTML 文档时根本不会执行 document.write 方法。

### innerHTML 属性

+ 写某给定元素里的 HTML 内容。

```JavaScript
window.onload = functiton()
{
    var testdiv = document.getElementById("testdiv");
    testdiv.innerHTML = "<p>I inserted <em>this</em> content.</p>";
}
// testdiv 元素里有没有 HTML 内容无关紧要：一旦你使用了 innerHTML 属性，它的全部内容都将被替换。
// innerHTML 属性不会返回任何对刚插入的内容的引用。
```

+ 类似于 document.write 方法，innerHTML 属性也是 HTML 专有属性，不能用于任何其他标记语言。浏览器在呈现正宗的 XHTML 文档时会直接忽略掉 innerHTML 属性。

## DOM 方法

+ DOM 是文档的表示。

### createElement 方法

```JavaScript
var para = document.createElement("p");
// 新创建的 p 元素已经存在，但它还不是任何一颗 DOM 节点树的组成部分。称为文档碎片。
// 已经像任何其他的节点那样有了自己的 DOM 属性。
// 元素节点
```

### appendChild 方法

```JavaScript
// 成为这个文档某个现有节点的一个字节点。
parent.appendChild(child);

var testdiv = document.getElementById("testdiv");
var para = document.createElement("p");
testdiv.appendChild(para);
// 合并为 1 行，使得代码很难阅读和理解。
```

### createTextNode 方法

+ 创建一个文本节点

```JavaScript
document.createTextNode(text);

var txt = document.createTextNode("Hello World!");
para.appendChild(text);
```

## 重回图片库

```JavaScript
// 这个XHTML 文件中有一个图片和一段文字仅仅是为 showPic 脚本服务的。
document.getElementsByTagName("body")[0].appendChild(placeholder);
    document.getElementsByTagName("body")[0].appendChild(description);

// HTML-DOM
document.body.appendChild(placeholder);
document.body.appendChild(description);
```

+ 上面两种方法都会把元素插入到位于文档末尾的 `</body>` 标签之前。

### 在已有元素前插入一个新元素

+ DOM 提供了名为 insertBefore() 方法，这个方法将把一个新元素插入到一个现有元素的前面。

```JavaScript
parentElement.insertBefore(newElement, targetElement);
// 元素节点的父元素必须是另一个元素节点（属性节点和文本节点的子元素不允许是元素节点）

var gallery = document.getElementById("imagegallery");
gallery.parentNode.insertBefore(placeholder, gallery);
```

### 在现有方法后插入一个新元素

+ DOM 没有提供 `insertAfter()` 方法。

```JavaScript
function insertAfter(newElement, targetElement)
{
    var parent = targetElement.parentNode;
    if (parent.lastChild === targetElement)
    {
        parent.appendChild(newElement);
    } else
    {
        parent.insertBefore(newElement, targetElement.nextSibling);
    }
}
```

+ 目标元素的下一个兄弟元素即目标元素的 nextSibling 属性。

## Ajax

+ 可以只更新页面中的一小部分。其他内容-标志，导航，头部，脚部都不用重新加载。
+ Ajax 的主要优势就是对页面的请求以异步方式发送到服务器。而服务器不会用整个页面来响应请求，它会在后台处理请求，与此同时用户还能继续浏览页面并与页面交互。
+ Ajax 有它自己的适用范围。它依赖 JavaScript，所以可能会有浏览器不支持它，而搜索引擎的蜘蛛程序也不会抓取到有关内容。

### XMLHttpRequest 对象

+ Ajax 技术的核心就是 XMLHttpRequest 对象。这个对象充当着浏览器中的脚本（客户端）和服务器之间的中间人的角色。以往的请求都是由浏览器发出，而 JavaScript 通过这个对象可以自己发送请求，同时也自己处理响应。

```JavaScript
// getHTTPObject.js
function getHTTPObject()
{
    if (typeof XMLHttpRequest === "undefined")
    {
        XMLHttpRequest = function ()
        {
            try
            {
                return new ActiveXObject("Msxml2.XMLHTTP.6.0");
            }
            catch (e)
            {
            }
            try
            {
                return new ActiveXObject("Msxml2.XMLHTTP.3.0");
            }
            catch (e)
            {
            }
            try
            {
                return new ActiveXObject("Msxml2.XMLHTTP");
            }
            catch (e)
            {
            }
            return false;
        };
        return new XMLHttpRequest();
    }
}

// getNewContent.js
function getNewContent()
{
    var request = getHTTPObject();
    if (request)
    {
        request.open("GET", "example.txt", true); // 指定服务器上将要访问的文件，指定请求类型。第三个参数用于指定请求是否以异步方式发送和处理。
        request.onreadystatechange = function()
        {
            if (request.readyState === 4)
            {
                var para = document.createElement("p");
                var txt = document.createTextNode(request.responseText);
                para.appendChild(txt);
                document.getElementById("new").appendChild(para);
            }
        };
        request.send(null);
    } else
    {
        alert("Sorry, your brower does't support XMLHTTPRequest");
    }
}
addLoadEvent(getNewContent());
```

+ onreadystatechange 事件处理函数 在服务器给 XMLHttpRequest 对象送回响应的时候被触发执行。

    + 也可以引用一个函数。不要在函数名后面加括号。加括号表示立即调用函数。

+ readyState 属性值

    + 0 表示未初始化
    + 1 表示正在加载
    + 2 表示加载完毕
    + 3 表示正在交互
    + 4 表示完成

+ 访问服务器发送回来的数据要通过两个属性完成。

    + responseText 属性，用于保存文本字符串形式的数据
    + responseXML 属性，用于保存 Content-Type 头部中指定为 "Text/xml" 的数据，是一个 DocumentFragment 对象。可使用各种 DOM 方法来处理这个对象。

+ 在使用 Ajax 时，千万要注意同源策略。使用 XMLHttpRequest 对象发送的请求只能访问与其所在的 HTML 处于同一个域中的数据，不能向其他域发送请求。
+ 有些浏览器还会限制 Ajax 请求使用的协议。

+ Ajax 应用的特色就是减少重复加载页面的次数。但这种缺少状态记录的技术会与浏览器的一些使用惯例产生冲突，导致用户无法使用后退按钮或者无法为特定状态下的页面添加书签。
+ 理想情况下，用户的每一次操作都应该得到一个清晰明确的结果。

### 渐进增强与 Ajax

+ 构建 Ajax 网站的最好方法，也是先构建一个常规的网站，然后 Hijax 它。

### Hijax - 渐进增强地使用 Ajax

+ 登陆页面

    + 拦截提交表单的请求，让 XMLHttpRequest 请求来代为发送。提交表单触发的是 submit 事件，因此只要通过 onsubmit 事件处理函数捕获该事件，就可以取消它的默认操作（提交整个页面）。
+ Ajax 应用主要依赖于服务器端处理，而非客户处理。
+ hijack 劫持 拦截用户操作触发的请求。

# 充实文档的内容

## 不应该做什么

+ 如果你觉察到自己正在使用 DOM 技术把一些重要的内容添加到网页上，则应该立刻停下来去检讨你的计划和思路。

    + 渐进增强。你应该总是从最核心的部分，也就是从内容开始。应该根据内容使用标记实现良好的结构，然后再逐步加强这些内容。这些增强工作既可以是通过 CSS 改进呈现效果，也可以是通过 DOM 添加各种行为。
    + 平稳退化。渐进增强的实现必然支持平稳退化。

## 把 "不可见" 变成 "可见"

+ `display` : `inline` `block` `none`

+ `abbr` 标签含义是 "缩略图"(abbreviation)是对单词或短语的简写形式的统称。
+ `acronym` 标签的含义是被当作一个单词来读的 "首字母缩写词" (acronym)，所有的首字母缩略词都是缩略语，但不是所有的缩略语都是首字母缩略词。HTML5 中 <acronym> 标签已被 <abbr> 标签代替

### 选用 HTML，XHTML 还是 HTML5

+ 不管选用的哪种文档类型，你使用的标记必须与你选用的 DOCTYPE 声明保持一致。
+ 作者喜欢使用 XHTML 规则。

    + 所有标签名和属性名都必须小写字母。
    + 所有标签都必须闭合。`<br/>`

+ HTML5 的文档类型声明 `<!DOCTYPE html>`
+ XHTML5 让 Web 服务器以 application/xhtml+xml 的 MIME 类型来响应页面，但必须预先警告。

## 显示 "缩略语列表"

```JavaScript
function displayAbbreviations()
{
    var abbreviations = document.getElementsByTagName("abbr");
    if (abbreviations.length < 1) return false;
    var defs = new Array();
    for (var i = 0; i < abbreviations.length; i++)
    {
        var current_abbr = abbreviations[i];
        var definition = current_abbr.getAttribute("title");
        var key = current_abbr.lastChild.nodeValue;
        defs[key] = definition;
    }
}
```

### 创建标记

+ 定义列表是表现缩略语及其解释的理想结构。定义列表（<dl>）由一系列"定义标题"（<dt>）和相应的 "定义描述" （<dd>）构成。
+ for/in - `for(variable in array)` variable 是数组的下标。

```JavaScript
function displayAbbreviations()
{
    if (!document.getElementsByTagName) return false;
    if (!document.createElement) return false;
    if (!document.createTextNode) return false;

    var abbreviations = document.getElementsByTagName("abbr");
    if (abbreviations.length < 1) return false;
    var defs = new Array();

    for (var i = 0; i < abbreviations.length; i++)
    {
        var current_abbr = abbreviations[i];
        var definition = current_abbr.getAttribute("title");
        var key = current_abbr.lastChild.nodeValue;
        defs[key] = definition;
    }

    var dlist = document.createElement("dl");
    for (key in defs)
    {
        var definition = defs[key];
        var dtitle = document.createElement("dt");
        var dtitle_text = document.createTextNode(key);
        dtitle.appendChild(dtitle_text);
        var ddesc = document.createElement("dd");
        var ddesc_text = document.createTextNode(definition);
        ddesc.appendChild(ddesc_text);
        dlist.appendChild(dtitle);
        dlist.appendChild(ddesc);
    }

    var header = document.createElement("h2");
    var header_text = document.createTextNode("Abbreviations");
    header.appendChild(header_text);
    document.getElementsByTagName("body")[0].appendChild(header);
    document.getElementsByTagName("body")[0].appendChild(dlist);
}

addLoadEvent(displayAbbreviations);
```

+ 再真实项目中，通常还需要压缩脚本，并把它们合并成一个文件。

### 一个浏览器 "地雷"

+ IE 浏览器直到 IE 7 才支持 abbr 元素。
+ 解决方案

    + 替换为 acronym 元素
    + 使用 html 命名空间（`<html:abbr>`）
    + 不能识别 abbr 元素的浏览器退出

        ```JavaScript
        if (current_abbr.childNodes.length < 1) continue;
        // 因为 IE 浏览器在统计 abbr 元素的字节点个数时总是会返回一个错误的值 - 零

        if (dlist.childNodes.length < 1) return false;
        ```

## 显示 "文献来源链接表"

+ 有些浏览器会把这个换行符解释为一个文本节点。
+ 在编写 DOM 脚本时，会想当然地认为某个节点肯定是一个元素节点，这是一种常见错误。没有百分之百把握，要去检查 nodeType 属性值。很多 DOM 方法只能用在元素节点上，如果用在文本节点上，就会出错。

```JavaScript
function displayCitations()
{
    if (!document.getElementsByTagName || !document.createElement || !document.createTextNode) return false;
    var quotes = document.getElementsByTagName("blockquote");
    for (var i = 0; i < quotes.length; i++)
    {
        if (!quotes[i].getAttribute("cite")) continue;
        var url = quotes[i].getAttribute("cite");

        var quoteChildren = quotes[i].getElementsByTagName("*");
        if (quoteChildren.length < 1) continue;
        var elem = quoteChildren[quoteChildren.length - 1];

        var link = document.createElement("a");
        var link_text = document.createTextNode("source");
        link.appendChild(link_text);
        link.setAttribute("href", url);

        var superscript = document.createElement("sup");
        superscript.appendChild(link);
        elem.appendChild(superscript);
    }
}
addLoadEvent(displayCitations);
```

## 显示 "快捷键清单"

+ 把文档里能用到的所有快捷键显示在页面里。
+ accesskey 属性可以把一个元素（如链接）与键盘上的某个特定按键关联在一起。

## 检索和添加信息

+ 用 JavaScript 函数先把文档结构里的一些现有信息提取出来，再把那些信息以一种清晰和有意义的方式重新插入到文档里去。
+ 信息检索

    + getElementById
    + getElementsByTagName
    + getAttribute

+ 添加到文档里

    + createElement
    + createTextNode
    + appendChild
    + inertBefore
    + setAttribute

+ JavaScript 脚本只应该用来充实文档的内容，要避免使用 DOM 技术来创建核心内容。

# CSS-DOM

## 三位一体的网页

+ 结构层

    > structural layer 由 HTML 或 XHTML 之类的标记语言负责创建。
+ 表示层

    > 由 CSS 负责完成，CSS 描述页面内容应该如何呈现。
+ 行为层

    > 负责内容应该如何响应事件这一问题。这是 JavaScript 语言和 DOM 主宰的领域。

--

+ 网页的表示层和行为层总是存在的。Web 浏览器将应用它的默认样式和默认事件处理函数。

### 分离

+ 三种技术之间存在着一些潜在的重叠区域。

## style 属性

+ 文档里的每个元素都是一个对象，每个元素都有一个 style 属性，它们也是一个对象。

+ 查询这个属性将返回一个对象而不是一个简单的字符串。样式都存放在这个 style 对象的属性里： `element.style.property`

### 获取样式

+ 当需要引用一个中间带减号的 CSS 属性时，DOM 要求你用驼峰命名法。

+ DOM 在表示样式属性时采用的单位并不总是与它们在 CSS 样式表里的设置相同。

```CSS
<p id="example" style="color: #999999; font-family: 'Arial',sans-serif">
// 在某些浏览器中 color 属性以 RGN（红，绿，蓝）格式的颜色值（153，153，153）返回。
```

+ 通过 style 属性只能返回内嵌样式。只有把 CSS style 属性插入到标记里，才可以用 DOM style 属性去查询那些信息。

+ 在外部样式表里声明的样式不会进入 style 对象，在文档的 `<head>` 部分里声明的样式也是如此。

+ 另一种情况可以让 DOM style 对象能够正确地反射出我们设置的样式。用 DOM 设置的样式，可以用 DOM 再把它们检索出来。

### 设置样式

+ 许多 DOM 属性是只读的，我们只能用它们来获取信息，但不能用它们来设置或更新信息。如 previousSibling, nextSibling, parentNode, firstChild, lastChild
+ style 对象的各个属性都是可读写的。`element.style.property = value`
+ style 对象的属性值永远是一个字符串。JavaScript 代码覆盖那些内嵌在标记里的 CSS 代码。

## 何时该用 DOM 脚本设置样式

+ 不应该利用 DOM 为文档设置重要的样式。

### 根据元素在节点树里的位置来设置样式

```CSS
input[type*="text"]
{
    font-size: 1.2em;
}
p: first-of-type
{
    font-size: 2em;
    font-weight: bold;
}
```

+ 找出跟在每个 h1 元素后面的那个元素。

```JavaScript
function styleHeaderSiblings()
{
    if (!document.getElementsByTagName) return false;
    var headers = document.getElementsByTagName("h1");
    for (var i = 0; i < headers.length; i++)
    {
        var elem = getNextElement(headers[i].nextSibling);
        elem.style.fontWeight = "bold";
        elem.style.fontSize = "1.2em";
    }
}

function getNextElement(node)
{
    if (node.nodeType == 1)
    {
        return node;
    }
    if (node.nextSibling)
    {
        return getNextElement(node.nextSibling);
    }
    return null;
}

addLoadEvent(styleHeaderSiblings);
```

### 根据某种条件反复设置某种样式

+ 表格用来做页面布局不是好主意，但是用来显示表格数据却是理所应当的。
+ 让表格里的行更可读的常用技巧是交替改变它们的背景色，从而形成斑马线效果。

```CSS
// 如果支持 CSS 3
tr:nth-child(odd)
{
    background-color: #ffc;
}

tr:nth-child(even)
{
    background-color: #fff;
}
```

+ 不支持 `:nth-child()`

```JavaScript
function stripeTables()
{
    if (!document.getElementsByTagName) return false;
    var tables = document.getElementsByTagName("table");
    var odd, rows;
    for (var i = 0; i < tables.length; i++)
    {
        odd = false;
        rows = tables[i].getElementsByTagName("tr");
        for (var j = 0; j < rows.length; j++)
        {
            if (odd === true)
            {
                rows[j].style.backgroundColor = "#ffc";
                odd = false;
            } else
            {
                odd = true;
            }
        }
    }
}
addLoadEvent(stripeTables);
```

### 响应事件

+ CSS 提供的 `:hover` 等伪 class 属性允许我们根据 HTML 元素的状态改变样式。DOM 也可以通过 `onmouseover` 等事件对 HTML 元素的状态变化做出响应。
+ 很难判断何时用 `:hover` 何时用 `onmouseover`。最简单的答案是选择最容易实现的办法。

+ 伪类 `:hover` 在用来改变链接的样式时（大多数浏览器支持），但在鼠标悬停在其他元素上时改变样式，支持的浏览器就不多了。

```
tr:hover
{
    font-weight: bold;
}

function highlightRows()
{
    if (!document.getElementsByTagName) return false;
    var rows = document.getElementsByTagName("tr");
    for (var i = 0; i < rows.length; i++)
    {
        rows[i].onmouseover = function()
        {
            this.style.fontWeight = "bold";
        };
        rows[i].onmouseout = function()
        {
            this.style.fontWeight = "normal";
        };
    }
}

addLoadEvent(highlightRows);
```

+ 决定是采用纯粹的 CSS 来解决

    + 这个问题最简单的解决方案是什么
    + 哪种解决方案会得到更多浏览器的支持

## className 属性

+ 与其使用 DOM 直接改变某个元素的样式，不如通过 JavaScript 代码去更新这个元素的 class 属性。`element.className = value`

+ 通过 className 属性设置某个元素的 class 属性时将替换该元素原有的 class 设置。

```JS
elem.className += " intro";// 注意 intro 的一个字符时空格

function addClass(element, value)
{
    if (!element.className)
    {
        element.className = value;
    } else
    {
        newClassName = element.className;
        newClassName += " ";
        newClassName += value;
        element.className = newClassName;
    }
}
```

### 对函数进行抽象

```JS
function styleElementSiblings(tag, theclass)
{
    if (!document.getElementsByTagName) return false;
    var elems = document.getElementsByTagName(tag);
    var elem;
    for (var i = 0; i < elems.length; i++)
    {
        elem = getNextElement(elems[i].nextSibling);
        addClass(elem, theclass)
    }
}
```

# 用 JavaScript 实现动画效果

+ CSS-DOM 让网页上的元素动起来

## 动画基础知识

+  动画是样式随时间变化的完美例子之一。

### 位置

+ position 属性

    + static 默认值，有关元素将按照它们在标记里出现的先后顺序出现在浏览器窗口里。
    + relative 与 static 相似，区别是 position 属性等于 relative 的元素还可以（通过应用 float 属性）从文档的正常顺序里脱离出来。
    + absolute 我们可以把它摆放到容纳它的 "容器" 的任何位置。这个容器要么是文档本身，要么是有着 fixed 或 absolute 属性的父元素。这个元素在原始标记里出现的位置与它的显示位置无关，它的显示位置由 top,left,right,bottom 等属性决定。

        > 防止冲突，最好只使用 top 或只使用 bottom 属性，left 或 right 属性也是如此。

    + fixed

+ 函数一个接一个地执行，其间根本没有我们所能察觉的间隔。为了实现动画效果，我们必须 "创造" 出时间间隔来，而这正是我们将要探讨的问题。

### 时间

```JS
variable = setTimeout("function", interval);
// 第一个参数是将要执行的函数名
// 第二个参数，以毫秒为单位设定里需要经过多长时间后才开始执行第一个参数所给出的函数。

clearTimeout(variable) // 取消某个正在排队等待执行的函数

movement = setTimeout("moveMessage()", 5000);
```

### 时间递增量

+ 真正的动画效果是一个渐变的过程，元素应该从出发点逐步地移动到目的地，而不是从出发点一下子跳跃到目的地。

```JS
parseInt(string) // 把字符串里的数值信息提取出来。
parseInt("39 steps") // 39

parseFloat(string) // 返回浮点数
```

### 抽象

```JS
function moveElement(elementID, final_x, final_y, interval)
{
    if (!document.getElementById) return false;
    if (!document.getElementById(elementID)) return false;
    var elem = document.getElementById(elementID);
    var xpos = parseInt(elem.style.left);
    var ypos = parseInt(elem.style.top);

    if (xpos === final_x && ypos === final_y) return true;
    if (xpos < final_x) xpos++;
    if (xpos > final_x) xpos--;
    if (ypos < final_y) ypos++;
    if (ypos > final_y) ypos--;
    elem.style.left = xpos + "px";
    elem.style.top = ypos + "px";

    var repeat ="moveElement('" + elementID + "'," + final_x + "," + final_y +"," + interval + ")";
    setTimeout(repeat, 10);
}

addLoadEvent(moveElement);
```

## 实用的动画

+ Web 内容可访问性指南 7.2 节

    > 除非浏览器允许用户 "冻结" 移动着的内容，否则就应该避免让内容在页面中移动。（优先级 2 ）
    > 如果页面上有移动着的内容，就应该用脚本或插件的机制允许用户冻结这种移动或动态更新行为。

### 提出问题

+ `onmouseover` 当用户第一次把鼠标指针悬停在某个链接上时，新图片将被加载过去。即使是在一个高速的网络连接上，这多少也需要花费点儿时间，而我们希望能够立刻响应。

### 解决问题

+ "集体照"

### CSS

+ overflow 属性用来处理一个元素的尺寸超出其容器尺寸的情况。

    + visible 不裁剪溢出的内容。浏览器把溢出的内容呈现在其容器元素的显示区域以外。
    + hidden 隐藏溢出的内容。
    + scroll 类似于 hidden 浏览器对溢出的内容进行隐藏，但显示一个滚动条以便让用户能够看到内容的其他部分。
    + auto 类似于 scroll ，但浏览器只在确实发生溢出时才显示滚动条。

### 变量作用域问题

+ `moveElement()` 每次用户把鼠标指针悬停在某个链接上，不管上一次调用是否已经把图片移动到位，moveElement 函数都会再次调用并视图把这个图片移动到另一个地方去。
+ 如果用户移动鼠标的速度够快，积累在 setTimeout 队列里的事件就会导致动画效果产生滞后。
+ 为了消除滞后效果，可以用 `clearTimeout(movement)` 函数清除积累在 setTimeout 队列里的事件。

+ movement 既不能使用全局变量，也不能使用局部变量。需要一种介乎它们两者之间的东西，一个只与正在被移动的那个元素有关的变量 - 属性。

```JS
function moveElement(elementID, final_x, final_y, interval)
{
    if (!document.getElementById) return false;
    if (!document.getElementById(elementID)) return false;
    var elem = document.getElementById(elementID);
    if (elem.movement)
    {
        clearTimeout(elem.movement);
    }

    var xpos = parseInt(elem.style.left);
    var ypos = parseInt(elem.style.top);

    if (xpos === final_x && ypos === final_y) return true;
    if (xpos < final_x) xpos++;
    if (xpos > final_x) xpos--;
    if (ypos < final_y) ypos++;
    if (ypos > final_y) ypos--;
    elem.style.left = xpos + "px";
    elem.style.top = ypos + "px";

    var repeat ="moveElement('" + elementID + "'," + final_x + "," + final_y +"," + interval + ")";
    elem.movement = setTimeout(repeat, 10);
}

addLoadEvent(moveElement);
```

### 改进动画效果

```JS
Math.ceil(number); // 这将把浮点数向 "大于" 方向舍入为与之最接近的整数。
Math.floor(number); // 向 "小于" 方向舍入为与之最接近的整数。
Math.round(number); // 舍入与之最接近的整数。

function moveElement(elementID, final_x, final_y, interval)
{
    if (!document.getElementById) return false;
    if (!document.getElementById(elementID)) return false;
    var elem = document.getElementById(elementID);
    if (elem.movement)
    {
        clearTimeout(elem.movement);
    }

    var xpos = parseInt(elem.style.left);
    var ypos = parseInt(elem.style.top);
    var dist = 0;

    if (xpos === final_x && ypos === final_y) return true;
    if (xpos < final_x)
    {
        dist = Math.ceil((final_x - xpos) / 10);
        xpos = xpos + dist;
    }
    if (xpos > final_x)
    {
        dist = Math.ceil((xpos - final_x) / 10);
        xpos = xpos - dist;
    }
    if (ypos < final_y)
    {
        dist = Math.ceil((final_y - ypos));
        ypos = ypos + dist;
    }
    if (ypos > final_y)
    {
        dist = Math.ceil((ypos - final_y));
        ypos = ypos - dist;
    }
    elem.style.left = xpos + "px";
    elem.style.top = ypos + "px";

    var repeat ="moveElement('" + elementID + "'," + final_x + "," + final_y +"," + interval + ")";
    elem.movement = setTimeout(repeat, 10);
}

addLoadEvent(moveElement);
```

+ 动画效果更加平滑和迅速。

### 添加安全检查

```JS
if (!elem.style.left) elem.style.left = "0px";
if (!elem.style.top) elem.style.top = "0px";
```

### 生成 HTML 标记

+ 如果用户没有启用 JavaScript 支持，div 和 img 是多余的。
+ 这里的 div 和 img 元素纯粹是为了动画效果才硬编码进来的。不如用 JavaScript 代码生成它们。

# HTML5

+ HTML 规范从 HTML4 到 XHTML ，再到 Web Apps 1.0 最后又回到 HTML5 。
+ 三层

    + 结构层 超文本标记语言（HTML）
    + 样式层 层叠样式表（CSS）
    + 行为层 JavaScript 和文档对象模型（DOM）

+ 还可以再加一层，也就是浏览器的 JavaScript API， 包括 cookie 和 window （浏览器对象模型（BOM Browser Object Model））等
+ HTML5 是一个集合。特性检测。

## 忠告

+ 工具 `Modernizr` 富特性检测功能，可以对 HTML5 文档进行更好的控制。

```HTML
// Modernizer 修改 <html> class 属性，就与可用的 HTML5 特性添加额外的类名。
<html class="no-js">

// 类名中就会间或出现 feature 和 no-feature
// 根据这些类名，可以在 CSS 中定义响应的增强和退化版本，改善用户体验
.multiplebgs article p
{
    // 为支持多背景浏览器编写的样式
}
.no-multiplebgs article p
{
    // 为不支持多背景浏览器编写的后备样式
}

<script src="modernizr-1.5.min.js"></script>
// 一定要放在 `<head>` 元素中。以便它在文档呈现之前能够创建好新的 HTML5 元素。
```

+ Modernizer 也提供了 JavaScript 特性检测对象

+ Modernizer 还可以帮一些老旧的浏览器处理 `<section>` `article` 这样的新元素。

## 示例

### Canvas

+ 动态创建和操作图形图像。

### 音频和视频

```HTML
<video src="movie.mp4">
    // 不支持原声视频的替代内容
    <a href="movie.mp4">Download movie.mp4</a>
</video>

<audio src="sound.ogg">
    <a href="sound.ogg">Download sound.ogg</a>
</audio>
```

#### 混乱的时候

+ 并未说明支持哪些视频格式
+ 扩展名 mp4 表示视频是使用基于苹果 QuickTime 技术的 MPEG4 打包而成的。这个容器规定了不同的音频轨道在文件中的位置，以及其他与回放相关的特性。
+ 每个影片容器中，音频和视频轨道都使用不同的编解码器来编码。
+ 视频编解码器

    + H.264
    + Theora
    + VP8

+ 音频文件编解码器

    + mp3（MPEG-1 Audio Layer 3）
    + aac（Advanced Audio Coding）
    + ogg（Ogg Vorbis）

+ 没有一款浏览器支持所有的容器和编解码器，因此我们必须提供多种后备格式。

```HTML
<video id="movie" preload controls>
    <source src="movie.mp4"/>
    <source src="movie.webm" type="video/webm; codecs='vp8', vorbis"/>
    <source src="movie.ogv" type="video/ogg; codecs='theora, vorbis'"/>
    <p>Download movie as
        <a href="movie.mp4">MP4</a>
        <a href="movie.webm">WebM</a>
        or <a href="movie.ogv">Ogg</a>.
    </p>
</video>
```

+ 为了确保 HTML5 最大的兼容性，至少包含三个版本。

    + 基于 H.264 和 AAC 的 MP4
    + WebM（VP8 + Vorbis）
    + 基于 Theora 视频和 Vorbis 音频的 Ogg 文件

+ 不同的视频格式的排列次序也是一个问题。

#### 自定义控件

+ DOM 属性

    + currentTime 返回当前播放的位置，秒表示
    + duration 返回媒体的总时长，以秒表示，对于流媒体返回无穷大
    + paused 表示媒体是否处于暂停状态
    + play 在媒体播放开始时发生
    + pause 在媒体暂停时发生
    + loadeddata 在媒体可以从当前播放位置开始播放时发生
    + ended 在媒体已播放完成而停止时发生

+ 不管创建什么控件，都要添加 control 属性 `<video src="movie.ogv" control>`

+ addEventListener 为对象添加事件处理函数的规范方法。

### 表单

+ 新的输入控件

    + email
    + url
    + date
    + number
    + range 滚动条
    + search 搜索框
    + tel 电话号码
    + color 选择颜色

+ 浏览器知道这些控件都接收什么类型的输入，因此可以为他们配备不同的输入控件。

+ 新的属性

    + autocomplete 用于文本输入框添加一组建议的输入项
    + autofocus 用于让表达元素自动获得焦点
    + form 用于对 `<form>` 标签外部的表单元素分组
    + min, max 和 step 用在范围(range) 和 数值(number)输入框中
    + pattern 用于定义一个正则表达式，以便验证输入的值
    + placeholder 用于在文本输入框中显示临时性的提示信息
    + required 必填

+ 为了应对不兼容的浏览器，必须使用特性检测。

```JS
// 检查某个输入类型的控件 inputtypes.type
if (!Modernizr.inputtypes.date)
{
    // 生成日期选择器的脚本
}

// 检查某个属性 input.attribute
if (!Modernizr.input.placeholder)

<input type="text" id="first-name" placeholder="Your First Nmae">

if (!Modernizr.input.placeholder)
{
    var input = document.getElementById("first-name");
    input.onfocus = function()
    {
        var text = this.placeholder || this.getAttribute("placeholder");
        if (this.text == text)
        {
            this.value = "";
        }
    }
    input.onblur = function()
    {
        if (this.value == "")
        {
            this.value = this.placeholder || this.getAttrubute("placeholder");
        }
    }
    // 在 onblur 处理函数运行时中添加占位符文本
    input.onblue();
}
```

# 综合示例

+ 站点目录结构

    + /images
    + /styles

        + color.css 颜色
        + layout.css 布局
        + typography.css 版式
        + basic.css
    + /scripts

+ 创建页面

    + Home index.html
    + About about.html
    + Photos photos.html
    + Live live.html
    + Contact contact.html

+ 不管为哪个元素应用什么颜色，都要同时给它一个背景色。否则，就有可能导致意外，看不到某些文本。

+ 导航链接，常见做法是通过服务器端包含技术，把包含导航标记的片段插入到每个页面中。优点是重用标记块集中保存。但是不能自定义这块。

+ 常见问题页面，每个问题都可以作为内部链接处理，点击一个问题，就会显示出与该问题对应的答案，其他答案不显示。

## 增强表单

+ 作为增进可访问性的元素，label 非常有用。它通过 for 属性把一小段关联到表单的一个字段。
+ form 对象

    + form.elements.length 只关注属于表单元素的元素。
    + form.elements
    + element.value

+ onfocus 事件会在用户通过按 Tab 键或单机表单字段时被触发，而 onblur  事件会在用户把焦点移出表单字段时触发。

+ JavaScript 编写验证表单的脚本时

    + 验证脚本写得不好，反而不如没有验证
    + 千万不要完全依赖 JavaScript。客户端验证并不能取代服务端的验证。即使有了 JavaScript 验证，服务器照样还应该对接收到的数据再次验证。
    + 客户端验证的目的在于帮助保护用户的填好表单，避免他们提交未完成的表单，从而节省他们的时间。服务器验证的目的在于抱回数据库和后台系统的安全。

+ 一定尽量保持验证过程尽可能简单。
+ 无论什么时候提交表单，都会触发 submit 事件，而事件会被 onsubmit 事件处理函数拦截。

```JavaScript
request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
// 这个头部信息对于 POST 请求是必需的，它表示请求中包含 URL 编码的表单。


var matches = request.responseText.match(/<article>([\s\S]+)<\/article>/);
// 数组 matches 的第一个元素（索引为 0）是 responseText 中与整个模式匹配的部分，即包括 `<article>` `</article>`  的部分。
// 因为模式中包含一个捕获组（一对圆括号），因此 matches 的第二个元素（索引为 1）是 responseText 中与捕获组中的模式匹配部分。
```

### 压缩代码

+ 谷歌 Closure Compiler

