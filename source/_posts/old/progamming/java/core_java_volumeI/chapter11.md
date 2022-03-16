---
title: 第十四章 异常·断言·日志和调试
date: 2017-01-18 17:13
tags: Core Java Volume I
---

# 异常·断言·日志和调试

## 处理错误

+ 由于出现错误而使得某些操作没有完成，程序应该：
	+ 返回到一种安全状态，并能够让用户执行一些其他的命令
	+ 允许用户保存所有操作的结果，并以适当的方式结束程序
+ 异常处理的任务就是将控制权从错误产出的地方转移给能够处理这种情况的错误处理器。哪些问题需要关注：
	+ 用户输入错误
	+ 设备错误
	+ 物理限制
	+ 代码错误
+ 在Java中，如果某个方法不能采用正常的途径完整它的任务，就可以通过另一个路径退出方法。抛出(throw)一个封装了错误信息的对象。
	+ 需要注意的是，这个方法会立即退出，并不返回任何值，
	+ 调用这个方法的代码也将无法继续执行，而是，异常处理机制开始搜索能够处理这种异常状况的异常处理器(exception handler)

### 异常分类

+ 在Java程序设计语言中，异常对象都是派生于Throwable类的一个实例。

+ 所有的异常都是由Throwable继承而来，下一层立即分解为两个分支：Error和Exception
+ Error类层次结构描述了Java运行时系统的内部错误和资源耗尽错误。应用程序不应该抛出这种类型的错误。通告给用户，并尽力使程序安全地终止。
+ Exception分为两个分支，一个分支派生于RuntimeException；另一个分支包含其他异常。划分两个分支的原则：由程序错误导致的异常属于RuntimeException;而程序本身没有问题，但像I/O错误这类问题导致的异常属于其他异常。
	+ 派生于**RuntimeException**的异常
		+ 错误的类型转换
		+ 数组访问越界
		+ 访问空指针
	+ 不是派生于RuntimeException的异常包括
		+ 试图在文件尾部后面读取数据
		+ 试图打开一个不存在的文件
		+ 试图根据给定的字符串查找Class对象，而这个字符串表示的类并不存在
+ **如果出现RuntimeException异常，那么就一定是你的问题**
	+ 应当通过检测数组下标是否越界来避免`ArrayIndexOutOfBoundsException`异常
	+ 应该通过在使用变量之前检测是否为空来杜绝`NullPointerException`异常的发生
+ 具有错误格式，取决于具体的环境，而不仅仅是程序代码。
+ Java语言规范将派生于Error类或RuntimeException类的所有异常称为未检查(unchecked)异常。所有其他的异常称为已检查(checked)异常。
+ RuntimeException这个名字让人混淆。实际上，我们现在讨论的所有错误都发生在运行时。

### 声明已检查异常

+ 什么时候需要在方法中用throws字句声明异常，声明异常必须使用throws子句声明。
	+ 调用一个抛出已检查异常的方法(FileInputStream)
	+ 程序运行过程中发现错误，并利用throw语句抛出一个已检查异常
	+ 程序出现错误(ArrayIndexOutOfBoundsException)
	+ Java虚拟机和运行时库出现的内部错误

+ 如果出现前两种情况之一，则必须告诉调用这个方法的程序员有可能抛出异常。因为任何一个抛出异常的方法都有可能是一个死亡陷阱。如果没有处理器捕获这个异常，当前执行的线程就会结束。
+ 一个方法必须声明所有可能抛出的已检查异常，而未检查异常要么不可控制(Error)，要么就应该避免发生(从RuntimeException继承的那些未检查异常。-ArrayIndexOutOfBoundsException)。如果没有声明所有已检查的异常，编译器就会给出一个错误信息。
	+ 除了声明异常之外，还可以捕获异常。这样会使异常不被抛到方法之外。
	+ 如果在子类中覆盖了超类的一个方法，子类方法中声明的已检查异常不能比超类中声明的异常更通用(也就是说，子类方法中可以抛出更特定的异常，或者根本不抛出任何异常)。
	+ 如果超类没有抛出任何已检查异常，子类也不能抛出任何已检查异常。
	+ 如果类中的一个方法声明将会抛出一个异常，而这个异常是某个特定类的实例时，则这个方法就有可能抛出一个这个类的异常，或者这个类的任意一个子类的异常。(IOException, FileNotFoundException)

### 如何抛出异常

```Java
String readData(Scanner in) throws EOFException {
	...
	while(...) {
		if(!in.hasNext()) {
			if(n < len) throw new EOFException();
			//EOFException e = new EOFException;
			//if(n < len) throw e;
		}
		...
	}
	return s;
}

// EOFException 类还有一个含有一个字符串型参数的构造器
String gripe = "Content-length: " + len ", Received: " + n;
throw new EOFException(gripe);
```

+ 一旦方法抛出了异常，这个方法就不可能返回到调用者。也就是说，不必为返回的默认值或错误代码担忧。
+ 在Java中，只能抛出Throwable子类的对象，而在C++中，却可以抛出任何类型的值。

### 创建异常类

+ 定义一个派生于Exception的类，或者派生于Exception子类的类。习惯上定义的类要给包含两个构造器吗，一个默认构造器，一个带有详细描述信息的构造器(超类的Throwable的toString方法将会打印出这些详细信息，这在调试中非常有用)。
	
	```Java
	class FileFormatException extends IOException {
		public FileFormatException() {}
		public FileFormatException(String gripe) {
			super(gripe);
		}
	}
	```

```Java
API java.lang.Throwable 1.0
	Throwable()
	//构造一个新的Throwable对象，这个对象没有详细的描述信息
	Throwable(String message)
	//构造一个新的Throwable对象，这个对象带有特定的详细描述信息。习惯上，所有派生的异常类都支持一个默认的构造器和一个带有详细描述信息的构造器。
	String getMessage()
	//获得Throwable对象的详细描述信息
```

## 捕获异常

	```Java
	try {
		code
		more code
		more code
	}catch(Exception e) {
		handler for this type
	}
	```

+ 如果在try语句块中的任何代码抛出了一个在catch子句中说明的异常类：
	+ 程序将跳过try语句块的其余代码。
	+ 程序将执行catch子句中的处理器代码。
+ 如果在try语句中的代码没有抛出任何异常，那么程序将跳过catch子句。
+ 如果方法中的任何代码抛出了一个在catch子句中没有声明的异常类型，那么这个方法就会立刻退出(希望调用者为这种类型的异常设计了catch子句)

	```Java
	public void read(String filename) {
		try {
			InputStream in = new FileInputStream(filename);
			int b;
			while((b = in.read()) != -1) {
				process input
			}
		}catch(IOException e) {
			exception.printStackTrace();
		}
	}

	//最好的选择是什么都不做，而是将异常传递给调用者。声明这个方法可能会抛出的异常
	public void read(String filename) throws IOException {
		InputStream in = new FileInputStream(filename);
		int b;
		while((b = in.read()) != -1) {
			process input
		}
	}
	//编译器严格地执行throws说明符。如果调用了一个抛出已检查异常的方法，就必须对它进行处理，或者将它继续进行传递。
	```

+ 应该捕获那些知道处理的异常，而将那些不知道怎么处理的异常继续进行传递。
+ 对于throws，将异常直接交给能够胜任的处理器进行处理要比压制对它的处理更好。
+ 如果编写一个覆盖超类的方法，而这个方法又没有抛出异常，那么这个方法就必须捕获方法代码中出现的每一个已检查异常。不允许在子类的throws说明符中出现超过超类方法所列出的异常类范围。

### 捕获多个异常

+ 在一个try语句块中可以捕获多个异常类型，并对不同类型的异常做出不同的处理。

	```Java
	try {
		code that might throw exceptions
	}catch(FileNotFoundException e) {
		emergency action for missing files
	}catch(UnknownHostException e) {
		emergency action for unknown hosts
	}catch(IOException e) {
		emergency action for all other I/O problems
	}
	```

+ 异常对象可能包含于异常本身有关的信息。要想获得对象的更多信息，可以试着使用`e.getMessage()`得到详细的错误信息(如果有的话)，或者使用`e.getClass().getName()`得到异常对象的实际类型。
+ 在Java SE 7中，同一个catch子句中可以捕获多个异常类型。

	```Java
	try {
		code that might throw exceptions
	}catch(FileNotFoundException | UnknownHostException e) {
		emergency action for missing files and unknown hosts
	}catch(IOException e) {
		emergency action for all other I/O problems
	}
	//只有当捕获的异常类型彼此之间不存在子类关系时才需要这个特性。
	//捕获多个异常时，异常变量隐含为final变量。不能在以下子句中为e赋不同的值：
	catch(FileNotFoundException | UnknownHostException { ... })
	```

+ 捕获多个异常不仅会让你的代码看起来更简单，还会更高效。生成的字节码只包含一个对应公共catch子句的代码块。

### 再次抛出异常与异常链

+ 在catch子句中可以抛出一个异常，这样做的目的是改变异常的类型。

	```Java
	//如果开发一个供其他程序员使用的子系统，那么，用于表示子系统故障的异常类型可能会产生多种解释。
	//ServletException就是这样的一个异常类型的例子。执行servlet的代码可能不想知道发生错误的细节原因，但希望明确知道servlet是否有问题。
	try {
		access the database
	}catch(SQLException e) {
		throw new ServletException("database error: " + e.getMessage());
	}
	//ServletException用带有异常信息文本的构造器来构造
	
	//更好的处理方法，将原始异常设置为新异常的“原因”
	try {
		access the database
	}catch(SQLException e) {
		Throwable se = new ServiceException("database error");
		se.initCause(e);
		throw se;
	}
	//当捕获到异常时，重新获得原始异常：
	Throwable e = se.getCause();
	//强烈建议使用这种包装技术。这样就可以使用户抛出子系统中的高级异常，而不丢失原始异常的细节。
	```

+ 如果在一个方法中发生了一个已检查异常，而不允许抛出它，那么包装技术就十分有用。我们可以捕获这个已检查异常，并将它包装成一个运行时异常。

	```Java
	//有时你可能只想记录一个异常，再将它重新抛出，而不做任何改变：
	try {
		access the database
	}catch(Exception e) {
		logger.log(lever, message, e);
		throw e;
	}
	```

+ 在Java SE 7之前，这种方法存在一个问题。假设代码存在以下方法中：

	```Java
	public void updateRecord() throws SQLException
	```

	+ Java编译器查看catch块中throw语句，然后查看e的类型，会指出这个方法可以抛出任何Exception而不只是SQLException。
	+ 现在问题改进，编译器会跟踪到e来自try块。假设这个try块仅有的已检查异常是SQLException实例，另外假设e在catch块中未改变，将外围方法声明为throws SQLException就是合法的。

### finally子句

+ 资源回收
	+ 一种解决方案，捕获并重新抛出所有的异常。但是，这种解决方案比较乏味，这是因为因为需要在两个地方清除所分配的资源。一个在正常的代码中；一个在异常代码中。
	+ 更好的解决方案就是finally子句

+ 如果使用Java编写数据库程序，就需要使用同样的技术关闭与数据库的连接。当发生异常时，恰当地关闭所有数据库的连接是非常重要的。
+ 不管是否有异常被捕获,finally子句的代码都被执行。
	
	```Java
	InputStream in = new FileInputStream(...);
	try {
		code that might throw exceptions
	}catch(IOException e) {
		show error message
	}finally {
		in.close();
	}
	```
	
+ 3种情况会执行finally子句：
	1. 代码没有抛出异常
	2. 抛出一个在catch子句中捕获的异常
		+ 如果catch子句没有抛出异常，程序将执行try语句块之后的第一条语句。
		+ 如果catch子句抛出了一个异常，异常将被抛回这个方法的调用者。
	3. 代码抛出了一个异常，但这个异常不是由catch子句捕获的。在这种情况下，程序将执行try语句块中的所有语句，直到有异常被抛出为止。此时，将跳过语句块中的剩余代码，然后执行finally子句的语句，并将异常抛给这个方法的调用者。

+ try语句可以只有finally子句，而没有catch子句。

	```Java
	InputStream in = ...;
	try {
		code that might throw exceptions
	}finally {
		in.close
	}
	//无论在try语句块中是否遇到异常，finally子句中的in.close()语句都会被执行。
	//当然，如果真的遇到一个异常，这个异常将会被重新抛出，并且必须由另一个catch子句捕获
	//事实上，我们认为在需要关闭资源时，用这种方式使用finally子句是一种不错的选择。
	```

+ 这里，强烈建议独立使用try/catch和try/finally语句块，这样可以提高代码的清晰度。

	```Java
	InputStream in = ...;
	try {
		try {
			code that might throw exceptions
		}finally {
			in.close();
		}
	}catch(IOException e) {
		show error message
	}
	//内层的try语句块只有一个职责，就是确保关闭输入流。
	//外层的try语句块也只有一个职责，就是确保报告出现的错误。
	//这种设计方式不仅清除，而且还具有一个功能，就是将会报告finally子句中出现的错误。
	```

+ 当finally子句包含return语句时，将会出现一个意想不到的结果。

	```Java
	public static int f(int n) {
		try {
			int r = n * n;
			return r;
		}finally {
			if(n == 2) return 0;
		}
	}
	//finally子句中的返回值会覆盖原始的返回值
	```

+ 有时候，finally子句也会带来麻烦。例如，清理资源的方法也有可能抛出异常。假设希望能够确保在流处理代码中遇到异常时将流关闭。
	+ 假设在try语句块中的代码中的代码抛出了一些非IOException的异常，这些异常只有这个方法的调用者才能够给予处理。执行finally语句块，并调用close方法。而close方法本身也有可能抛出IOException异常。当出现这种情况时，原始的异常将会丢失，转而抛出close方法的异常。
	+ 适当的处理，重新抛出原来的异常很繁琐。
	
	```Java
	InputStream in = ...;
	Exception ex = null;
	try {
		try {
			code that might throw exceptions
		}catch(Exception e) {
			ex = e
			throw e;
		}
	}finally {
		try {
			in.close();
		}catch(Exception e) {
			if(ex == null) throw e;
		}
	}
	```

### 带资源的try语句

+ 假设资源属于一个实现了`AutoCloseable`接口的类，Java SE 7为这种代码模式提供了一个很有用的快捷方式。

	```Java
	void close() throws Exception
	```

+ 另外，还有一个`Closeable`接口，这是`AutoCloseable`的子接口，也是包含一个close方法。不过这个方法声明为抛出一个IOException
+ 带资源的try语句(try-with-resources)的最简形式为：

	```Java
	try(Resource res = ...) {
		work with res
	}
	//try块退出时，自动调用res.close()。

	try(Scanner in = new Scanner(new FileInputStream("/usr/share/dict/words"))) {
		while(in.hasNext())
			System.out.println(in.next());
	}
	//这个块正常退出时，或者存在一个异常时，都与调用in.close()方法，就好像使用了finally快一样

	//还可以指定多个资源
	try(Scanner in = new Scanner(new FileInputStream("/usr/share/dict/words")), 
		PrintWriter out = new PrintWriter("out.txt")) {
			while(in.hasNext()) {
				out.println(in.next().toUpperCase());
			}
		}
	//不论这个块如何退出，in, out都会关闭。如果用常规方法手动编程，就需要两个嵌套的try/finally语句
	```

+ 如果try块抛出一个异常，而且close方法也抛出一个异常，这就会带来一个难题。带资源的语句块很好的处理了这种情况，原来的异常会重新抛出，而close方法抛出的异常会“被抑制”。
+ 这些异常将自动捕获，并由addSuppressed方法增加到原来的异常。如果对这些异常感兴趣，可以调用getSuppressed方法，它会得到close方法抛出并被抑制的异常列表。

+ 带资源的try语句自身也可以有catch子句和一个finally子句。这些子句会在关闭资源之后执行。不过在实际中，一个try语句中加入这么多内容可能不是一个好主意。

### 分析堆栈跟踪元素

+ 堆栈跟踪(stack trace)是一个方法调用过程的列表，它包含了程序执行过程中方法调用的特定位置。

	```Java
	//可以调用Throwable类的printStackTrace方法访问堆栈跟踪
	Throwable t = new Throwable();
	ByteArrayOutputStream out = new ByteArrayOutputStream();
	t.printStackTrace(out);
	String description = out.toString();

	//更灵活的方法，使用getStackTrace方法，它会得到StackTraceElement对象的一个数组，可以在你的程序中分析这个对象数组。
	Throwable t = new Throwable();
	StackTraceElement[] frames = t.getStackTrace();
	for(StackTraceElement frame : frames) 
		analyze frame

	//静态的Thread.getALLStackTrace方法，它可以产生所有线程的堆栈跟踪。
	Map<Thread, StackTraceElement[]> map = Thread.getAllStackTraces();
	for(Thread t : map.keySet()) {
		StackTraceElement[] frames = map.get(t);
		analyze frames
	}
	```

```Java
API java.lang.Throwable 1.0
	Throwable(Throwable cause) 1.4
	Throwable(String message, Throwable cause) 1.4
	//用给定的“原因”构造一个Throwable对象
	Throwable initCause(Throwable cause) 1.4
	//将这个对象设置为“原因”。如果这个对象已经设置为“原因”，则抛出一个异常。
	//返回this引用
	Throwable getCause() 1.4
	//获得设置为这个对象的“原因”的异常对象。如果没有设置“原因”，则返回null
	StackTraceElement[] getStackTrace() 1.4
	//获得构造这个对象时调用堆栈的跟踪。
	void addSuppressed(Throwable t) 7
	//为这个异常增加一个“抑制”异常。这出现在带资源的try语句中，其中t是close方法抛出的一个异常。
	Throwable[] getSuppressed() 7
	//得到这个异常的所有“抑制”异常，一般来说，这些是带资源的try语句中close方法抛出的异常。

	java.lang.Exception 1.0
	Exception(Throwable cause) 1.4
	Exception(String message, Throwable cause)
	//给定的“原因”构造一个RuntimeException对象

	java.lang.StackTraceElement 1.4
	String getFileName()
	//返回这个元素运行时对应的源文件名，如果这个信息不存在，则返回null
	int getLineNumber()
	//返回这个元素运行时对应的源文件行数。如果这个信息不存在，则返回-1
	String getClassName()
	//返回这个元素运行时对应的类的全名
	String getMethodName()
	//返回这个元素运行时对应的方法名。构造器名是<int>;静态初始化名是<clinit>。这里无法区分同名的重载方法
	boolean isNativeMethod()
	//如果这个元素运行时在一个本地方法中，则返回true
	String toString()
	//如果存在的话，返回一个包含类名，方法名，文件名和行数的格式化字符串。
```

## 使用异常机制的技巧

1. 异常处理不能代替简单的测试
	+ 与执行简单的测试相比，捕获异常所花费的时间大大超过了前者，因此使用的异常的基本规则是：只在异常情况下使用异常机制。

2. 不要过分地细化异常(例子：使用多个try-catch)
	+ 将整个任务包装在一个try语句块中，这样出现一个操作问题时，整个任务都可以取消。

	```Java
	try {
		for(i = 0; i < 100; i++) {
			n =s.pop();
			out.writeInt(n);
		}
	}catch(IOException e) {
		//problem writing to file
	}catch(EmptyStackException e) {
		//stack was empty
	}
	```

3. 利用异常层次结构
	+ 不要只抛出RuntimeException异常。应该寻找更加适当的子类和创建自己的异常类。
	+ 不要只捕获Thowable异常，否则就会使程序代码更难读，更难维护。
	+ 考虑已检查异常与未检查异常的区别。已检查异常本就很庞大，不要为逻辑错误抛出这些异常。
	+ 将一种异常转换成另一种更加适合的异常时不要犹豫。

4. 不要压制异常(在Java中,往往强烈的倾向于关闭异常)
5. 在检测错误的时候，“苛刻”要比放任更好。
	+ 在出错的地方抛出一个EmptyStackException异常要比在后面抛出一个NullPointerException异常更好。
6. 不要羞于传递异常(传递异常要比捕获这些异常更好)

	```Java
	public void readStuff(String filename) throws IOException {
		InputStream in = new FileInputStream(filename);
	}
	//让高层次的方法通知用户发生错误，或者放弃不成功的命令更加适宜。
	```

	+ 5, 6可以归纳为“早抛出，晚捕获”

## 使用断言

+ 一个具有自我保护能力的程序中，断言很常用。
+ 断言机制允许在测试期间向代码中插入一些检查语句。当代码发布时，这些插入的检测语句将会被自动地移走。
+ Java语言引入了关键字assert。这个关键字有两种形式：
	+ assert 条件;
	+ assert 条件 : 表达式;

+ 这两种形式都会条件进行检测，如果结果为false，则抛出一个AssertionError异常。在第二种形式中，表达式将被传入AssertionError构造器，并转换成一个信息字符串。

+ “表达式”部分的唯一目的是产生一个消息字符串。AssertionError对象并不存储表达式的值，因此，不可能在以后得到它。

	```Java
	//要想断言x是一个非负数值
	assert x >= 0;

	//或将x的实际值传递给AssertionError独享，从而可以在以后显示出来
	assert x >=0 : x;

	//c语言中的assert宏将断言中的条件转换成一个字符串。当断言失败，这个字符串将会被打印出来。
	//在Java中，条件并不会自动地成为错误报告中的一部分。
	assert x >= 0 : "x >= 0";
	```

### 启用和禁用断言

+ 在默认情况下，断言被禁用。可以在运行程序时用 `-enableassertions` 或 `-ea`选项启用它`java -enableassertions MyApp`

+ 在启用和禁用断言时不必重新编译程序。启用或禁用断言是类加载器(class loader)的功能。当断言被禁用时，类加载器将跳过断言代码，因此，不会降低程序运行的速度。
+ 也可以在某个类或某个包中使用断言

	```Java
	java -ea:MyClass -ea:com.mycompany.mylib... MyApp
	//将开启MyClass类以及在com.mycompany.mylib包和它的子包的所有类的断言。
	//选项-ea将开启默认包中的所有类的断言。

	//也可以用选项 -disableassertions或-da禁用某个特定类和包的断言：
	java -ea:... -da:MyClass MyApp
	```

+ 有些类不是由类加载器加载，而是直接由虚拟机加载。可以使用这些开关有选择地启用或禁用那些类中的断言。然而，启用和禁用所有断言的`-ea`和`-da`开关不能应用到那些没有类加载器的“系统类”上。对于这些系统类来说，需要使用`-enablesystemassertions/-esa`开关启用断言
+ 在程序中也可以控制类加载器的断言状态
	
### 使用断言完成参数检查

+ 在Java语言中，给出了3种处理系统错误的机制：
	+ 抛出一个异常
	+ 日志
	+ 使用断言
		+ 断言失败是致命的，不可恢复的错误。
		+ 断言检查只用于开发和测试阶段

+ 不应该使用断言向程序的其他部分通告发生了可恢复的错误，或者，不应该作为程序向用户通告问题的手段。断言只应该用于测试阶段确定程序内部的错误位置。

### 为文档假设使用断言

```Java
if(i % 3 == 0)
	...
else if(i % 3 ==1)
	...
else (i % 3 == 2)

//使用断言会更好一些
assert i > 0
if(i % 3 == 0)
	...
else if(i % 3 == 2)
	...
else {
	assert i% 3 ==2;
	...
}
```

+ 断言是一种测试和调试阶段所使用的战术性工具；而日志记录是一种在程序的整个生命周期都可以使用的策略性工具。

```Java
API java.lang.ClassLoader 1.0
	void setDefaultAssertionStatus(boolean b) 1.4
	//对于通过类加载器加载的所有类来说，如果没有显式地说明类或包的断言状态，就启用或禁用断言
	void setClassAssertionStatus(String className, boolean b) 1.4
	//对于给定的类和它的内部类，启用或禁用断言。
	void setPackageAssertionStatus(String packageName, boolean b) 1.4
	//对于给定包和其子包中的所有类，启用或禁用断言。
	void clearAssertionStatus() 1.4
	//移去所有类和包的显式断言状态设置，并禁用所有通过这个类加载器加载的类的断言。
```

## 记录日志

## 日志API

###基本日志

```Java
//日志系统管理着一个名为Logger.global的默认日志记录器，可以用System.out替换它
Logger.getGlobal().info("File->Open menu item selected");

//在默认情况下，这条记录会显示出如下所示的内容：
//May 10, 2013 10:12:15 PM LoggingImageViewer fileOpen
//INFO: File->Open menu item selected
//自动包含时间，调用的类名和方法名。

//在相应的地方(如：main开始)调用下面这句，将会取消所有的日志
Logger.getGlobal().setLevel(Level.OFF);
//在修正bug7184195之前，还需要调用下面这句，来激活全局日志记录器
Logger.getGlobal().setLevel(Level.INFO);
```

### 高级日志

+ 在一个专业的应用程序中，不要将所有的日志都记录到一个全局日志记录器中，而是可以自定义日志记录器。

	```Java
	//调用getLogger方法可以创建或检索记录器：
	private static final Logger myLogger = Logger.getLogger("com.mycompany.myapp");

	//与包名类似，日志记录器也具有层次结构
	//与包名相比，日志记录器的层次更强
	//一个包的名字与其父包的名字之间没有语义关系
	//但是日志记录器的父与子之间将共享某些属性。
	//如：对com.mycompany日志记录器设置了日志级别，它的子记录器也会继承这个级别
	```

+ 有以下7个日志记录器级别：
	+ SERVER
	+ WARNING
	+ INFO
	+ CONFIG
	+ FINE
	+ FINER
	+ FINEST

	```Java
	//在默认情况下，只记录前三个级别。也可以设置其他的级别:
	logger.serLevel(Level.FINE);
	//现在，FINE和更高级别的记录都可以记录下来
	//Level.ALL开启所有级别的记录
	//Level.OFF关闭所有级别的记录

	//对于所有级别有下面几种记录方法：
	logger.warning(message);
	logger.fine(message);
	//还可以用log方法指定级别：
	logger.log(Level.FINE, message);
	```

### 修改日志管理器配置

### 本地化

### 过滤器

### 格式化器

### 日志记录说明

```Java
API java.util.logging.Logger 1.4
	Logger getLogger(String loggerName)
	Logger gerLogger(String loggerName, String bundleName)
	//获得给定名字的日志记录器。如果这个日志记录器不存在，创建一个日志记录器
	//参数：loggerName 具有层次结构的日志记录器名。
	//		bundleName 用来查看本地消息的资源包名
	void severe(String message)
	void warning(String message)
	void info(String message)
	void config(String message)
	void fine(String message)
	void finer(String message)
	void finest(String message)
	//记录一个由方法名和给定消息指示级别的日志记录。
	void entering(String className, String methodName)
	void entering(String className, String methodName, Object param)
	void entering(String className, String methodName, Object[] param)
	void exiting(String className, String methodName)
	void exiting(String className, String methodName, Object result)
	//记录一个描述进入/退出方法的日志记录，其中应该包括给定参数和返回值
	void throwing(String className, String methodName, Throwable t)
	记录一个描述抛出给定异常对象的日志记录
	void log(Level level, String message)
	void log(Level level, String message, Object obj)
	void log(Level level, String message, Object[] objs)
	void log(Level level, String message, Throwable t)
	//记录一个给定级别和消息的日志记录，其中可以包括对象或者抛出对象。要想包括对象，消息中必须包含格式化占位符{0}, {1}等。
	void logp(Level level, String className, String methodName, String message)
	void logp(Level level, String className, String methodName, String message, Object obj)
	void logp(Level level, String className, String methodName, String message, Object[] objs)
	void logp(Level level, String className, String methodName, String message, Throwable t)
	//记录一个给定级别，准确的调用者信息和消息的日志记录，其中可以包括对象或可抛出对象
	void logrb(Level level, String className, String methodName, String bundleName, String message)
	void logrb(Level level, String className, String methodName, String bundleName, String message, Object obj)
	void logrb(Level level, String className, String methodName, String bundleName, String message, Object[] objs)
	void logrb(Level level, String className, String methodName, String bundleName, String message, Throwable t)
	//记录一个给定级别，准确的调用着信息，资源包名和消息的日志记录，其中可以包括对象或可抛出对象
	Level getLevel()
	void setLevel(Level l)
	//获得和设置这个日志记录器的级别
	Logger getParent()
	void setParent(Logger l)
	//获得和设置这个日志记录器的父日志记录器
	Handler[] getHandlers()
	//获得这个日志记录器的所有处理器
	void addHandler(Handler h)
	void removeHandler(Handler h)
	//增加或删除这个日志记录器中的一个处理器
	boolean getUseParentHandlers()
	void setUseParentHandlers(boolean b)
	//获得和设置“use parent handler”属性。如果这个属性是true，则日志记录器会将全部的日志记录器转发给他的父处理器
	Filter getFilter()
	void setFilter(Filter f)
	//获得和设置这个日志记录器的过滤器

	java.util.logging.Handler 1.4
	abstract void public(LogRecord record)
	//将日志记录发送到希望的目的地
	abstract void flush()
	//刷新所有已缓冲的数据
	abstract void close()
	//刷新所有已缓冲的数据，并释放所有相关的资源
	Filter getFilter()
	void setFilter(Filter f)
	//获得和设置这个处理器的过滤器
	Formatter getFormatter()
	void setFormatter(Formatter f)
	//获得和设置这个处理器的格式化器
	Level getLevel()
	void setLevel(Level l)
	//获得和设置这个处理器的级别

	java.util.logging.ConsoleHandler 1.4
	ConsoleHandler()
	//构造一个新的控制台处理器

	java.util.logging.FileHandler 1.4
	FilteHandler(String pattern)
	FilteHandler(String pattern, boolean append)
	FilteHandler(String pattern, int limit, int count)
	FilteHandler(String pattern, int limit, int count, boolean append)
	//构造一个文件处理器
	//参数：pattern		构造日志文件名的模式，参见表11-2列出的模式变量
	//		limit		在打开一个新的日志文件之前，日志文件可以包含的近似最大字节数
	//		count		循环序列的文件数量
	//		append		新构造的文件处理器对象应该追加在一个已存在的日志文件尾部，则为true

	java.util.logging.LogRecord 1.4
	Level getLevel()
	//获得这个日志记录的记录级别
	String getLoggerName()
	//获得正在记录这个日志记录的日志记录器的名字
	ResourceBundle getresourceBundle()
	String getresourceBundleName()
	//获得用于本地化消息的资源包或资源包的名字。如果没有获得，则返回null
	String getMessage()
	//获得本地化和格式化之前的原始消息
	Object[] getParameters()
	//获得参数对象。如果没有获得，则返回null
	Throwable getThrown()
	//获得被抛出的对象。如果不存在，则返回null
	String getSourceClassName()
	String getSourceMethodName()
	//获得记录这个日志记录的代码区域。这个信息有可能是由日志记录代码提供的，也有可能是自动从运行时堆栈推测出来的。如果日志记录代码提供的值有误，或者运行时代码由于被优化而无法推测出确切的位置，这两个方法的返回值就有可能不准确。
	long getMillis()
	//获得创建时间。以毫秒为单位(从1970年开始)
	long getSequenceNumber()
	//获得这个日志记录的唯一序列序号
	int getThreadID()
	//获得创建这个日志记录的线程的唯一ID，这些ID是由LogRecord类分配的，并且与其他线程的ID无关。

	java.util.logging.Filter 1.4
	boolean isLoggable(LogRecord record)
	//如果给定日志记录需要记录，则返回true

	java.util.logging.Formatter 1.4
	abstract String format(LogRecord record)
	//返回对日志记录格式化后得到的字符串
	String getHead(Handler h)
	String getTail(Handler h)
	//返回应该出现包含日志记录的文档的开头和借我的字符串。超类Formatter定义了这些方法，它们只返回空字符串。如果必要的话，可以对它们进行覆盖。
	String formatMessage(LogRecord record)
	//返回结果本地化和格式化后的日志记录的消息内容
```

## 调试技巧
+ 可以用下面的方法打印或记录任意变量的值：

	```Java
	System.out.println("x=" + x);

	Logger.getGlobal().info("x=" + x);
	//如果x是一个数值，则会被转换成等价的字符串。如果x是一个对象，那么Java就会调用这个对象的toString方法。要想获得隐式参数对象的状态，就可以打印this对象的状态。
	Logger.getGlobal().info("this=" + this)
	//Java类库中的绝大多数类都覆盖了toString方法，以便能够提供有用的类信息。这样会在调试中更加便捷。在自定义的类中，也应该这样做。
	```

+ 一个不太为人所知但却非常有效的技巧是在每一个类中放置一个main方法。这样就可以对每一个类进行单元测试。

	```Java
	public class MyClass {
		methods and fields
		...
		public static void main(String[] args) {
			test code
		}
	}
	//利用这种技巧，只需要创建少量的对象，调用所有的方法，并检测每个方法是否能够正确地运行就可以了。另外，可以为每个类保留一个main方法，然后分别为每个文件调用Java虚拟机进行运行测试。在运行applet应用程序的时候，这些main方法不会被调用，而在运行应用程序的时候，Java虚拟机值启用类的main方法。
	```

+ JUnit是一个非常常见的单元测试框架，利用它可以很容易地组织几套测试用例。
+ 日志代理是一个子类中的对象，它可以窃取方法调用，并进行日志记录，然后调用超类中的方法。
+ 利用Throwable类提供的printStackTrace方法，可以从任何一个异常对象中获得堆栈情况。
+ 一般来说，堆栈跟踪显示在System.err上。也可以采用printStackTrace(PrintWriter s)方法将它发送到一个文件中。
+ 通常将一个程序中的错误信息保存在一个文件中是非常有用的。然而，错误信息被放松到System.err中，而不是System.out中。
+ 让非捕获异常的堆栈跟踪出现在System.err中并不是一个很理想的方法。将这些内容记录到一个文件中。可以调试静态的Thread.setDefaultUncaughtExceptionHandle方法改变非捕获异常的处理器。
+ 要想观察类的加载过程，可以用`-verbose`标志启动Java虚拟机。
+ Xlint选项告诉编译器对一些普遍容易出现的代码问题进行检查。
+ Java虚拟机增加了对Java用程序进行监控(monitoring)和管理(management)的支持。
+ 可以使用jmap实用工具获得一个堆的转储，其中显示了堆中的每个对象。
+ 如果使用`-Xprof`标志运行Java虚拟机，就会运行一个基本的剖析器来跟踪那些代码中经常被调用的方法。

### GUI程序排错技巧

## 使用调试器


