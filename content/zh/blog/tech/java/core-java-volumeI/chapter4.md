---
title: 第四章 对象与类
date: 2016-09-05T22:17:54+08:00
tags:
- Core Java Volume I
---

## Object-oriented programming (OOP)

+ 对象中第数据叫做实例域，操作数据的过程称为方法。
+ 实现封装的关键在于绝对不能让类中的方法直接地访问其他类的实例域.
+ 对象的三个主要特性:
> 对象的行为——可以对对象施加哪些操作，或可以对对象施加哪些方法？
> 对象的状态——当施加这些方法时，对象如何响应？
> 对象标识——如何辨别具有相同行为与状态的不同对象？

+ 对象的改变必须通过调用方法实现,否则说明封装性遭到破坏.
+ 对象的状态并不能完全描述一个对象。每个对象都有一个唯一的身份(identity)。作为一个类的实例,每个对象的标识永远是不同的,状态也常常存在差异.
+ 类之间的关系:
> 依赖("uses-a")
> 聚合("has-a")
> 继承("is-a")
+ 应该尽可能地将相互依赖的类减至最少.(让类之间的耦合度最小)
+ 聚合关系意味着类A的对象包含类B的对象.

## 日期类

+ 要想使用对象，就必须首先构造对象，并指定其初始状态。然后对对象应用方法。
+ 一个对象 变量并没有实际包含一个对象，而仅仅引用一个对象。

```java
Date deadline = new Date();
```

+ 表达式`new Date()`构造类一个Date类型的对象,并且他的值是对新创建对象到引用.这个引用存储在变量deadline中.(new操作符的返回值也是一个引用)
+ 局部变量不会自动地初始化为null,而必须通过调用new或将它们设置为null进行初始化.
+ 时间时用距离一个固定时间点的毫秒数（可正可负）表示的，这个点就是纪元，他是UTC时间1970年1月1日00：00：00和GMT（格林威治时间）一样。
+ 设计者决定将保存时间和给时间点命名分开，一个是用来表示时间点的Date类，另一个用来表示大家熟悉的日历表示法的GregorianCalendar类，GregorianCalendar类扩展了一个更加通用的类Calendar类，包含描述日历的一般属性。
+ 所有的Java对象都存储在堆中.当一个对象包含另一个对象变量时,这个变量依然包含着指向另一个堆对象的指针。
+ Java使用clone方法获得对象的完整拷贝。
+ Date类表示时间点,类中的getDay等方法,不鼓励使用。

```java
new GregorianCalendar();//构造一个新对象,用于表示对象构造时的日期和时间
new GregorianCalendar(1999, 11, 31);//构造一个表示某个特定日期午夜的日历对象,月份从0开始计数.
new GregorianCalendar(1999, Calendar.DECEMBER, 31);//使用常量
new GregorianCalendar(1999, Calendar.DECEMBER, 31, 23, 59, 59);//设置时间
```

+ Calendar类中定义的常量

```java
GregorianCalendar now = new GregorianCalendar();
int month = now.get(Calendar.MONTH);
int weekday = now.get(Calendar.DAY_OF_WEEK);
//调用set方法,可以改变对象的状态
deadline.set(Calendar.YEAR, 2001);
deadline.set(Calendar.MONTH, Calendar.APRIL);
deadline.set(Calendar.DAY_OF_MONTH, 15);
//设置年月日的方法
deadline.set(2001, Calendar.APRIL, 15);
//增加天数,星期数,月份
deadline.add(Calendar.MONTH, 3);//如果传递的是负值,日期就往前移
```

+ get方法仅仅查看并返回对象的状态,而set和add却对对象的状态进行修改.对实例域做出修改的方法称为**更改器方法**(mutator method),仅访问实例域而不进行修改的方法称为**访问器方法**(accessor method)

```java
//已知日历,创建包含这个时间值的Date对象
GregorianCalendar calendar = new GregorianCalendar(year, month, day);
Date hireDay = calendar.getTime();
//希望获得Date对象中的年月日信息
GregorianCalendar calendar = new GregorianCalendar();
calendar.setTime(hireDay);
int year = calendar.get(Calendar.YEAR);
```

+ 输出当前月的日历

```java
import java.text.DateFormatSymbols;
import java.util.Calendar;
import java.util.GregorianCalendar;
public class CalendarTest {
    public static void main(String[] args) {
        GregorianCalendar d = new GregorianCalendar();

        int today = d.get(Calendar.DAY_OF_MONTH);
        int month = d.get(Calendar.MONTH);

        d.set(Calendar.DAY_OF_MONTH, 1);

        int weekday = d.get(Calendar.DAY_OF_WEEK);
        int firstDayOfWeek = d.getFirstDayOfWeek();

        int indent = 0;
        while (weekday != firstDayOfWeek) {
            indent++;
            d.add(Calendar.DAY_OF_MONTH, -1);
            weekday = d.get(Calendar.DAY_OF_WEEK);
        }
        String[] weekdayNames = new DateFormatSymbols().getShortWeekdays();
        do {
            System.out.printf("%4s", weekdayNames[weekday]);
            d.add(Calendar.DAY_OF_MONTH, 1);
            weekday = d.get(Calendar.DAY_OF_WEEK);
        } while (weekday != firstDayOfWeek);
        System.out.print("");
        for (int i = 0; i < indent; i++) {
            System.out.print("  ");
        }
        d.set(Calendar.DAY_OF_MONTH, 1);
        do {
            int day = d.get(Calendar.DAY_OF_MONTH);
            System.out.printf("%3d", day);

            if(day == today) System.out.print("*");
            else System.out.print(" ");

            d.add(Calendar.DAY_OF_MONTH, 1);
            weekday = d.get(Calendar.DAY_OF_WEEK);

            if (weekday == firstDayOfWeek) System.out.println();
        } while (d.get(Calendar.DAY_OF_MONTH) == month);

    }
}
```

+ API

```java
GregorianCalendar()	构造一个日历对象，用来表示默认地区，默认时间的当前时间。
GregorianCalendar(int year, int month, int day)
GregorianCalendar(int year, int month, intday, int hour, int minutes, int seconds) //month ,以0为基准。
int get(int field) 返回给定域的值
void set(int field, int value) 设置特定域的值
void set(int year, int month, int day)
void set(int year, int month, int day, int hour, int minutes, int seconds)
void add(int field, int amount) 这是一个对日期实施算数运算的方法。对给定的时间域增加指定数量的时间。
int getFirstdayOFWeek()
void setTime(Date time) 将日历设置为指定的时间点
Date getTIme() 获得这个日历对象当前值所表达的时间点

String[] getShortWeekdays()
String[] getShortMonths()
String[] getWeekdays()
String[] getMonths()
//获得当前地区的星期几或月份的名称。利用Calendar的星期和月份常量作为数组索引值。
```

## 自定义类

+ 实例域，实例方法
+ 在一个源文件中只能有一个公有类,但可以有任意数目的非公有类.

```java
Private String name;//实例域,name域是String类对象.类通常包括某个类类型的实例域.
```

+ 构造器
> 构造器与类同名(在构造类的对象时，构造器会运行，以便将实例域初始化为所希望的状态)
> 每个类可以有一个以上的构造器
> 构造器可以有0个,1个或多个参数
> 构造器没有返回值
> 构造器总是伴随着new操作一起调用(而不能对一个已经存在的对象调用构造器来达到重新设置实例域的目的)

```java
new Employee("James Bond", 100000, 1950, 1, 1)`
```

+ 不要在构造器中定义与实例域重名的局部变量.(这些变量会屏蔽同名的实例域)
+ 隐式参数和显式参数

```java
number007.raiseSalay(5);//隐式参数是出现在方法名前的Employee类对象.在每一个方法中,关键字this表示隐式参数
public void raiseSalary(double byPercent) {
	double raise = this.salary * byPercent / 100;
    this.salary += raise;
}
```

+ 封装

```java
public String getName() {
	return name;
}
public double getSalary() {
	return salary;
}
public Date getHireDay() {
	return hireDay;
}//典型的访问器方法.由于它们只返回实例域值,因此又称为域访问器.
```

+ 需要获得或设置实例域的值.
> 一个私有的数据域;
> 一个公有的域访问器方法;
> 一个公有的域更改器方法.

+ 主要不要编写返回引用可变对象的域访问器方法。
+ 如果需要返回一个可变对象的引用，应该首先对它进行(clone),对象clone是指放在另一个位置上的对象副本。
+ final

```java
private final Date hiredate;//仅仅意味着存储在hiredate变量中的对象引用在对象构造之后不能被改变，而并不意味着hiredate对象是一个常量。任何方法都可以对hiredate引用的对象调用setTime更改器。
```

# 静态域和静态方法

## 静态域

+ 每个类中只有一个静态域。而每个对象对于所有的实例域却都有自己的一份拷贝。（实例对象共享这个域，即使没有一个实例对象，静态域还是存在的，它属于类不属于任何独立的对象）
+ 在绝大多数的面向对象程序设计中，静态域被称为类域。术语“static”只是沿用了C++的叫法，并无实际意义。

## 静态常量

+ Math.PI
+ System.out

```java
public class system {
	public static final PrintStream out = ...;
}
```

+ 公有常量（即final域）可以设为public 因为out被设置为final，所有不允许再将其他打印流赋给它
+ System类中有一个setOut方法，它可以将System.out设置为不同的流。这个方法可用修改final变量的值。原因在于，setOut方法是一个本地方法，而不是用Java语言实现的，本地方法可以绕过Java语言的存取控制机制。

##　静态方法

+ 静态方法是一种不能向对象实施操作的方法。（Math.pow(x, a),在运算时，不使用任何Math对象，没有隐式的参数，可以认为静态方法是没有this参数的方法）
+ 因为静态方法不能操作对象，所有不能在静态方法中访问实例域。但是静态方法可以访问自身类中的静态域。通过类名打点调用，可以省略关键字static，但是需要通过类对象的引用调用这个方法。（建议使用类名调用。）
+ 在下面类中情况使用静态方法
	1. 一个方法不需要访问对象状态，其所需参数都是通过显式参数提供（Math.pow）
	2. 一个方法只需要访问类静态域

##　工厂方法

+ NumberFormat（这里不利用构造器完成这些操作的，原因：）
	1. 无法命名构造器，构造器必须于类名相同，但是这里的希望得到的货币实例和百分比实例采用不同的名字。
	2. 当使用构造器的时，无法改变所构造的对象类型。而Factory方法将返回一个DecimalFormat类对象，这是NumberFormat的子类。

## main方法

+ 不需要使用对象调用静态方法。
+ main方法不对任何对象进行操作，事实上，在启动程序时还没有任何一个对象。静态的main方法将执行并创建程序所需要的对象。

# 方法参数

+ 程序设计语言中参数传递给方法（函数）的术语
	1. 按值调用。方法接受的是调用者提供的值。
	2. 按引用调用。方法接受的是调用者的提供的变量地址。
	3. 按名称调用。成为历史
+ Java采用的是按值调用。方法得到的是所有参数的一个拷贝，特别是，方法不能修改传递给它的任何参数变量的内容。
+ 方法参数类型
	1. 基本数据类型（数字，布尔值）
	2. 对象引用
+ 一个方法不可能修改一个基本数据类型的参数，而对象引用作为参数就可以了，方法得到的是对象的引用的拷贝，对象引用及其他拷贝同时引用同一个对象。


>表4-1 表达类关系的UML符号
图4-2 类图
图4-5 返回可变数据域的引用

