---
title: 第五章 继承
date: 2017-01-23 15:05
tags: Core Java Volume I
---

# 继承（is-a）

## 类

superclass超类 -> subclass子类
base class基类 -> derived class派生类
parent class夫类 -> child class孩子类

> super和this引用不是一个类似的概念，因为super不是一个对象的引用，不能将super赋给另一个对象变量，它只是一个指示编译器调用超类的方法的特殊关键字。

+ 关键字this两个用途：
  1. 引用隐式参数
  2. 调用该类其他的构造器
+ 关键字super两个用途：
   1. 调用的超类的方法
      2. 调用超类的构造器

+ 调用构造器的时候，两个关键字使用方式类似。调用构造器的语句只能作为另一个构造器的第一条语句出现。构造器的参数即可以传递给本类的（this）的其他构造器,也可以传递给超类的（super）的构造器。

+ 一个对象变量可以指代多种实际类型的现象被称为多态(polymorphism)。在运行时能够自动地选择调用哪个方法的现象称为动态绑定(dynamic binding)。
  (在Java中，不需要将方法声明为虚拟方法，动态绑定是默认的处理方式。如果不希望让一个方法具有虚拟特征，可以将它标记为final)

### 继承层次

+ 由一个公共超类派生出来的所有类的集合被称为继承层次。

+ 在继承层次中，从某个特定的类到其祖先的路径被称为该类的继承链。

+ 提醒一下，如果调用super.f(param),编译器将对隐式参数超类的方法表进行搜索。
  > 在覆盖一个方法时，子类方法不能低于超类方法的可见性。

### 阻止进程:final和方法

+ 不允许扩展的类称为final类。

+ 类中的特定方法也可以被声明为final,这样做子类就不能覆盖这个方法(final类中的所有方法自动地成为final方法，而其中的域不会成为final域)

+ 声明final主要目的：确保它们不会在子类中改变语义。

  > Calendar类中的getTime和setTime方法都声明为final，这表明Calendar类的设计者负责Date类与日历状态之间的转换，而不允许子类处理这些问题。同样地String类也是final类，这意味着不允许任何人定义String的子类。换言之，如果有一个String的引用，它引用的一定是一个String对象，而不可能是其他类的对象

### 强制类型转换

+ 养成良好的程序设计习惯：在进行类型转换之前，先查看一下是否能够成功地转换。

```java
if(staff[1] instanceof Manager) {
	boss = (Manager) staff[1];
}
```

1. 只能在继承层次进行类型转换。
2. 在将超类转换成子类之前，应该使用instanceof进行检查。
   + 一般情况下少用类型转换和instanceof运算符

### 抽象类

+ 扩展抽象类可以有两个选择。
  1. 在子类中定义部分抽象方法或抽象方法也不定义，这样就必须将子类也标记为抽象。
  2. 定义全部的抽象方法。
+ 抽象类不能被实例化，但是可以创建一个具体子类的对象。(可以定义一个抽象类的对象变量，但它只能引用一个非抽象子类的对象)

```Java
Person p = new Student("Vince Vu", "Economics");
p.getDescription();
//p时一个抽象类Person的变量，Person引用了一个非抽象子类Student的实例。
//由于不能构造抽象类Person的对象，所以变量p永远不会引用Person对象。而是引用诸如Employee或Student这样的具体子类对象,而这些对象中都定义了getDescription()
```

### 访问修饰符

1. 仅对本类可见 - private
2. 对所有类可见 - public
3. 对本包和所有子类可见 - protected(谨慎使用) - 例子：Object类中的clone方法。
4. 对本包可见 - 默认(很遗憾)，不需要修饰符

## object

+ 在Java中，只有基本类型不是对象，例如数值，字符和布尔类型都不是对象。所有的数组类型，不管是对象数组还是基本类型的数组都扩展于Object类。

### equals

+ 经常需要检测两个对象状态的相等性，如果两个对象的状态相等就认为这两个对象是相等的。

```Java
class Employee {
	public boolean equals(Object otherObject) {
		//a quick test to see if the objects are identical
		if(this == otherObject) return false;

		//must return false if the explicit parameter is null
		if(otherObject == null) return false;

		//if the classes don't match, they can't be equal
		if(getClass() != otherObject;) return false;
		//getClass方法将返回一个对象所属的类。

		//now we know otherObject is a non-null Employee
		Employee other = (Employee)otherObject;

		//test whether the fields have identical values
		return name.equals(name, other.name) 
			&& salary == other.salary 
			&& hireDay.equals(hireDay, other.hireDay);
		//防备name或者hireDay可能为null的情况 - Objects.equals(a, b);
	}
}

//如果超类中的域相等，就需要比较子类中的实例域。
class Manager extends Employee {
	public boolean equals(Object otherObject) {

		//super.equals checked that this and otherObject belong to the same class
		if(!super.equals(otherObject)) return false;
		Manager other = (Manager)otherObject;
		return bonus == other.bonus;
	}
}
```

### 相等测试与继承

+ Java语言规范要求equals方法具有下面的特性：
   1. 自反性： 对于任何非空引用x，x.equals(x)应该返回true
   2. 对称性： 对于任何引用x和y，当且仅当y.equals(x)返回true，x.equals(y)也应该返回true
   3. 传递性： 对于任何引用x, y和z,如果x.equals(y)返回true，y.equals(z)返回true，x.equals(z)也应该返回true
   4. 一致性： 如果x和y引用的对象没有发生变化，反复调用x.equals(y)应该返回同样的结果
   5. 对于任意非空引用x, x.equals(null)应该返回false
+ 如果子类能够拥有自己的相等概念，则对称性需求将强制采用getClass进行检测。

+ 如果由超类决定相等的概念，那么就可以使用instanceof进行检测，这样可以在不同子类的对象之间进行相等的比较。

+ 下面编写一个完美的equals方法的建议：
  1. 显示参数命名为otherObject，稍后需要将它转换成另一个叫做other的变量。
  2. 检测this与otherObject是否引用同一个对象：

       ```Java
         if(this == otherObject) return true;
       ```

  3. 检测otherObject是否为null，如果为null，返回false。(必要)

       ```Java
         if(otherObject == null) return false;
       ```

  4. 比较thisObject是否为null，如果为null，返回false。这项检测是很有必要的。

       ```Java
       if(getClass != otherObject.getClass()) return false;
       ```
       
       + 如果所有的子类都拥有统一的语义，就使用instanceof检测：

       ```Java
       if(!(otherObject instanceof ClassName)) return false;
       ```

  5. 将otherObject转换为相应的类类型变量：

       ```Java
       ClassName other = (ClassName) otherObject;
       ```

  6. 现在开始对所有需要比较的域进行比较了使用 `==` 比较基本类型域，使用equals比较对象域。如果所有的域都匹配，就返回true；否则返回false。

       ```Java
       return field1 == other.field1 && Objects.equals(field2, other.field2) && ...;
       ```

       + 如果在子类中重新定义equals，就要在其中包含调用super.equals(other)。
       + 对于数组类型的域，可以实现静态的Arrays.equals方法检测相应的数组元素是否相等。

```Java
//下面实现equals方法的一种常见的错误
public class Employee {
	public boolean equals(Employee other) {
		return Object.equals(name, other.name) 
			&& salary == other.salary 
			&& Object.equals(hireDay, other.hireDay)
	}
	...
}
//这个方法声明的显示参数类型是Employee。其结果并没有覆盖Object类的equals方法，而是定义了一个完全无关的方法。
//为了避免发生类型错误，可以使用@Override对覆盖超类的方法进行标记：
@Override public boolean equals (Object other)
//如果出现了错误，并且正在定义一个新方法，编译器就会给出错误报告。例如，假设将下面的声明添加到Employee类中：
@Override public boolean equals(Employee other)
//就会看到一个错误报告，这是因为这个方法并没有覆盖超类Object中的任何方法。
```

```Java
API java.util.Arrays 1.2
static Boolean equals(type[] a, type[] b) 
//如果两个数组长度相同，并且在对应的位置上位置上数据元素也均相同，将返回true。数组的元素类型可以是Object, int, long, short, char, byte, boolean, float或double.

API java.util.Objects 7
static boolean equals(Object a, Object b)
//如果a和b都为null，返回true；如果只有其中之一为null，则返回false；否则返回a.equals(b).
```

### hashCode方法

+ 散列码（hash code) 是由对象导出的一个整数值。散列码是没有规律的。如果x和y是两个不同的对象，x.hashCode()与y.hashCode()基本上不会相同。

```Java
String类使用下列算法计算散列码：
int hash = 0;
for(int i = 0; i < length(); i++)
	hash = 31 * hash + charAt(i);
```

+ 由于hashCode方法定义在Object类中，因此每个对象都有一个默认的散列码,其值为对象的存储地址。

```Java
String s = "OK";
StringBilder sb = new StringBuilder(s);
System.out.println(s.hashCode() + " " + sb.hashCode());
String t = new String("OK");
StringBuilder tb = new StringBuilder(t);
System.out.println(t.hashCode() + " " + tb.hashCode());
//字符串s和t拥有相同的散列码，这是因为字符串的散列码是由内容导出的。
//而字符串缓冲sb与tb却有着不同的散列码，这是因为在StringBuffer类中没有定义hashCode方法，它的散列码是由Object类的默认hashCode方法导出的对象存储地址。
```

+ 如果重新定义equals方法，就必须重新定义hashCode方法，以便用户可以将对象插入到散列表中。

+ hashCode方法应该返回一个整型数值（也可以是负数），并合理地组合实例域的散列码，以便能够让各个不同的对象产生的散列码更加均匀。

  ```Java
  //Employee类的hashCode方法
  class Employee {
    public int hashCode() {
      return 7 * name.hashCode()
        + 11 * new Double(salary).hashCode()
        + 13 * hireDay.hashCode();
    }
  }
  ```

+ 在Java7中还可以做两个该进。首先，最好使用null安全的方法`Objects.hashCode`。如果其参数为null，这个方法会返回0，否则返回对参数调用hashCode的结果。

  ```Java
  public int hashCode() {
    return 7 * Objects.hashCode(name)
      + 11 * new Double(salary).hashCode()
      + 13 * Object.hashCode(hireDay);
  }
  ```

+ 还有更好的做法，需要组合多个散劣值时，可以调用`Objects.hash`并提供多个参数。这个方法会对各个参数调用`Objects.hashCode`,并组合这些散列值。

  ```Java
  public int hashCode() {
    return Objects.hash(name, salary, hireDay);
  }
  ```

+ Equals与hashCode的定义必须一致：如果`x.equals(y)`返回true，那么`x.hashCode()`就必须与`y.hashCode()`具有相同的值。（例如：如果用定义的`Employee.equals`比较雇员的ID，那么hashCode方法就需要散列ID，而不是雇员的姓名或存储地址）

+ 如果存在数组类型的域，那么可以使用静态的`Arrays.hashCode`方法计算一个散列码，这个散列码由数组元素的散列码组成。

```Java
API java.lang.Object 1.0
  int hashCode()
  //返回对象的散列码。散列码可以是任意的整数，包括正数或负数。两个相等的对象要求返回相等的散列码。
  
  java.lang.Object 7
  int hash(object... objects)
  //返回一个散列码，由提供的所有对象的散列码组合而得到。
  static int hashCode(Object a)
  //如果a为null返回0，否则返回a.hashCode().
  
  java.util.Arrays 1.2
  static int hashCode(type[] a) 5.0
  //计算数组a的散列码。组合这个数组的元素类型可以是object, int, long, short, char, byte, boolean, float或double.
```

### toString方法

+ `toString`方法用于返回表示对象值的字符串。
+ 绝大多数(但不是全部)的`toString`方法都遵循这样的格式：类的名字，随后是一对方括号括起来的域值。

```Java
public String toString() {
  //return "Employee[name=" + name
  //	+ ",salary=" + salary
  //  	+ ",hireDay=" + hireDay
  // 	+ "]";
  return getClass().getName()
    + "[name=" + name
    + ",salary=" + salary
    + ",hireDay=" + hireDay
    + "]";
  //getClass().getName()获得类名的字符串。
}
```

+ 子类定义自己的`toStirng`方法，并将子类域的描述添加进去。如果超类使用了`getClass().getName()`，那么子类只要调用`super.toString()`就可以了。

```Java
Class Manager extends Employee {
  ...
    public String toString() {
      return super.toString()
      	+ "[bonus=" + bonus
        + "]";
    }
}
```

+ 只要对象与一个字符串通过操作符`+`连接起来，Java编译就会自动地调用`toString`方法，以便获得这个对象的字符串描述。
  + 在调用x.toString()的地方可以用`"" + x`替代，这条语句将一个空字符与x的的字符串表示连接。这里的x就是`x.toString()`。与`toString`不同的是，如果x是基本类型，这条语句照样能够执行。

  + 如果`x`是任意一个对象，并调用

    ```Java
    System.out.println(x);
    ```

    `println`方法就会直接地调用`x.toString()`，并打印输出得到的字符串。

  + Object类定义了`toString`方法，用来打印输出对象所属的类名和散列码。如，调用

    ```Java
    System.out.println(System.out);
    ```

    将输出下列内容：java.io.printStream@2f6684

    之所以得到这样的结果是因为`PrintStream`类的设计者没有覆盖`toString`方法。

  + 数组类型继承了Object类的`toString`方法，数组类型按照旧的格式打印。

    ```Java
    int[] luckyNumbers = {2, 3, 4, 7, 11, 13};
    String s = "" + luckyNumbers;
    //生成字符串“[I@1a46e30” (前缀"[I"表明是一个整形数组)。修正的方式是调用静态方法Arrays.toString
    String s = Arrays.toString(luckyNumbers);
    //将生成字符串“[2, 3, 4, 7, 11, 13]”
    //要想打印多维数组则需要调用Arrays.deepToString方法
    ```

+ `toString`方法是一种非常有用的调试工具。在标准类库中，许多类都定义类`toString`方法，以便用户能够获得一些有关对象状态的必要信息。

  ```Java
  System.out.println("Current position = " + position);
  Logger.global.info("Current position = " + position);//更好的解决方法。
  ```

+ 强烈建议为自定义的每一个类增加`toString`方法。这样做不仅自己受益，而且所有使用这个类的程序员也会从这个日志记录支持中受益匪浅。

## 泛型数组列表

+ ArrayList,使用起来有点像数组，但在添加或删除元素时，具有自动调节数组容量的功能，而不需要为此编写任何代码。

+ ArrayList是一个采用类型参数（type parameter）的泛型类（generic class）。为了指定数组列表保存的元素对象类型，需要用一个尖括号将类名括起来加在后面。

  ```Java
  //下面声明和构造一个保存Employee对象的数组列表
  ArrayList<Employee> staff = new ArrayList<Employee>();
  //Java7中可以省略右边的类型参数。
  ArrayList<Employee> staff = new Employee<>();
  //这种被称为“菱形”语法，因为尖括号<>就像一个菱形。
  //可以结合new操作符使用菱形语法。编译器会检查新值是什么。如果赋值给一个变量，然后将这个类型放在<>中。在这个例子中，new ArrayList<>()将赋至一个类型为ArrayList<Employee>的变量，所以泛型类型为Employee.
  staff.add(new Employee("Harry Hacker",...));
  staff.add(new Employee("Tony Tester",...));
  ```

+ 数组列表管理着对象引用的一个内部数组。***如果调用add且内部数组已经满了，数组列表就将自动地创建一个更大的数组，并将所有的对象从较小的数组中拷贝到较大的数组中。***

+ 如果已经清楚或能够估计出数组可能存储的元素数量，就可以在填充数组之前调用`ensureCapacity`方法。

  ```Java
  staff.ensureCapacity(100);
  ```

+ 还可以把初始容量传递给ArrayList构造器：

  ```Java
  ArrayList<Employee> staff = new ArrayList<>(100);
  //分配数组列表 new ArrayList<>(100) Capacity is 100
  //分配数组 new Employee[100] size is 100
  //数组列表的容量与数组的大小有一个非常重要的区别。如果为数组分配100个元素的存储空间，数组就有100个空位置可以使用。而容量为100个元素的数组列表只是拥有保存100个元素的潜力（实际上重新分配空间的话，将会超过100），但是在最初，甚至完成初始化构造之后，数组列表根本就不含有任何元素。
  staff.size();//size方法将返回数组列表中包含的实际元素数目。等价与数组a的a.length.
  ```

+ 一旦能够确认数组列表的大小不再发生变化，就可以调用trimToSize方法。这个方法将存储区域的大小调整为当前元素数量所需要的存储空间数目。垃圾回收器回收多余的存储空间。（一旦整理了数组列表的大小，添加新元素就需要花时间再次移动存储块，所以应该在确认不会添加任何元素时，再调用timeToSize.）

  ```Java
  java.util.ArrayList<T> 1.2
    ArrayList<T>()
    //构造一个空数组列表
    ArrayList<T>(int initialCapacity)
    //用指定容量构造一个空数组列表 （参数：initialCapacity 数组列表的最初容量）
    boolean add(T obj)//在数组列表的尾端添加一个元素，永远返回true（参数：obj 添加的元素）
    int size()
    //返回存储在数组列表中的当前元素数量。（这个值小于或等于数组列表的容量。）
    void ensureCapacity(int capacity)
    //确保数组列表在不重新分配存储空间的情况下就能够保存给定数量的元素。（参数：capatity 需要的存储容量）
    void trimToSize()
    //将数组列表的存储容量消减到当前尺寸。
  ```

#### 访问数组列表的元素

+ 使用add方法为数组添加新元素，而不要使用set方法，set方法只能替换数组中已经存在的元素内容。
+ 对于数组实施插入和删除元素的操作效率比较低。对于小型数组来说，这点不必担心。但如果数组存储的元素数比较多，又经常需要在中间位置插入，删除元素，就应该考虑使用链表了。

```Java
//可以使用”for each“循环遍历数组列表
for(Employee e : staff)
  do something with e
//和for循环效果一样。
    
java.util.ArrayList<T> 1.2
    void set(int index, T obj)
    //设置数组列表指定位置的元素值，这个操作将覆盖这个位置的原有内容。（参数：index 位置（必须介于0~size()-1 之间） obj  新的值）
    T get(int index)
    //获得指定位置的元素值。（参数index 获得的元素位置（必须介于0~size()-1 之间））
    void add(int index, T obj)
    //向后移动元素，以便插入元素。（参数：index 插入位置（必须介于0~size()-1 之间） obj 新元素）
    T remove(int index)
    //删除一个元素，并将后面的元素向前移动。被删除的元素由返回值返回。（参数：index  被删除的元素位置（必须介于0~size()-1 之间））
```

#### 类型化与原始数组列表的兼容性

+ 一旦确保不会造成严重的后果，可以用@SuppressWarnings("unchecked")标注来标记这个变量能够接受类型转换

  ```Java
  @SuppressWarnings("unchecked") ArrayList<Employee> result = (ArrayList<Employee>) employeeDB.find(query);
  ```

## 对象包装器与自动装箱

+ 有时候需要将int这样的基本类型转换为对象。所有的基本类型都有一个与之对应的类，这些类称为包装器。(Integer,Long,Float,Double,Short,Byte,Character,Void和Boolean（前6个派生于公共的超类Number）)

+ 对象包装器类是不可变的，即一旦构造类包装器，就不允许更改包装在其中的值。同时，对象包装类还是final，因此不能定义它们的子类。

+ 定义一个整型数组列表。而尖括号中的类型参数不允许是基本类型。

  ```Java
  ArrayList<Integer> list = new ArrayList<>();
  ```

+ 由于每个值分别包装在对象中，所以`ArrayList<Integer>`的效率远远低于`int[]`数组。因此用它构造小型集合，其原因是此时程序员操作的方便性要比执行效率更重要。

```Java
//Java SE 5.0的另一个改进便于添加或者获得数组元素
list.add(3);//list.add(Integer.valueOf(3))//自动装箱（自动打包）
//当将一个Integer.对象赋值给一个int值时，将会自动拆箱
int n = list.get(i);//int n = list.get(i).intValue();

Integer n = 3;
n++;
//编译器将自动地插入一条对象拆箱的指令，然后进行自增计算，最后再将结果装箱。

Integer a = 1000;
Integer b = 1000;
if(a == b)...
//检测的是对象是否指向同一个存储区域，Java实现有可能让它成立。如果将经常出现的值包装到同一个对象中，这种比较就有可能成立。解决这个问题的办法是在两个包装器对象比较时调用equals方法。
```

+ 自动装箱规范要求boolean ,byte ,char <=127, 介于 -128~127之间的short和int被包装到固定的对象中。

+ 最后强调一下，装箱和拆箱是编译器认可的，而不是虚拟机。编译器在生成类的字节码时，插入必要的方法调用。虚拟器只是执行这些字节码。

+ 使用数值对象包装器还有另一个好处。可以将基本方法放置在包装器中。

  ```Java
  //如：将字符串装换成整型
  int x = Integer.parseInt(s);
  //这里与Integer对象没有任何关系，parseInt是一个静态方法。但Integer是放置这个方法的好地方。
  ```

```Java
//包装器类不可以用来实现修改数值参数。
//Java是值传递。
public static void triple(int x) {//won't work
  x = 3 * x;
}
public static void triple(Integer x) {//won't work
  ...
}
//Integer对象是不可变的：包含在包装器中的内容不会改变。

//编写一个修改数值参数值的方法，就需要使用在org.omg.CORBA包中定义的持有者（holder)类型，包括IntHolder,BooleanHolder等。每个持有者类型都包含一个公有(!)域值，通过它可以访问存储在其中的值。
public static void tripe(IntHolder x) {
  x.value = 3 * x.value;
}
```

```Java
API java.lang.Integer 1.0
  int intValue()
  //以int的形式返回Integer对象的值（在Number类中覆盖了intValue方法）
  static String toString(int i)
  //以一个新String toString（int i, int radix)
  static int parseInt(String s)
  //返回字符串s表示的整型数值，给定字符串表示的是十进制的整数
  static int parseInt(String s, int radix)
  //返回字符串s表示的整型数值，是radix参数进制的整数
  static Integer valueOf(String s)
  //返回用s表示的整型数值进行初始化后的一个新Integer对象，给定字符串表示的是十进制的整数
  static Integer valueOf(String s, int radix)
  
  java.text.NumberFormat 1.1
  Number parse(String s)
  //返回数字值，假设给定的String表示类一个数值
```

## 参数数量可变的方法

+ 在Java SE 5.0 以前的版本中，每个Java方法都有固定数量的参数。现在的版本提供了可以用可变的参数数量调用的方法（有时称为"变参"方法）

```Java
System.out.printf("%d", n);
System.out.printf("%d %s", n, "widgets");

//调用的都是同一个方法
public class PrintStream {
	public PrintStream printf(String fmt, Object... args) {
		return format(fmt, args);
	}
}
//这里的省略号... 是Java代码的一部分，它表明这个方法可以接受任意数量的对象(除fmt参数之外)
//prinf方法接受两个参数，一个是格式化字符串，另一个是Object[]数组，其中保存着所有的参数(如果调用者提供的是整型数组或者其他基本类型的值，自动装箱功能将把它们转换成对象)。
//现在将扫描fmt字符串，并将第i个格式说明符与args[i]的值匹配起来。
//对于printf的实现者来说，Object... 参数类型与Object[]完全一样。
//编译器需要对printf的每次调用进行转换,以便将参数绑定到数组上，并在必要的时候进行自动装箱：
System.out.printf("%d %s", new Object[] { new Integer(n), "widgets"});

public static double max(double... values) {
	double largest = Double.MIN_VALUE;
	for(double v : values) if(v > largest) largest = v;
	return largest;
}
double m = max(3.1, 40.4, -5);
//编译器将new double[]{3.1, 40.4, -5}传递给max方法。

//允许将一个数组传递给可变参数方法的最后一个参数。
System.out.printf("%d %s", new Object[] { new Integer(1), "widgets"});

//因此将已经存在且最后一个参数是数组的方法重新定义为可变参数的方法，而不会破坏任何已经存在的代码。
//MessageFormat.format在Java SE 5.0就采用了这种方式。甚至可以将main方法声明下列形式：
public static void main(String... args)
```

## 枚举类

```Java
public enum Size { SMALL, MEDIUM, LARGE, EXTRA_LARGE};
//这个声明定义的类型是一个类，它刚好有4个实例，在此尽量不要构造新对象。
//因此在比较两个枚举类型的值时，永远不需要调用equals，而直接使用"=="就可以了。

//需要的话可以在枚举类型中添加一些构造器，方法和域。当然，构造器只是在构造枚举常量的时候被调用。
public enum Size {
	SMALL("S"), MEDIUM("M"), LARGE("L"), EXTRA_LARGE("XL");
	private String abbreviation;
	private Size(String abbreviation) { this.abbreviation = abbreviation;}
	public String getAbbreviation() { return abbreviation;}
}
```

+ 所有的枚举类型都是Enum类的子类。它们继承了这个类的许多方法。其中最有用的一个是toString，这个方法能够返回枚举常量名。

  ```Java
  Size.SMALL.toString();//返回字符串"SMALL"
  //toString的逆方法是静态方法valueOf
  Size s = Enum.valueOf(Size.class, "SMALL");//将s设置成Size.SMALL

  //每个枚举类型都有一个静态的values方法，它将返回一个包含全部枚举值的数组。
  Size[] values = Size.values();//返回包含元素Size.SMALL,Size.MEDIUM,Size.LARGE和Size.EXTRA_LARGE的数组。

  //ordinal方法返回enum声明中枚举常量的位置，位置从0开始计数。
  Size.MEDIUM.ordinal();//返回1
  ```
  
+ 如同class类一样，鉴于简化的考虑，Enum类省略了一个类型参数。例如：应该将枚举类型Size扩转为Enum<Size>.类型参数在compareTo方法中使用。

```Java
package enums;
import java.util.*;

public class EnumTest {
	Scanner in = new Scanner(System.in);
	System.out.print("Enter a size: (SMALL, MEDIUM, LARGE, EXTRA_LARGE)");
	String input = in.next().toUpperCase();
	Size size = Enum.valueOf(Size.class, input);
	System.out.println("size=" + size);
	System.out.println("abbreviation=" + size.getAbbreviation());
	if(size == Size.EXTRA_LARGE)
		System.out.print("Good job--you paid attention to the _.")
}
enum Size {
	SMALL("S"), MEDIUM("M"), LARGE("L"), EXTRA_LARGE("XL");
	private String abbreviation;
	private Size(String abbreviation) { this.abbreviation = abbreviation;}
	public String getAbbreviation() { return abbreviation;}
}
```

```Java
API java.lang.Enum<E> 5.0
	static Enum valueOf(Class enumClass, String name)
	//返回指定名字，给定类的枚举常量
	String toString()
	//返回枚举常量名。
	int ordinal()
	//返回枚举常量在enum声明中的位置，位置从0开始计数。
	int compareTo(E other)
	//如果枚举类型出现在other之前，则返回一个负值;如果this == other，则返回0;否则，返回正值。枚举常量的出现次序在enum声明中给出。
```

## 反射

+ 能够分析类能力的程序称为反射(reflective).反射机制可以用来：
  + 在运行中分析类的能力。
  + 在运行中查看对象。如，编写一个toString方法供所有类使用。
  + 实现通用的数组操作代码。
  + 利用Method对象，这个对象很想C++ 中的函数指针。

  
**复杂**

### Class类

## 继承设计的技巧

1. 将公共操作和域放在超类。
2. 不要使用受保护的域。(protected机制不能带来更好的保护)
   + 子类集合是无限制的，任何一个人都能够由某个类派生一个子类，并编写代码以直接访问protected的实力域，从而破坏封装性。
   + 在Java程序设计语言中，在同一个包中的所有类都可以访问protected域，而不管它是否是为这个类的子类。
   + 不过protected方法对于指示那些不提供一般用途而在子类中重新定于的方法很有用。
3. 使用继承实现"is-a"关系。(确认是否为is-a的关系)
4. 除非所有继承的方法都有意义，否则不要使用继承。
5. 在覆盖方法时，不要改变预期的行为。
   + 置换原则不仅应用于语法，而且也可以应用于行为。覆盖方法的时候，不应该毫无原由地改变行为的内涵。
   + 覆盖方法不要偏离最初的设计想法。
6. 使用多态，而非类型信息。

   ```Java
   if(x is of type1)
   	action1(x);
   else if(x if of type2)
   	action2(x);
   //考虑多态性。
   //如果action1和action2是相同的概念，就应该为这个概念定义一个方法，并将其放置在两个类的超类或接口中，然后就可以调用x.action();以便使用多态性提供的动态分派机制执行相应的动作。
   ```
   
   + 使用多态方法或接口编写的代码比使用对多种类型进行检测的代码更加易于维护和扩展。
7. 不要过多的使用反射。
   + 反射机制使得人们可以通过在运行时查看域和方法，让人们编写出更具有通用性的程序。这种功能对于编写系统程序来说极其实用，但通常不适于编写应用程序。
   + 反射是很脆弱的，即编译器很难帮助人们发现程序中的错误，因此只有在运行时才发现错误并导致异常。

