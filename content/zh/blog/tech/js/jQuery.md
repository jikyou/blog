---
title: jQuery
date: 2017-07-11T11:13:00+08:00
tags:
- JavaScript
---

# 语法

```JS
$(selector).action()
// jQuery 使用的语法是 XPath 与 CSS 选择器语法的组合。
```

## 名称冲突

```JS
var jq = jQuery.noConflict();
```

# 选择器

```JS
// XPath 表达式来选择带有给定属性的元素
$("[href]") // 选取所有带有 href 属性的元素
$("[href$='.jpg']") // 选取所有 href 值以 ".jpg" 结尾的元素
```

# 事件

## bind unbind

```JS
// 向匹配元素附加一个或更多事件处理器
$(selector).bind(event, data, function)

// 替换语法
$(selector).bind(
{
    event: function,
    event: function,
    ...
})

// unbind
// 该方法能够移除所有的或被选的事件处理程序，或者当事件发生时终止指定函数的运行
// ubind() 适用于任何通过 jQuery 附加的事件处理程序
$(selector).unbind(event, function)
// event 如果只规定了该参数，则会删除绑定到指定事件的所有函数

$(selector).unbind(eventObj)
```

## blur

```JS
// 当元素失去焦点时发生 blur 事件
$(selector).blur(function)
```

## change

```JS
// 当元素的值发生改变时，会发生 change 事件
// 该事件仅适用于文本域（text field），以及 textarea 和 select 元素

// 当用于 select 元素时，change 事件会在选择某个选项时发生
// 当用于 text field 或 text area 时，该事件会在元素失去焦点时发生

$(selector).change(function)
```

## click

```JS
$(selector).click(function)
```

## dblclick

```JS
// 当双击元素时，会发生 dblclick 事件
// 如果把 dblclick 和 click 事件应用于同一元素，可能会产生问题
$(selector).dblclick(function)
```

## delegate undelegate

```JS
// delegate() 方法为指定的元素（属于被选元素的子元素）添加一个或多个事件处理程序，并规定当这些事件发生时运行的函数。
// 适用于当前或未来的元素（比如由脚本创建的新元素）
$(selector).delegate(childSelector, event, data, function)

// undelegate() 方法删除由 delegate() 方法添加的一个或多个事件处理程序
$(selector).undelegate(selector, event, function)
```

## ~~live~~

```JS
// deprecated
// live() 方法为被选元素附加一个或多个事件处理程序，并规定当这些事件发生时运行的函数
// 适用于匹配选择器的当前及未来的元素（比如由脚本创建的新元素）

$(selector).live(event, data, function)
```

## die

```JS
// 移除所有通过 live() 方法向指定元素添加的一个或多个事件处理程序

$(selector).die(event, function)
```

## error

```JS
// 当元素遇到错误（没有正确载入）时，发生 error 事件
$(selector).error(function)

bind('error', handler)
```

## focus

```JS
// 当元素获得焦点时，发生 focus 事件
// 当通过鼠标点击选中元素或通过 tab 键定位到元素时，该元素就会获得焦点

$(selector).focus(function)
```

## keydown keyup keypress

```JS
// 完整的 key press 过程分为两个部分：1. 按键被按下；2. 按键被松开

// 当按钮被按下时，发生 keydown 事件
$(selector).keydown(function)

// 当按钮被松开时，发生 keyup 事件
$(selector).keyup(function)

// 当按钮被按下时，每插入一个字符，就会发生 keypress 事件
$(selector).keypress(function)
```

+ 如果在文档元素上进行设置，则无论元素是否获得焦点，该事件都会发生

## load unload

```JS
// 当指定的元素（及子元素）已加载时，会发生 load() 事件
// 适用于任何带有 URL 的元素（比如图像、脚本、框架、内联框架）
$(selector).load(function)

// 当用户离开页面时，会发生 unload 事件
event.unload(function)
// unload() 方法只应用于 window 对象。

$(window).unload(function(){
  alert("Goodbye!");
});
```

+ 当发生以下情况时，会发出 unload 事件

    + 点击某个离开页面的链接
    + 在地址栏中键入了新的 URL
    + 使用前进或后退按钮
    + 关闭浏览器
    + 重新加载页面

## mouseover mouseout

```JS
// 当鼠标指针位于元素上方时，会发生 mouseover 事件
$(selector).mouseover(function)

// 当鼠标指针从元素上移开时，发生 mouseout 事件
$(selector).mouseout(function)
```

+ 与 mouseenter 事件不同，不论鼠标指针穿过被选元素或其子元素，都会触发 mouseover 事件。只有在鼠标指针穿过被选元素时，才会触发 mouseenter 事件。
+ 与 mouseleave 事件不同，不论鼠标指针离开被选元素还是任何子元素，都会触发 mouseout 事件。只有在鼠标指针离开被选元素时，才会触发 mouseleave 事件。

## mouseenter mouseleave

```JS
// 当鼠标指针穿过元素时，会发生 mouseenter 事件
$(selector).mouseenter(function)

// 当鼠标指针离开元素时，会发生 mouseleave 事件
$(selector).mouseleave(function)
```

## mouseup mousedown

```JS
// 当在元素上放松鼠标按钮时，会发生 mouseup 事件
// 与 click 事件不同，mouseup 事件仅需要放松按钮
$(selector).mouseup(function)

// 当鼠标指针移动到元素上方，并按下鼠标按键时，会发生 mousedown 事件
// 与 click 事件不同，mousedown 事件仅需要按键被按下，而不需要松开即可发生
$(selector).mousedown(function)
```

## mousemove

```JS
// 当鼠标指针在指定的元素中移动时，就会发生 mousemove 事件
$(selector).mousemove(function)
```

+ 用户把鼠标移动一个像素，就会发生一次 mousemove 事件。处理所有 mousemove 事件会耗费系统资源。请谨慎使用该事件。

## one

```JS
// one() 方法为被选元素附加一个或多个事件处理程序，并规定当事件发生时运行的函数
// 当使用 one() 方法时，每个元素只能运行一次事件处理器函数
$(selector).one(event, data, function)
```

## ready

```JS
// 当 DOM（文档对象模型） 已经加载，并且页面（包括图像）已经完全呈现时，会发生 ready 事件
// 由于该事件在文档就绪后发生，因此把所有其他的 jQuery 事件和函数置于该事件中是非常好的做法。
// ready() 函数仅能用于当前文档，因此无需选择器
$(document).ready(function)
$().ready(function)
$(function)
```

+ ready() 函数不应与 `<body onload="">` 一起使用

## resize

```JS
// 当调整浏览器窗口的大小时，发生 resize 事件
$(selector).resize(function)
```

## scroll

```JS
// 当用户滚动指定的元素时，会发生 scroll 事件
// scroll 事件适用于所有可滚动的元素和 window 对象（浏览器窗口）
$(selector).scroll(function)
```

## select

```JS
// 当 textarea 或文本类型的 input 元素中的文本被选择时，会发生 select 事件
$(selector).select(function)
```

## submit

```JS
// 当提交表单时，会发生 submit 事件
$(selector).submit(function)
```

## toggle

```JS
// toggle() 方法用于绑定两个或多个事件处理器函数，以响应被选元素的轮流的 click 事件
// 当指定元素被点击时，在两个或多个函数之间轮流切换。
$(selector).toggle(
    function1(),
    function2(),
    functionN(),
    ...
)

// 切换 Hide() 和 Show()
// 检查每个元素是否可见
$(selector).toggle(speed, callback)
// speed 可选 默认值 0 （毫秒，slow, normal, fast）

// 是否只显示或只隐藏所有匹配的元素
$(selector).toggle(switch)
// switch 必需。布尔值
// true - 显示元素
// false - 隐藏元素
```

## trigger

```JS
// trigger() 方法触发被选元素的指定事件类型
$(selector).trigger(event, [param1, param2, ...])

// 使用 Event 对象来触发事件
$(selector).trigger(eventObj)
// eventObj 规定事件发生时运行的函数
```

## triggerHandler

```JS
// triggerHandler() 方法触发被选元素的指定事件类型。但不会执行浏览器默认动作，也不会产生事件冒泡
// triggerHandler() 方法与 trigger() 方法类似。不同的是它不会触发事件（比如表单提交）的默认行为，而且只影响第一个匹配元素
$(selector).triggerHandler(event, [param1, param2, ...])
```

## event

### preventDefault isDefaultPrevented

```JS
// 阻止元素发生默认的行为（例如，当点击提交按钮时阻止对表单的提交）
event.preventDefault()

// 防止链接打开 URL：
$("a").click(function(event){
  event.preventDefault();
});

// isDefaultPrevented() 方法返回指定的 event 对象上是否调用了 preventDefault() 方法
event.isDefaultPrevented()
```

### pageX pageY

```JS
// pageX() 属性是鼠标指针的位置，相对于文档的左边缘
event.pageX

// pageY() 属性是鼠标指针的位置，相对于文档的上边缘
event.pageY
```

### result

```JS
// result 属性包含由被指定事件触发的事件处理器返回的最后一个值，除非这个值未定义
event.result

$("button").click(function(e) {
  $("p").html(e.result);
});
```

### target

```JS
// target 属性规定哪个 DOM 元素触发了该事件
event.target
event.target.nodeName
```

### timeStamp

```JS
// timeStamp 属性包含从 1970 年 1 月 1 日到事件被触发时的毫秒数
event.timeStamp
```

### type

```JS
// type 属性描述触发哪种事件类型
event.type
```

### which

```JS
// which 属性指示按了哪个键或按钮
event.which
```

# 效果

## animate

```JS
// 执行 CSS 属性集的自定义动画
// 该方法通过CSS样式将元素从一个状态改变为另一个状态。CSS属性值是逐渐改变的，这样就可以创建动画效果
// 只有数字值可创建动画（比如 "margin: 30px"）。字符串值无法创建动画（比如 "background-color: red"）

$(selector).animate(styles, speed, easing, callback)
// speed 规定动画的速度。默认是 "normal"
// easing 可选。规定在不同的动画点中设置动画速度的 easing 函数 (swing / linear)

$(selector).animate(styles, options)
```

+ 使用 "+=" 或 "-=" 来创建相对动画（relative animations）

## queue dequeue clearQueue delay stop

+ jQuery 提供针对动画的队列功能
+ 如果您在彼此之后编写多个 animate() 调用，jQuery 会创建包含这些方法调用的“内部”队列。然后逐一运行这些 animate 调用。

```JS
// queue 显示被选元素的排队函数
// dequeue 运行被选元素的下一个排队函数
// clearQueue() 方法停止队列中所有仍未执行的函数
// 与 stop() 方法不同，（只适用于动画），clearQueue() 能够清除任何排队的函数（通过 .queue() 方法添加到通用 jQuery 队列的任何函数）
$(selector).clearQueue(queueName)

// delay 对被选元素的所有排队函数（仍未运行）设置延迟

// stop() 方法停止当前正在运行的动画
$(selector).stop(stopAll, goToEnd)
```

## fadeIn fadeOut fadeTo fadeToggle

```JS
// fadeIn() 方法使用淡入效果来显示被选元素，假如该元素是隐藏的
$(selector).fadeIn(speed, callback)
// 该效果适用于通过 jQuery 隐藏的元素，或在 CSS 中声明 display: none 的元素（但不适用于 visibility: hidden 的元素）

// fadeOut() 方法使用淡出效果来隐藏被选元素，假如该元素是显示的
$(selector).fadeOut(speed, callback)

// fadeTo() 方法将被选元素的不透明度逐渐地改变为指定的值
$(selector).fadeTo(speed, opacity, callback)
// opacity 必须 规定要淡入或淡出的透明度。必须是介于 0.00 与 1.00 之间的数字

$(selector).fadeToggle(speed, callback);
```

## hide show toggle

```JS
$(selector).hide(speed, callback)
$(selector).show(speed, callback)

// toggle() 方法切换元素的可见状态
$(selector).toggle(speed, callback)
$(selector).toggle(switch)
// switch 可选。布尔值。规定 toggle 是否隐藏或显示所有被选元素。
//      True - 显示所有元素
//      False - 隐藏所有元素
```

## slideDown slideUp slideToggle

```JS
// slideDown() 方法通过使用滑动效果，显示隐藏的被选元素
$(selector).slideDown(speed, callback)

// 通过使用滑动效果，隐藏被选元素，如果元素已显示出来的话
$(selector).slideUp(speed, callback)

// slideToggle() 方法通过使用滑动效果（高度变化）来切换元素的可见状态
$(selector).slideToggle(speed, callback)
```

## Callback

+ Callback 函数在当前动画 100% 完成之后执行

## Chaining

+ 通过 jQuery，您可以把动作/方法链接起来。Chaining 允许我们在一条语句中允许多个 jQuery 方法。

# jQuery HTML

## HTML

```JS
// 下面四个都有回调函数
text() // 设置或返回所选元素的文本内容
html() // 设置或返回所选元素的内容（包括 HTML 标记）
val() // 设置或返回表单字段的值
attr() // 方法用于获取属性值

$(selector).attr(attribute)
$(selector).attr(attribute, value)
removeAttr()

addClass()
hasClass()
toggleClass() // 对设置或移除被选元素的一个或多个类进行切换
$(selector).toggleClass(class, switch)
$(selector).toggleClass(function(index, class), switch)

removeClass()
```

### after before

+ 在匹配的语速之后，之前插入（或移动）内容

### insertAfter insertBefore

### append appendTo prepend prependTo

```JS
// append() 方法在被选元素的结尾（仍然在内部）插入指定内容
$(selector).append(content)
$(selector).append(function(index, html))

// appendTo() 方法在被选元素的结尾（仍然在内部）插入指定内容
$(content).appendTo(selector)
```

+ append() 和 appendTo() 方法执行的任务相同。不同之处在于：内容和选择器的位置，以及 append() 能够使用函数来附加内容

### clone

```JS
// clone() 方法生成被选元素的副本，包含子节点、文本和属性
$(selector).clone(includeEvents)

$("button").click(function(){
  $("body").append($("p").clone());
}); // 复制每个 p 元素，然后追加到 body 元素
```

### detach remove empty

```JS
// 两个方法 移除被选元素，包括所有文本和子节点
// 两个方法会保留 jQuery 对象中的匹配的元素，因而可以在将来再使用这些匹配的元素
$(selector).detach()
$(selector).remove()

// 删除被选元素的子元素
$(selector).empty()
```

+ detach() 会保留所有绑定的事件、附加的数据（除了这个元素本身得以保留之外，remove() 不会保留元素的 jQuery 数据）

### replaceAll replaceWith

```JS
$(content).replaceAll(selector)

$(selector).replaceWith(content)
$(selector).replaceWith(function())
```

+ replaceWith() 与 replaceAll() 作用相同。差异在于语法：内容和选择器的位置，以及 replaceAll() 无法使用函数进行替换。

### wrap unwrap wrapAll wrapInner

```JS
// wrap() 方法把每个被选元素放置在指定的 HTML 内容或元素中
$(selector).wrap(wrapper)
// wrapper
//      HTML 代码 - 比如 ("<div></div>")
//      新元素 - 比如 (document.createElement("div"))
//      已存在的元素 - 比如 ($(".div1"))
// 已存在的元素不会被移动，只会被复制，并包裹被选元素。

$(selector).wrap(function())

// unwrap() 方法删除被选元素的父元素
$(selector).unwrap()

// wrapAll() 在指定的 HTML 内容或元素中放置所有被选的元素
$(selector).wrapAll(wrapper)

// wrapInner() 方法使用指定的 HTML 内容或元素，来包裹每个被选元素中的所有内容 (inner HTML)
$(selector).wrapInner(wrapper)
$(selector).wrapInner(function())
```

### data

```JS
$(selector).data(name)
$(selector).data(name, value)
jQuery.hasData(element)
$(selector).removeData(name)
```

### DOM

```JS
$(selector).get(index)

$(selector).index() // 获得第一个匹配元素相对于其同胞元素的 index 位置
$(selector).index(element)

$(selector).size()
$(selector).toArray()
```

## CSS

```JS
$(selector).css(name)
$(selector).css(name, function(index, value))
$(selector).css(name, value)
$(selector).css({property: value, property: value, ...})
```

# 遍历

```JS
.children(selector)
.closest(selector) // 获得匹配选择器的第一个祖先元素，从当前元素开始沿 DOM 树向上
.contents() // 获得匹配元素集合中每个元素的子节点，包括文本和注释节点
.find(selector) // 获得当前元素集合中每个元素的后代，通过选择器、jQuery 对象或元素来筛选

.first() // 将匹配元素集合缩减为集合中的第一个元素
.last()
.eq(index) // 将匹配元素集缩减值指定 index 上的一个
.filter(selector) // 将匹配元素集合缩减为匹配指定选择器的元素
.has(selector) // 将匹配元素集合缩减为拥有匹配指定选择器或 DOM 元素的后代的子集
.is(selector) // 根据选择器、元素或 jQuery 对象来检测匹配元素集合，如果这些元素中至少有一个元素匹配给定的参数，则返回 true
.not(selector)

```

## each

```JS
// each() 方法规定为每个匹配元素规定运行的函数
$(selector).each(function(index, element))
// 返回 false 可用于及早停止循环
```

## end

```JS
// 结束当前链条中的最近的筛选操作，并将匹配元素集还原为之前的状态
.end() // 上一次的元素集
$("p").find("span").end().css("border", "2px red solid");
```

## map

```JS
// map() 把每个元素通过函数传递到当前匹配集合中，生成包含返回值的新的 jQuery 对象
.map(callback(index, domElement))

$(':checkbox').map(function() {
  return this.id;
}).get().join(',');

// 由于返回值是 jQuery 封装的数组，使用 get() 来处理返回的对象以得到基础的数组。
```

## next nextAll nextUnit

```JS
// next() 获得匹配元素集合中每个元素紧邻的同胞元素。如果提供选择器，则取回匹配该选择器的下一个同胞元素
.next(selector)

// nextAll() 获得匹配元素集合中每个元素的所有跟随的同胞元素，由选择器筛选是可选的
.nextAll(selector)

// nextUntil() 获得每个元素所有跟随的同胞元素，但不包括被选择器、DOM 节点或已传递的 jQuery 对象匹配的元素
.nextUntil(selector, filter)
.nextUntil(element, filter)
```

## offsetParent parent parents parentsUntil

```JS
// offsetParent() 获得被定位的最近祖先元素
.offsetParent()

// parent() 获得当前匹配元素集合中每个元素的父元素，使用选择器进行筛选是可选的
.parent(selector)

// parents() 获得当前匹配元素集合中每个元素的祖先元素
.parents(selector)

// parentsUntil() 获得当前匹配元素集合中每个元素的祖先元素，直到（但不包括）被选择器、DOM 节点或 jQuery 对象匹配的元素。
.parentsUntil(selector, filter)
.parentsUntil(element, filter)
```

## prev prevAll prevUntil

```JS
// prev() 获得匹配元素集合中每个元素紧邻的前一个同胞元素
.prev(selector)

// prevAll() 获得当前匹配元素集合中每个元素的前面的同胞元素
.prevAll(selector)

// prevUntil() 方法获得当前匹配元素集合中每个元素的前面的同胞元素，但不包括被选择器、DOM 节点或 jQuery 对象匹配的元素。
.prevUntil(selector, filter)
.prevUntil(element, filter)
```

## siblings

```JS
// siblings() 获得匹配集合中每个元素的同胞
.siblings(selector)
```

## slice

```JS
// slice() 把匹配元素集合缩减为指定的指数范围的子集
.slice(begin, end) // 左开右闭
```

# Ajax

```JS
jQuery.ajax([settings])

.ajaxStart(function())
.ajaxStop(function())
.ajaxComplete(function(event, xhr, options))
.ajaxError(function(event, xhr, options, exc))
.ajaxSend([function(event, xhr, options)])

jQuery.ajaxSetup(name: value, name: value, ...) // 设置全局 AJAX 默认选项

.ajaxSuccess(function(event, xhr, options))


$(selector).get(url, data, success(response, status, xhr), dataType)
jQuery.getJSON(url, data, success(data, status, xhr))
jQuery.getScript(url, success(response, status))

// load() 方法通过 AJAX 请求从服务器加载数据，并把返回的数据放置到指定的元素中
load(url, data, function(response, status, xhr))

// 创建数组或对象的序列化表示
jQuery.param(object, traditional)

// 通过 HTTP POST 请求从服务器载入数据
jQuery.post(url, data, success(data, textStatus, jqXHR), dataType)

$.ajax({
  type: 'POST',
  url: url,
  data: data,
  success: success,
  dataType: dataType
});


// 通过序列化表单值，创建 URL 编码文本字符串
// 序列化的值可在生成 AJAX 请求时用于 URL 查询字符串中
$(selector).serialize()

// serializeArray() 方法通过序列化表单值来创建对象数组（名称和值）
$(selector).serializeArray() // 返回的是 JSON 对象
```

# jQuery 工具

+ 旋转 [jQueryRotate](https://github.com/wilq32/jqueryrotate/)

