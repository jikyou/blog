---
title: 第十二章 泛型程序设计
date: 2017-01-23T15:03:00+08:00
tags:
- Core Java Volume I
---

# 泛型程序设计

+ 使用泛型机制编写的程序代码要比那些杂乱地使用Object变量，然后再进行强制类型转换的代码具有更好的安全性和可读性。
+ 泛型对于集合类尤其有用。例如：ArrayList

## 为什么要使用泛型程序设计

+ 泛型程序设计意味着编写的代码可以被很多不同的对象所重用。

	```Java
	//在Java中增加泛型类之前，泛型程序设计是用继承实现的
	public class ArrayList {
		private Object[] elementData;
		...
		public Object get(int i) { ... }
		public void add(Object o) { ... }
	}

	//这样实现有两个问题。当获取一个值时必须进行强制类型转换。
	ArrayList files = new ArrayList();
	.
	String filename = (String) files.get(0);

	//没有类型检查，可以向数组列表中添加任何类的对象
	files.add(new File("..."));
	//如果将get的结果，强制转换成类型转换为String类型，就会产生一个错误
	```

+ 泛型提供了一个更好的解决方案：类型参数(type parameters)。

	```Java
	//ArrayList类有一个类型参数用来指示参数的类型：
	ArrayList<String> files = new ArrayList<String>();

	//在Java SE 7及以后的版本中，构造函数中可以省略泛型类型。
	ArrayList<String> files = new ArrayList<>();
	//省略的类型可以从变量的类型推断得出。

	//编译器可以很好地利用这个信息。当调用get的时候，不需要进行强制类型转换，编译器就知道返回值类型为String，而不是Object：
	String filename = files.get(0);

	//编译器可以检查，避免插入错误类型的对象。
	files.add(new File("..."));//can only add String objects to an ArrayList<String>
	```

+ 通配符类型(wildcard type)。

## 定义简单泛型类

+ 一个泛型类(generic class)就是具有一个或多个类型变量的类。

	```Java
	public class Pair<T> {
		private T first;
		private T second;

		public Pair() { first = null; second = null; }
		public Pair(T first, T second) { this.first = first; this.second = second;}

		public T getFirst() { return first;}
		public T getSecond() { return second;}

		public void setFirst(T newValue) { first = newValue;}
		public void setSecond(T newValue ) { second = newValue;}
	}
	//Pair类引入一个类型变量T，用尖括号(<>)括起来，并放在类名的后面。
	//泛型类可以有多个类型变量。
	public class Pair<T, U> { ... }//定义Pair类，其中第一个域和第二个域使用不同的类型
	```

+ 类定义的类型变量指定方法的返回类型以及域和局部变量的类型。

+ 类型变量使用大写形式，且比较短。在Java库中，使用变量E表示集合的元素类型，K和V分别表示表的关键字与值的类型。T(需要时还可以用临近的字母U和S)表示“任意类型”

+ 用具体的类型替换类型变量就可以实例化范型类型。

	```Java
	Pair<String>

	//可以将结果想象成带有构造器的普通类
	Pair<String>()
	Pair<String>(String, String)
	//方法
	String getFirst()
	String getSecond()
	void setFirst(String)
	void setSecond(String)
	```

+ 泛型类可看作普通类的工厂

```Java
package pair1;

public class PairTest1 {
	public static void main(String[] args) {
		String[] words = { "Mary", "had", "a", "little", "lamb"};
		Pair<String> mm = ArrayAlg.minmax(words);
		System.out.println("min = " + mm.getFirst());
		System.out.println("max = " + mm.getSecond());
	}
}

class ArrayAlg {
	public static Pair<String> minmax(String[] a) {
		if(a == null || a.length == 0) return null;
		String min = a[0];
		String max = a[0];
		for(int i = 1; i < a.length; i++) {
			if(min.compareTo(a[i]) > 0) min = a[i];
			if(max.compareTo(a[i]) < 0) max = a[i];
		}
		return new Pair<>(min, max);
	}
}
```

## 泛型方法

```Java
class ArrayAlg {
	public static <T> T getMiddle(T... a) {
		return a[a.length / 2];
	}
}
```

+ 类型变量放在修饰符的后面，返回类型的前面。
+ 泛型方法可以定义在普通类中，也可以定义在泛型类中。

```Java
//当调用一个泛型方法时，在方法名前的尖括号中放入具体的类型：
String middle = ArrayAlg.<String>getMiddle("John", "Q.", "Public");

//在大多数情况下，方法调用中可以省略<String>类型参数。编译器有足够的信息能够推断出所调用的方法。
//它用names的类型(String[])与泛型类型T[]进行匹配并推断出T一定是String
String middle = ArrayAlg.getMiddle("John", "Q.", "Public");

//编译器也会提示报错
double middle = ArrayAlg.getMiddle(3.14, 1729, 0);
//错误消息会以晦涩的方式指出(不同的编译器给出的错误消息可能有所不同)：解释这句代码有两种方法，而且这两种方法都是合法的。简单地说，编译器将会自动打包参数为1个Double和2个Integer对象，而后寻找这些类的共同超类型。事实上，找到2个这样的超类型：Number和Comparable接口，其本身也是一个泛型类型。在这种情况下，可以采取的补救措施是将所有的参数写为double值。
```

## 类型变量的限定

+ 有时候，类或方法需要对类型变量加以约束。

	```Java
	//计算数组中的最小元素
	class ArrayAlg {
		public static <T> T min(T[] a) {//almost correct
			if(a == null || a.length == 0) return null;
			T smallest = a[0];
			for(int i = 1; i < a.length; i++)
				if(smallest.compareTo(a[i]) > 0) smallest = a[i];
			return smallest;
		}
	}

	//保证T所属的类有compareTo方法？
	//将T限制为实现了Comparable接口(只含有一个方法compareTo的标准接口)的类。可以通过对类型变量T设置限定(bound)实现这一点：
	public static <T extends Comparable> T min(T[] a) ...

	//实际上Comparable接口本身就是一个泛型类型。
	```

+ 为什么使用关键字extends而不是implements？毕竟，Comparable是一个接口。

	```Java
	<T extends BoundingType>
	//表示T应该是绑定类型的子类型(subtype)。T和绑定类型可以是类，也可以是接口。选择关键字extends的原因是更接近子类的概念，并且Java设计者也不打算在语言中再添加一个新的关键字(如sub)

	//一个类型变量或通配符可以有多个限定。
	T extends Comparable & Serializable
	```

+ 限定类型用"&"分隔，而逗号用来分隔类型变量。
+ 在Java继承中，可以根据需要拥有多个接口超类型，但限定中至多有一个类。如果用一个类作为限定，它必须是限定列表中的第一个。

	```Java
	package pair2;

	import java.util.*;

	public class PairTest2 {
		public static void main(String[] args) {
			GregorianCalendar[] birthdays =
				{
					new GregorianCalendar(1906, Calendar.DECEMBER, 9),
					new GregorianCalendar(1815, Calendar.DECEMBER, 10),
					new GregorianCalendar(1903, Calendar.DECEMBER, 3),
					new GregorianCalendar(1910, Calendar.JUNE, 22),
				};
			Pair<GregorianCalendar> mm = ArrayAlg.minmax(birthdays);
			System.out.println("min = " + mm.getFirst().getTime());
			System.out.println("max = " + mm.getSecond().getTime());
		}
	}
	class ArrayAlg {
		public static <T extends Comparable> Pair<T> minmax(T[] a) {
			if(a == null || a.length == 0) return null;
			T min = a[0];
			T max = a[0];
			for(int i = 1; i < a.length; i++) {
				if(min.compareTo(a[i]) > 0) min = a[i];
				if(max.compareTo(a[i]) < 0) max = a[i];
			}
			return new Pair<>(min, max);
		}
	}
	```

## 泛型代码和虚拟机。

+ 虚拟机没有泛型类型对象--所有对象都属于普通类。
+ 无论何时定义一个泛型类型，都自动提供了一个相应的原始类型(raw type)。原始类型的名字就是删去类型参数后的泛型类型名。擦除(erased)类型变量，并替换为限定类型(无限定的变量用Object)

	```Java
	//Pair<T>的原始类型
	public class Pair {
		private Object first;
		private Object second;

		public Pair(Object first, Object second) {
			this.first = first;
			this.second = second;
		}

		public Object getFirst() { return first; }
		public Object getSecond() { return second; }

		public Object setFirst(Object newValue) { first = newValue; }
		public Object setSecond(Object newValue) { second = newValue; }
	}

	//在程序中可以包含不同类型的Pair。例如：Pair<String>或Pair<GregorianCalendar>，而擦除后就变成了原始的Pair类型了。
	```

+ 原始类型用第一个限定的类型变量来替换，如果没有给定限定就用Object替换。

	```Java
	public class Interval<T extends Comparable & Serializable> implements Serializable {
		private T lower;
		private T upper;
		...
		public Interval(T first, T second) {
			if(first.compareTo(second) <= 0) { lower = first; upper = second; }
			else { lower = second; upper = first; }
		}
	}

	//原始类型Interval：
	public class Interval implements Serializable {
		private Comparable lower;
		private Comparable upper;
		...
		public Interval(Comparable first, Comparable second) { ... }
	}

	//切换限定：class Interval<Serializable & Comparable>会发生什么。
	//如果这样做，原始类型用Serializable替换下，而编译器在必要时向Comparable插入强制类型转换。为了提高效率，应该将标签接口(tagging)接口(即没有方法的接口)放在边界列表的末尾。
	```

### 翻译泛型表达式

+ 当程序调用泛型类型方法时，如果擦除返回类型，编译器插入强制类型转换。

	```Java
	Pair<Employee> buddies = ...;
	Employee buddy = buddies.getFirst();

	//擦除getFirst的返回类型后将返回Object类型，编译器自动插入Employee的强制类型转换。
	```

+ 编译器把这个方法调用翻译为两条虚拟机指令：
	+ 对原始方法Pair.getFirst的调用
	+ 将返回的Object类型强制转换为Employee类型

+ 当存取一个泛型域时也要插入强制类型转换。

### 翻译泛型方法

+ 类型擦除也会出现在泛型方法中。

	```Java
	public static <T extends Comparable> T min(T[] a)

	//擦除类型之后(类型T已经被擦除了，只留下了限定类型Comparable)
	public static Comparable min(Comparable[] a)
	```

+ 方法的擦除带来两个复杂的问题

	```Java
	class DateInterval extends Pair<Date> {
		public void setSecond(Date second) {
			if(second.compareTo(getFirst()) >= 0)
				super.setSecond(second);
		}
		...
	}

	//擦除之后
	class DateInterval extends Pair {
		public void setSecond(Date second) { ... }
		...
	}
	//令人感到奇怪的是，存在另外一个从Pair继承的setSecond方法，即
	public void setSecond(Object second)

	//这是一个不同的方法，因为它有一个不同类型参数-Object。
	DateInterval interval = new DateInterval(...);
	Pair<Date> pair = interval;
	pair.setSecond(aDate);

	//类型擦除与多态发生了冲突，要解决这个问题，就需要编译器在DataInterval类中生成一个桥方法。
	public void setSecond(Object second) { setSecond((Date) second); }

	//假设DateInterval方法也覆盖了getSecond方法：
	class DateInterval extends Pair<Date> {
		public Date getSecond() { return (Date) super.getSecond().clone();}
		...
	}

	//在擦除的类型中，有两个getSecond方法:
	Date getSecond() // defined in DateInterval
	Object getSecond() // override the method defined in Pair to call the first method

	//不能这样编写Java代码(在这里，具有相同参数类型的两个方法是不合法的)它们都没有参数。
	//但是，在虚拟机中，用参数类型和返回类型确定一个方法。
	//因此，编译器可能产生两个仅返回类型不同的方法字节码，虚拟机能够正确地处理这一情况。
	```

+ 桥方法不仅用于泛型类型。一个方法覆盖另一个方法时可以指定一个更严格的返回类型。

	```Java
	public class Employee implements Cloneable {
		public Employee clone() throws CloneNotSupportedException { ... }
	}

	//Object.clone和Employee.clone方法被说成具有协变的返回类型(covariant return types)
	//实际上，Employee类有两个克隆方法：
	Employee clone() //define above
	Object clone() // synthesized bridge method, overrides Object.clone

	//合成桥方法调用了新定义的方法。
	```

+ 有关Java泛型转换的事实
	+ 虚拟机中没有泛型，只有普通的类合和方法。
	+ 所有的类型参数都用它们的限定类型替换。
	+ 桥方法被合成来保持多态。
	+ 为保持类型安全性，必要时插入强制类型转换。

### 调用遗留代码

+ 设计Java泛型类型时，主要目标是允许泛型代码和遗留代码之间能够互操作。

	```Java
	//查看了警告之后，可以利用注释(annotation)使之消失。注释必须放在生成这个警告的代码所在的方法之前。
	@SuppressWarning("unchecked")
	Dictionary<Integer, Components> labelTable = slider.getLabelTable();

	//或者可以标注整个方法
	@SuppressWarnings("unchecked")
	public void configureSlider() { ... }
	//这个标注会关闭对方法中所有代码的检查
	```

## 约束与局限性

+ 下面将阐述使用Java泛型时需要考虑的一些限制。大多数限制都是由类型擦除引起的。

### 不能用基本类型实例化类型参数

+ 不能用类型参数代替基本类型。没有Pair<double>，只有Pair<Double>。原因是类型擦除。擦除之后，Pair类含有Object类型的域，而Object不能存储double值。

+ 当包装器类型(wrapper type)不能接受替换时，可以使用独立的类和方法处理它们。

### 运行时类型查询只适用于原始类型

+ 虚拟机中的对象总有一个特定的非泛型类型。因此，所有的类型查询只产生原始类型。

	```Java
	if(a instanceof Pair<String>) //ERROR
	//实际上仅仅测试a是否是任意类型的一个Pair，下面同样：
	if(a instanceof Pair<T>) //ERROR

	//强制类型转换：
	Pair<String> p = (Pair<String>) a; //WARNING--can only test that a is a Pair

	//要记住这一风险，无论何时使用instanceof或涉及泛型类型的强制类型转换表达式都会看到一个编译器警告。

	//getClass方法总是返回原始类型
	Pair<String> stringPair = ...;
	Pair<String> employeePair = ...;
	if(stringPair.getClass() == employeePair.getClass()) //they are equal
	//比较结果是true，这是因为两次调用getClass都是返回Pair.class
	```

### 不能创建参数化类型的数组

+ 不能实例化参数化类型的数组。

	```Java
	Pair<String>[] table = new Pair<String>[10]; //ERROR
	//擦除之后，table的类型是Pair[]。可以把它转换为Object[]:
	Object[] objarray = table;
	//数组会记住它的元素类型，如果试图存储其他类型的元素，就会抛出一个Array-StoreException异常：
	objarray[0] = "Hello"; //ERROR--component type is Pair
	//不过对于泛型类型，擦除会使这种机制无效。以下赋值：
	objarray[0] = new Pair<Employee>();
	//能够通过数组存储检查，不过仍会导致一个类型错误。出于这个原因，不允许创建参数化类型的数组。
	//需要说明的是，只是不允许创建这些数组，而声明类型为Pair<String>[]的变量仍是合法的。不过不能用new Pair<String>[10]初始化这个变量。
	```

+ 可以声明通配类型的数组，然后进行类型转换：

	```Java
	Pair<String>[] table = (Pair<String>[] new Pair<?>)[10];
	//结果将是不安全的。如果在table[0]中存储一个Pair<Employee>，然后对table[0].getFirst()调用一个String方法，会得到一个ClassCastException异常。
	```

+ 如果需要收集参数化类型对象，只有一种安全而有效的方法：使用`ArrayList:ArrayList<Pair<String>>`

### Varargs警告

### 不能实例化类型变量

+ 不能使用像new T(...), new T[...]或T.class这样的表达式中的类型变量。

	```Java
	public Pair() {
		first = new T(); second = new T();//ERROR
	}
	//类型擦除将T改变成Object。
	//本意肯定不希望调用new Object()。可以通过反射调用Class.newInstance方法来构造泛型对象。
	first = T.class.newInstance();//ERROR
	//表达式T.class是不合法的。必须像下面这样设计API以便可以支配Class对象：
	public static <T> Pair<T> makePair(Class<T> c1) {
		try {
			return new Pair<>(c1.newInstance(), c1.newInstance())
		}catch(Exception ex) {
			return null;
		}
	}

	//按照下列方式调用
	Pair<String> p = Pair.makePair(String.class);

	```

### 泛型类的静态上下文中类型变量无效

+ 不能再静态域或方法中引用类型参数

### 不能抛出或捕获泛型类的实例

+ 即不能抛出也不能捕获泛型类对象。实际上，甚至泛型类扩展Throwable都是不合法的。

+ catch子句中不能使用类型变量

+ 在异常规范中使用类型变量时允许的

	```Java
	public static <T extends Throwable> void doWork(T t) throws T {
		try {
			do work
		}catch(Throwable realCause) {
			t.initCause(realCause);
			throw t;
		}
	}
	```

+ 可以消除对已检查异常的检查
	+ Java异常处理的一个基本原则是，必须为所有已检查异常提供一个处理器。不过可以利用泛型消除这个限制。

	```Java
	@SuppressWarnings("unchecked")
	public static <T extends Throwable> void throwAs(Throwable e) throws T {
		throw(T) e;
	}
	```

### 注意擦除后的冲突

+ 当泛型类型被擦除时，无法创建引发冲突的条件。

	```Java
	public class Pair<T> {
		public boolean equals(T value) {
			return first.equals(value) && second.equals(values);
		}
		...
	}

	//考虑Pair<String>。从概念上讲，它有两个equals方法：
	boolean equals(String) //defined in Pair<T>
	boolean equals(Object) // inherited from Object

	//但是，直觉把我们引入歧途，方法擦除
	boolean equals(T)
	//就是
	boolean equals(Object)
	//与Object.equals(Object)方法发生冲突

	//补救办法是重新命名引发错误的方法
	```

+ 泛型规范说明还提到另外一个原则：“要想支持擦除的转换，就需要强行限制一个类或类型变量不能同时成为两个接口类型的子类，而这两个接口时同一接口的不同参数化”

## 泛型类型的继承规则

+ 无论S与T有什么联系，通常，`Pair<S>`与`Pair<T>`没什么联系

+ 必须注意泛型与Java数组之间的重要区别。
	+ 可以将一个Manager[]数组赋给一个类型为Employee[]的变量：

	```Java
	Manager[] managerBuddies = { ceo, cfo};
	Employee[] employeeBuddies = managerBuddies;//OK
	```

	+ 数组带有特别的保护。如果试图将一个低级别的雇员存储到employeeBuddies[0]，虚拟机将会抛出ArrayStoreException异常。

+ 永远可以将参数化类型转换为一个原始类型。例如，Pair<Employee>是原始类型Pair的一个子类型。在与遗留代码衔接时，这个转换非常有必要。
	+ 但是，转换成原始类型之后会产生类型错误。

## 通配符类型

```Java
Pair<Manger> mangerBuddies = new Pair<>(ceo, cfo);
Pair<? extends Employee> wildcardBuddies = managerBuddies;//OK
wildcardBuddies.setFirst(lowlyEmployee);//compile-time error

//对setFirst的调用有一个类型错误。要了解其中的缘由，看一看类型Pair<? extends Employee>
? extends Employee getFirst()
void setFirst(? extends Employee)

//这样就不能调用setFirst方法。编译器只知道需要某个Employee的子类型，但不知道具体是什么类型。它拒绝传递任何特定的类型。毕竟？不能用来匹配
//使用getFirst就不存在这个问题：将getFirst的返回值赋给一个Employee的引用完全合法。
//这就是引入有限定的通配符的关键之处。现在已经有办法区分安全的访问器方法和不安全方法的更改器方法了。
```

### 通配符的超类型限定

```Java
? super Manger
//这个通配符限制为Manager的所有超类型

//带有超类型限定的通配符的行为与上面的限定相反。
//可以为方法提供参数，但不能使用返回值。

//例如，Pair<? super Manager> 有方法
void setFirst(? super Manager)
? super Manager getFirst()

//编译器步骤setFirst方法的确切类型，但是可以用任意Manager对象(或子类型)调用它，而不能用Employee对象调用。然而，如果调用getFirst，返回的对象类型就不会得到保证。只能把它赋给一个Object
```

+ 直观的讲，带有超类型限定的通配符可以向泛型对象写入，带有子类型限定的通配符可以从泛型对象读取。

+ 超类型限定的另一种应用。Comparable接口本省就是一个泛型类型。

	```Java
	public interface Comparable<T> {
		public int compareTo(T other);
	}
	//参数变量指示了other参数的类型。
	//例如，String类实现Comparable<String>，它的compareTo方法被声明为
	public int compareTo(String other)

	//显示参数有一个正确的类型。在Java SE 5.0之前，other是一个Object，并且这个方法的实现需要强制类型转换。

	public static <T extends Comparable<T>> T min(T[] a)

	//当处理一个GregorianCalendar对象的数组时，就会出现问题。GregorianCalendar是Calendar的子类，并且Calendar实现了Comparable<Calendar>.因此GregorianCalendar实现的是Comparable<Calendar>,而不是Comparable<GregorianCalendar>

	public static <T extends Comparable<? super T>> T min(T[] a)...

	//现在compareTo方法写成
	int compareTo(? super T)
	```

### 无限定通配符

```Java
//例如，Pair<?> 初看起来，这好像与原始的Pair类型一样。实际上有很大的不同。类型Pair<?>有方法：
? getFirst()
void setFirst(?)

//getFirst的返回值只能赋值给一个Object。setFirst方法不能被调用，甚至不能用Object调用。
//Pair<?>和Pair本质的不同在于：可以用任意Object对象调用原始的Pair类的setObject方法。
//可以调用setFirst(null)

//测试一个pair是否包含一个null引用，它不需要实际的类型
public static boolean hasNulls(Pair<?> p) {
	return p.getFirst() == null || p.getSecond() == null;
}

//通过将hasNulls转换成泛型方法，可以避免使用通配符类型：
public static <T> boolean hasNulls(Pair<T> p)

//但，带有通配符的版本可读性更强。
```

### 通配符捕获

```Java
//编写一个交换一个pair元素的方法：
public static void swap(Pair<?> p)
//通配符不是类型变量，因此不能在编写代码中使用"?"作为一种类型。

? t = p.getFirst();//ERROR
p.setFirst(p.getSecond());
p.setSecond(t);

//在交换时必须要保存第一个元素。辅助方法swapHelper
public static <T> void swapHelper(Pair<T> p) {
	T t = p.getFirst();
	p.setFirst(p.getSecond());
	p.setSecond(t);
}
//注意swapHelper是一个泛型方法。而swap不是，它具有固定的Pair<?>类型的参数

public static void swap(Pair<?> p) { swapHelper(p); }
//在这种情况下，swapHelper方法的参数T捕获通配符。它不知道时哪种类型的通配符，但是，这是一个明确的类型，并且<T>swapHelper的定义只有在T指出类型时才有明确的含义

//也可以用没有通配符的泛型方法
<T> void swap(Pair<T> p)

public static void maxminBonus(Manager[] a, Pair<? super Manager> result) {
	minmaxBonus(a, result);
	PairAlg.swap(result);//OK--swapHelper captures wildcard type
}
//通配符捕获机制是不可避免的。
```

+ 通配符捕获只有在有许多限制的情况下才是合法的。编译器必须能够确信通配符表达的是单个，确定的类型

```Java
package pair3;

public class PairTest3{
	public static void main(String[] args) {
		Manager ceo = new Manager("Gus Greedy", 800000, 2003, 12, 15);
		Manager cfo = new Manager("Sid Sneaky", 600000, 2003, 12, 15);
		Pair<Manager> buddies = new Pair<>(ceo, cfo);
		printBuddies(buddies);

		ceo.setBonus(1000000);
		cfo.setBonus(500000);
		Manager[] managers = { ceo, cfo};

		Pair<Employee> result = new Pair<>();
		minmaxBonus(managers, result);
		System.out.println("first:" + result.getFirst().getName() + ", second:" + result.getSecond().getName());
	}

	public static void printBuddies(Pair<? extends Employee> p) {
		Employee first = p.getFirst();
		Employee second = p.getSecond();
		System.out.println(first.getName() + " and " + second.getName() + " are buddies.");
	}

	public static void minmaxBonus(Manager[] a, Pair<? super Manager> result) {
		if(a == null || a.length == 0) return;
		Manager min = a[0];
		Manager max = a[0];
		for(int i = 1; i < a.length; i++) {
			if(min.getBonus() > a[i].getBonus()) min = a[i];
			if(max.getBonus() < a[i].getBonus()) max = a[i];
		}
		result.setFirst(min);
		result.setSecond(max);
	}

	public static void maxminBonus(Manager[] a, Pair<? super Manager> result) {
		minmaxBonus(a, result);
		PairAlg.swapHelper(result); // OK--swapHelper captures wildcard type
	}
}

class PairAlg{
	public static boolean hasNulls(Pair<?> p) {
		return p.getFirst() == null || p.getSecond() == null;
	}

	public static void swap(Pair<?> p) { swapHelper(p); }

	public static <T> void swapHelper(Pair<T> p) {
		T t = p.getFirst();
		p.setFirst(p.getSecond());
		p.setSecond(t);
	}
}
```

### 反射和泛型



