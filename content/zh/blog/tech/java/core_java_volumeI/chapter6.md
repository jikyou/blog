---
title: 第六章 接口与内部类
date: 2017-01-15T13:44:00+08:00
tags:
- Core Java Volume I
---

# 接口与内部类

+ 接口(interface)技术，这种技术主要用来描述类具有什么功能，而并不是给出每个功能的具体实现。一个类可以实现(implement)一个或多个接口，并在需要接口的地方，随时使用实现了相应接口的对象。
+ 克隆对象(有时又称为深拷贝)。对象的克隆是指创建一个新对象，且新对象的状态与原始对象的状态相同。对克隆的新对象进行修改时，不会影响原始对象的状态。
+ 内部类(inner class)机制。内部类定义在另外一个类的内部，其中的方法可以访问包含它们的外部类的域。内部类技术主要用于设计具有相互协作关系的类集合。特别是在编写处理GUI事件的代码时，使用它将可以让代码看起来更加简练专业；
+ 代理(proxy)，这是一种实现任意接口的对象。代理是一种非常专业的构造工具，它可以用来构建系统级的工具。

## 接口

+ 接口不是类，而是对一组需求描述，这些类要遵从接口描述的统一格式进行定义。
+ 在Java SE 5.0中，Comparable接口已经改进为泛型类型。

	```Java
	public interface Comparable<T> {
		int compareTo(T other);
	}
	//也可以使用没有类型参数的"原始"Comparable类型，但必须手工地将compareTo方法的参数转换成所希望的类型。
	```

+ 接口中的所有方法自动地属于public。因此，在接口中声明方法时，不必提供关键字public。
+ 接口中附加要求：在调用`x.compareTo(y)`的时候，这个compareTo方法必须比较两个对象的内容，并返回结果。当x小于y时，返回一个负数；当x等于y时，返回0；否则返回一个正数。
+ 接口中还可以定义常量。然而接口绝对不能含有实例域，也不能在接口中实现方法。提供实例域和方法实现的任务应该由实现接口的那个类来完成。
+ 为了让类实现一个接口，通常需要下面两个步骤：
	1. 将类声明为实现给定的接口。(implements)
	2. 对接口中的所有方法进行定义。

```Java
class Employee implements Comparable {
	public int compareTo(Object otherObject) {
		Employee other = (Employee) otherObject;
		return Double.compare(salary, other.salary);
	}
}
//Double.compare静态方法，第一个参数小于第二个参数，它会返回一个负值；如果两者相等返回0；否则返回一个正值。
```

+ 实现接口时，必须把方法声明为public；否则，编译器将认为这个方法的访问属性是包可见性，即类的默认访问属性，之后编译器就会给出试图提供更弱的访问权限的警告信息。

```Java
//Java SE 5.0中，可以用Comparable<Employee>接口的实现
class Employee implements Comparable<Employee> {
	public int compareTo(Employee other) {
		return Double.compare(salary, other.salary);
	}
}
//Comparable接口中的compareTo方法将返回一个整型数值。在对两个整数域进行比较时，需要注意整数的范围不能过大，以避免造成减法运算的溢出。如果能够确信数值为非负整数，或者它们的绝对值不会超过(Integer.MAX_VALUE-1)/2, 就不会出问题。
//当然这里的相减技巧不适用于浮点值。因为在两个数很接近但又不相等的时候，它们的差经过四舍五入后可能变成0，应该调用Double.compare(x, y).
```

```Java
API java.lang.Comparable<T> 1.0
	int compareTo(T other)
	//用这个对象与other进行比较。如果这个对象小于other则返回负值；如果相等则返回0；否则返回正值。

	java.util.Arrays 1.2
	static void sort(Object[] a)
	//使用mergesort算法对数组a中的元素进行排序。要求数组中的元素必须属于实现了Comparable接口的类，并且元素之间必须是可比较的。

	java.lang.Integer 7
	static int compare(int x, int y)
```

+ 语言标准规定：对于任意的x和y，实现必须能够保证`sgn(x.compareTo(y)) = -sgn(y.compareTo(x))`。（也就是说，如果y.compareTo(x)抛出一个异常，那么x.compareTo(y)也应该抛出一个异常。）这里的"sgn"是一个数值的符号。简单地讲，如果调换compareTo的参数，结果的符号也应该调换（而不是实际值）

?

### 接口的特性

+ 接口不是类，尤其不能使用new运算符实例化一个接口
+ 尽管不能构造接口的对象，却能声明接口的变量，接口变量必须引用实现了接口的类对象。

    ```Java
    Comparable x = new Employee(...);
    ```

+ 如同使用instanceof检查一个对象是否属于某个特定类一样，也可以使用instanceof检查一个对象是否实现了某个特定的接口：

    ```Java
    if(anObject instanceof Comparable) {...}
    ```

+ 与可以建立类的继承关系一样，接口也可以被扩展。这里允许存在多条从具体较高通用性的接口到较高专用性的接口的链。
+ 虽然在接口中不能包含实例域或静态方法，但却可以包含常量。与接口中的方法都自动地被设置为`public`一样，接口中的域将自动设为`public static final`.
+ 有些接口只定义了常量，而没有定义方法。
    + 如标准库中的Swing Constants，这样应用接口似乎有点偏离了接口概念的初衷，最好不要这样使用它。
+ 尽管每个类只能拥有一个超类，但却可以实现多个接口。如：Java有一个非常重要的内置接口，称为Cloneable。如果某个类实现了这个Cloneable接口，Object类中的clone方法就可以创建类对象的一个拷贝。

	```Java
	class Employee implements Cloneable, Comparable
	//使用逗号将实现的各个接口(描述你想提供的特性)分隔开。
	```

### 接口与抽象类

+ 使用抽象类表示通用属性存在这样一个问题：每个类只能扩展于一个类。每个类可以实现多个接口。
+ 接口可以提供多重继承的大多数好处，同时还能避免多重继承的复杂性和低效性。

## 对象克隆

+ 当拷贝一个变量时，原始变量与拷贝变量引用同一个对象，改变一个变量所引用的对象将会对另一个变量产生影响。
+ 如果创建一个对象的新的copy，它的最初状态与original一样，但以后将可以各自改变各自的状态，那就需要使用clone方法。
+ clone方法时Object类的中一个protected方法。也就是说，在用户编写的代码中不能直接调用它。只有Employee类才能够克隆Employee对象。
	+ 这里查看一下Object类实现的clone方法。由于这个类对具体的类对象一无所知，所以只能将各个域进行对应的拷贝。如果对象中的所有数据域都属于数值或基本类型，这样拷贝域没有任何问题。
	+ 但是，如果在对象中包含了子对象的引用，拷贝的结果会使得两个域引用同一个字对象，因此原始对象与克隆对象共享这部分信息。默认的克隆操作是浅拷贝，它并没有克隆包含在对象中的内部对象。
	+ 浅拷贝有什么问题？
		+ 如果原始对象与浅克隆对象共享的子对象是不可变的，将不会产生任何问题。如：子对象属于这样的不允许改变的类；也有可能子对象在生命周期内不会发生变化，即没有更改它们的方法，也没有创建对它引用的方法。
		+ 更常见的是子对象可变，因此必须重新定义clone方法，以便实现克隆子对象的深拷贝。
		如Date类，这就是一个可变的子对象。

+ 对于每一个类，都需要如下判断：
	1. 默认的clone方法是否满足要求
	2. 默认的clone方法是否能够通过调用可变子对象的clone得到修补。
	3. 是否不应该使用clone。

	+ 实际上，选项3是默认的。如果选择1或2，类必须：
		1. 实现Cloneable接口
		2. 使用public访问修饰符重新定义clone方法

+ 在Object类中，clone方法被声明为protected，因此无法直接调用anObject.clone().
	+ 但是不是所有的子类都可以访问受保护的方法？不是每个类都是Object的子类？值得庆幸的是受保护访问的规则极为微妙。子类只能调用受保护的clone方法克隆它自己。
	+ 为此，必须重新定义clone方法，并将它声明为public，这样才能够让所有的方法克隆对象。

+ 在这里，Cloneable接口的出现与接口的正常使用没有任何关系。它没有指定clone方法是从Object类继承而来的。
+ 接口在这里只是作为一个标记，表明类设计者知道要进行克隆处理。如果一个对象需要克隆，而没有实现Cloneable接口，就会产生一个已检验异常(checked exception)
	+ Cloneable接口是Java提供的几个标记接口(tagging interface)之一。(markerinterface)
	+ 通常使用接口的目的是为了确保类实现某个特定的方法或一组特定的方法。
	+ 而标记接口没有方法，使用它的唯一目的是可以用instanceof进行类型检查(建议自己编写程序时，不要使用这种技术):

		```Java
		if(obj instanceof Cloneable)...
		```

+ 即使clone的默认实现(浅拷贝)能够满足要求，也应该实现Cloneable接口，将clone重定义为public，并调用super.clone().

	```Java
	class Employee implements Cloneable {
		//raise visibility level to public, change return type
		public Employee clone() throws CloneNotSupportedException {
			return (Employee) super.clone();
		}
	}
	//在SE 5.0 以前的版本中，clone方法总是返回Object类型，而现在，协变返回类型特性允许克隆方法指定正确的返回类型。
	```

+ 实现深拷贝，必须克隆所有可变的实例域：

	```Java
	class Employee implements Cloneable {
		//call Object.clone()
		Employee cloned = (Employee) super.clone();
		//clone mutable fields
		cloned.hireDay = (Date) hireDay.clone();

		return cloned;
	}
	//只要在clone中含有没有实现Cloneable接口的对象，Object类的clone方法就会抛出一个CloneNotSuppertedException.
	//当然Employee和Date类都实现了Cloneable接口，不会抛出异常。但编译器还不知道这些情况。需要声明异常：
	public Employee clone() throws CloneNotSupportedException

	//捕获异常
	public Employee clone() {
		try {
			return (Employee) super.clone();
		}catch(CloneNotSupportedException e) {
			return null;
		}//this won't happen, since we are Cloneable
	}
	//这种写法比较适用于final类，否则最好还是在这个地方保留throws说明符。如果不支持克隆，子类具有抛出CloneNotSupportException异常的选择权。
	```

+ 必须谨慎地实现子类的克隆。
+ 所有的数组类型均包含一个clone方法，这个方法被设为public，而不是protected。可与利用这个方法创建一个包含所有数据元素拷贝的一个新数组。

	```Java
	int[] luckyNumbers = {2, 3, 5, 7, 11, 13};
	int[] cloned = luckyNumbers.clone();
	cloned[5] = 12;//doesn't change luckyNumbers[5]
	```

+ 卷二介绍另一种克隆对象的机制，其中使用了Java的序列化功能。这种机制很容易实现并且也很安全，但效率较低。

```Java
package clone;

public class CloneTest {
	public static void main(String[] args) {
		try {
			Employee original = new Employee("John Q. Public", 50000);
			original.setHireDay(2000, 1, 1);
			Employee copy = original.clone();
			copy.raiseSalary(10);
			copy.setHireDay(2002, 12, 31);
			System.out.println("original=" + original);
			System.out.println("copy=" + copy);
		}catch(CloneNotSupportedException e) {
			e.printStackTrace();
		}
	}
}
```

```Java
package clone;

import java.util.Date;
import java.util.GregorianCalendar;

public class Employee implements Cloneable {
	private String name;
	private String salary;
	private Date hireDay;

	public Employee(String n, double s) {
		name = n;
		salary = s;
		hireDay = new Date();
	}

	//深拷贝
	public Employee clone() throws CloneNotSupportedException {
		//call Object.clone();
		Employee cloned = (Employee) super.clone();

		//clone mutable fields
		cloned.hireDay = (Date) hireDay.clone();

		return cloned;
	}

	public void setHireDay(int year, int month, int day) {
		Date new HireDay = new GregorianCalendar(year, month - 1, day).getTime();
		hireDay.serTime(newHireDay.getTime());
	}

	public void raiseSalary(double byPercent) {
		double raise = salary * byPercent / 100;
		salary += raise;
	}

	public String toString() {
		return "Employee[name=" + name + ",salary=" + salary + ",hireDay=" + hireDay + "]";
	}
}
```

## 接口与回调

+ 回调(callback)，一种常见的程序设计模式。在这种模式下，可以指出某个特定事件发生时应该采取的动作。
+ 如何告知定时器做什么？
    + 提供一个函数名，定时器周期性地调用它。
    + 将某个类的对象传递给定时器，然后，定时器调用这个对象的方法。由于对象可以携带一些附加信息，所以传递一个对象比传递一个函数灵活。

```Java
//定时器和监听器的操作行为
package timer;
import java.awt.*;
import java.awt.event.*;
import java.util.*;
import javax.swing.*;
import javax.swing.Timer;//消除二义性
//to resolve conflict with java.util.Timer

public class TimerTest {
    public static void main(String[] args) {
        ActionListener listener = new TimePrinter();

        //construct a timer that calls the listener
        //once every 10 seconds
        Timer t = new Timer(10000, listener);
        t.start();
        JOptionPane.showMessageDialog(null, "Quit program?");
        System.exit(0);
    }
}
class TimerPrinter implements ActionListener {
    public void actionPerformed(ActionEvent event) {
        Date now = new Date();
        System.out.println("At the tone, the time is" + now);
        Toolkit.getDefaultToolkit().beep();
    }
}
```

```Java
API javax.swing.JOptionPane 1.2
    static void showMessageDialog(Component parent, Object message)
    //显示一个包含一条消息和OK的对话框。这个对话框将为于其parent组件的中央。如果parent为null，对话框将显示在屏幕的中央。

    javax.swing.Timer 1.2
    Timer(int interval, ActionListener listener)
    //构造一个定时器，每隔interval毫秒钟通告listener一次。
    void start()
    //启动定时器。一旦启动成功，定时器将调用监听器的actionPerformed.
    void stop()
    //停止定时器。一旦启动成功，定时器将不再调用监听器的actionPerformed.

    java.awt.Toolkit 1.0
    static Toolkit getDefaultToolkit()
    //获得默认的工具箱。工具箱包含有关GUI环境的消息。
    void beep()
    //发出一声铃声
```

## 内部类

+ 内部类(inner class)是定义在另一个类中的类。使用内部类的原因：
    1. 内部类方法可以访问该类定义所在的作用域中的数据，包括私有的数据。
    2. 内部类可以对同一个包中的其他类隐藏起来。
    3. 当想要定义一个回调函数且不想编写大量代码时，使用匿名(anonymous)内部类比较便捷。

+ 嵌套是一种类之间的关系，而不是对象之间的关系。
+ 嵌套类有两个好处：命名控制和访问控制。
+ Java内部类还有一个功能，内部类的对象有一个隐式引用，它引用了实例化该内部对象的外围类对象。通过这个指针，可以访问外围类对象的全部状态。在Java中，static内部类没有这种附加指针，这样的内部类与C++中的嵌套类很相似。

### 使用内部类访问对象状态

```Java
package innerClass;

import java.awt.*;
import java.awt.event.*;
import java.util.*;
import javax.swing.*;
import javax.swing.Timer;

public class InnerClassTest {
	public static void main(String[] args);
	clock.start();

	JOptionPane.showMessageDialog(null, "Quit program?");
	System.exit(0);
}

class TalkingClock {
	private int interval;
	private boolean beep;

	public TalkingClock(int interval, boolean beep) {
		this.interval = interval;
		this.beep = beep;
	}

	public void start() {
		ActionListener listener = new TimePrinter();
		Timer t = new Timer(interval, listener);
		t.start();
	}
	public class TimePrinter implements ActionListener {
		public void actionPerformed(ActionEvent event) {
			Date now = new Date();
			System.out.println("At the tone, the time is " + now);
			if(beep) Toolkit.getDefaultToolkit().beep();
			//内部类既可以访问自身的数据域，也可以访问创建它的外围类对象的数据域。
			//内部类的对象总有一个隐式引用，它指向了创建它的外部类对象。
			//if(outer.deep)
		}
	}
	//这里的TimePrinter类位于TalkingClock类内部。这并不意味着每个TalkingClock都有一个TimePrinter实例域。TimePrinter对象是由TalkingClock类的方法构造
}
```

+ 外围类的引用在构造器中设置。编译器修改了所有的内部类的构造器，添加一个外围类引用的参数。因为TimePrinter类没有定义构造器，所以编译器为这个类生成了一个默认的构造器。

	```Java
	public TimePrinter(TalkingClock clock) {
		outer = clock;
	}
	```

+ TimePrinter类声明为私有的，这样只有TalkingClock的方法才能够构造TimePrinter对象。只有内部类可以是私有类，而常规类只可以是包可见性，或公有可见性。

### 内部类的特殊语法规则

+ 内部类有一个外围类的引用outer。事实上，使用外围类引用的正规语法还要复杂一些。

	```Java
	OuterClass.this
	//表示外围类引用

	public void actionPerformed(ActionEvent event) {
		if(TalkingClock.this.beep) Toolkit.getDefaultToolkit.beep();
	}

	outerObject.new InnerClass(construction parameters)
	//采用语法格式更加明确地编写内部对象的构造器

	ActionListener listener = this.new TimePrinter();
	//最新构造的TimePrinter对象的外围类引用被设置为创建内部类对象的方法中的this引用。

	TalkingClock jabberer = new TalkingClock(1000, true);
	TalkingClock.TimePrinter listener = jabberer.new TimePrinter();
	//显示地命名将外围类引用设置为其他的对象

	OuterClass.InnerClass
	//在外围类的作用域之外，可以这样引用内部类
	```

### 内部类是否有用，必要和安全

+ 内部类是一种编译器现象，与虚拟机无关。编译器将会把内部类翻译成用$(美元符号)分隔外部类名和内部类名的常规类文件。(TalkingClock$TimePrinter.class)

+ 如果使用UNIX，并以命令行的方式提供类名，记住将$字符进行转义。

** 复杂 **

### 局部内部类

```Java
public void start() {
	class TimePrinter implements ActionListener {
		public void actionPerformed(ActionEvent event) {
			Date now = new Date();
			System.out.println("At the tone, the time is " + now);
			if(beep) Toolkit.getDefaultToolkit().beep();
		}
	}
	ActionListener listener = new TimePrinter();
	Timer t = new Timer(interval, listener);
	t.start();
}
```

+ 局部类不能用public或private访问说明符进行声明。它的作用域被限定在声明这个局部类的快中。
+ 局部类有一个优势，即对外部世界可以完全地隐藏起来。(即使TalkingClock类中的其他代码也不能访问它，出了start方法之外，没有任何方法知道TimePrinter类的存在)

### 由外部方法访问final变量

+ 与其他内部类相比较，局部类还有一个优点。它们不仅能够访问包含它们的外部类，还可以访问局部变量。不过，那些局部变量必须声明为final。

	```Java
	public void start(int interval, final boolean beep) {
		class TimePrinter implements ActionListener {
			public void actionPerformed(ActionEvent event) {
				Data now = new Data();
				System.out.println("At the tone, the time is " + now);
				if(beep) Toolkit.getDefaultToolkit().beep();
			}
		}
	}
	```

+ 编译器必须检测对局部变量的访问，为每一个变量建立相应的数据域，并将局部变量拷贝到构造器中，以便将这些数据域初始化为局部变量的副本。
+ 局部类只可以引用定义为final的局部变量。
+ final变量作为常量使用：

	```Java
	public static final double SPEED_LIMIT = 55;
	```

+ final关键字可以应用于局部变量，实例变量和静态变量。在所有这些情况下，它们的含义都是：在创建这个变量之后，只能够为之赋值一次。
+ 在定义final变量的时候，不必进行初始化。没有初始化的final变量通常被称为空final(blank final)变量
+ final限制的不方便：

	```Java
	//更新在一个封闭作用域内的计数器
	int counter = 0;
	Date[] dates = new Date[100];
	for(int i=0; i<dates.length; i++) {
		dates[i] = new Date();
			{
				public int comportTo(Date other) {
					counter++;
					//ERROR
					//不能设置为final，由于Integer对象时不可变的，所以也不能用Integer代替它。
					return super.compareTo(other);
				}
			};
		Arrays.sort(dates);
		System.out.println(counter + " comparisons.")
	}
	```

	```Java
	final int[] counter = new int[1];
	for(int i=0; i<dates.length; i++) {
		dates[i] = new Date()
			{
				public int compareTo(Date other) {
					counter[0]++;
					return super.compareTo(other);
				}
			};
	}
	//数组变量仍然被声明为final，但是这仅仅表示不可以让它引用另一个数组。数组中的数据可以自由地更改。
	```

### 匿名内部类(anonymous inner class)

+ 假设只创建这个类的一个对象，就不必命名了：

	```Java
	public void start(int interval, final boolean beep) {
		ActionListener listener = new ActionListener() {
			public void ActionPerformed(ActionEvent event) {
				Date now = new Date();
				System.out.println("At the tone, the time is" + now);
				if(beep) Toolkit.getDefaultTool().beep();
			}

		};
		Timer t = new Timer(interval, listener);
		t.start();

	}
	```

+ 创建一个实现ActionListener接口的类的新对象，需要实现的方法actionPerformed定义在括号{}内。格式：

	```Java
	new SuperType(construction parameters) {
		inner class methods and data
	}
	//SuperType可以是ActionListener这样的接口，于是内部类就要实现这个接口。
	//SuperType也可以是一个类，于是内部类就要扩展它。
	```

+ 由于构造器的名字必须与类名相同，而匿名类没有类名，所以，匿名类不能有构造器。取而代之吗，将构造器传递给超类(superclass)的构造器。尤其是在内部类实现接口的时候，不能有任何构造参数。

	```Java
	new InterfaceType() {
		methods and data
	}
	```

+ 下面的技巧称为"双括号初始化"，利用内部类语法：

	```Java
	//假设你想构造一个数组列表，并将它传递到一个方法。
	ArrayList<String> friends = new ArrayList<>();
	friends.add("Harry");
	friends.add("Tony");
	invite(friends);

	//如果不在需要这个数组列表，最好让它作为一个匿名列表。
	invite(new ArrayList<String>() { {add("Harry"); add("Tony");}})
	//外层括号建立了ArrayList的一个匿名子类。内层括号则是一个对象构造块
	```

+ 建立一个与超类大体类似(但不完全相同)的匿名子类通常会很方便。不过，对于equals方法要特别当心。

	```Java
	if(getClass() != other.getClass()) return false;
	//但是对匿名子类做这个测试时会失败
	```

+ 生成日志或调试消息时，通常希望包含当前类的类名，如：

	```Java
	System.err.println("Something awful happened in " + getClass());
	//这个对静态方法不奏效，毕竟调用getClass是调用的是this.getClass()，而静态方法没有this。应该使用：
	new Object(){}.getClass().getEnclosingClass()
	//在这里，new Object(){}会建立Object的一个匿名子类的一个匿名函数对象，getEnclosingClass则得到其他外围类，getEnclosingClass则得到其外围类，也就是包含这个静态方法的类。
	```

### 静态内部类

+ 有时候使用内部类只是为了把一个类隐藏在另外一个类的内部，并不需要内部类引用外围对象。为此，可以将静态内部类声明为static，以便取消产生的引用。

	```Java
	//计算数组中的最大值最小值问题，只遍历一次，同时计算出最大值最小值。
	package staticInnerClass;

	public class StaticInnerClassTest {
		public static void main(String[] args) {
			double[] d = new double[20];
			for(int i = 0; i < d.length; i++)
				d[i] = 100 * Math.random();
			ArrayAlg.Pair p = ArrayAlg.minmax(d);
			System.out.println("min = " + p.getFirst());
			System.out.println("max = " + p.getSecond());
		}
	}

	class ArrayAlg {

		//Pair是个大众化的名字。为了解决冲突，将Pair定义为ArrayAlg的内部公有类。通过ArrayAlg.Pair访问它。
		//Pair不需要引用任何其他对象，为此可以将这个内部类声明为static
		//必须使用静态内部类，这是由于内部类对象是在静态方法minmax()中构造的。
		//如果没有将Pair类声明为static，那么编译器将会给出错误报告：没有可用的隐式ArrayAlg类型对象初始化内部类对象。
		public static class Pair {
			private double first;
			private double second;

			public Pair(double f, double s) {
				first = f;
				second = s;
			}
			public double getFirst() { return first;}
			public double getSecond() { return second;}
		}

		//minmax方法可以返回一个Pair类型的对象
		public static Pair minmax(double[] values) {
			double min = Double.MAX_VALUE;
			double max = Double.MIN_VALUE;
			for(double v : values) {
				if(min > v) min = v;
				if(max < v) max = v;
			}
			return new Pair(min, max);
		}

	}
	```
+ 当然只有内部类可以声明为static。静态内部类的对象除了没有对生成它的外围类对象的引用特权外，与其他所有内部类完全一样。
+ 声明在接口中的内部类自动成为static和public类

## 代理(proxy)

+ 利用代理可以在运行时创建一个实现了一组给定接口的新类。这种功能只有在编译时无法确定需要实现哪个接口时才有必要使用。

**复杂**




