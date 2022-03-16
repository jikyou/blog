---
title: 第一章 流与文件
date: 2017-05-30 11:01
tags: Core Java Volume II
---

# 流与文件

## 流

+ 在 Java API 中，可以从其中读入一个字节序列的对象称做输入流，而可以向其中写入一个字节序列的对象称做输出流。
+ 抽象类 InputStream 和 OutputStream 构成了输入/输出（I/O）类层次结构的基础
+ 抽象类 Reader 和 Writer中继承出来了一个专门用于处理 Unicode 字符的单独的类层次结构。这些类拥有的读入和写出操作都是基于两字节的 Unicode 码元的，而不是基于单字节的字符。

### 读写字节

```Java
InputStream
abstract int read() //读入一个字节，并返回读入的字节。遇到输入源结尾时返回 -1。

Sustem.in //是 InputStream 的一个子类的预定义对象。
// 从键盘读入信息

OutputStream
abstract void write(int b) // 可以向某个输出位置写出一个字节。
```

+ read 和 write 方法在执行时都将阻塞，直至字节确实被读入或写出。
+ available 方法使我们可以去检查当前可读入的字节数量。

```SQL
// available 不会被阻塞，阻塞意味着当前线程将失去它对资源的占用。
int bytesAvailable = in.available();
if(bytesAvailable > 0)
{
    byte[] data = new byte[bytesAvailable];
    in.read(data);
}
```

+ 完成对流的读写时，应该通过调用 close 方法来关闭它，这个调用会释放掉十分有限的操作系统资源。
+ 关闭一个输入流的同时还会冲刷用于该输出流的缓冲区：所有被临时置于缓冲区中，以便用更大的包的形式传递的字符在关闭输出流时都将被送出。

    + 如果不关闭文件，那么写出字节的最后一个包可能将永远也得不到传递。
    + 或者可以用 flush 方法来人为地冲刷这些输出。

```Java
java.io.InputStream 1.0
abstract int read()
int read(byte[] b) // 读入一个字节数组，并返回实际读入的字节数，或者在碰到流的结尾时返回 -1 。最多读入 b.length 个字节
int read(byte[] b, int off, int len) // off 第一个读入字节应该被放置的位置在 b 中的偏移量 
// len 读入字节的最大数量
long skip(long n) // 在输入流中跳过 n 个字节，返回实际跳过的字节数（如果碰到流的结尾，则可能小于 n）
int available()
void close() // 关闭这个输入流
void mark(int readlimit) // 在输入流的当前位置打一个标记（并非所有流都支持这个特性）。如果输入流中已经读入的字节多于 readlimit 个，则这个流允许忽略这个标记。
void reset() // 返回到最后一个标记，随后对 read 的调用将重新读入这些字节。如果当前没有任何标记，则这个流不被重置。
boolean markSupported() // 如果这个流支持打标记，则返回 true

java.io.OutputStream 1.0
abstract void write(int n)
void write(byte[] b)
void write(byte[] b, int off, int len) // 写入所有字节或者某个范围的字节到数组 b 中。
void close(); // 冲刷并关闭输出流
void flush(); // 冲刷输出流，也就是将所有缓冲带数据发送到目的地。
```

### 完整的流家族

+ DataInputStream 和 DataOutputStream 可以以二进制格式读写所有的基本 Java 类型。
+ ZipInputStream 和 ZipOutputStream 可以以常见的 ZIP 压缩格式读写文件。


+ 对于 Unicode 文本，可以使用抽象类 Reader 和 Writer 的子类。
+ read 方法将返回一个 Unicode 码元（一个在 0 ～ 65535之间的整数），或者在碰到文件结尾时返回 -1 。
+ write 方法在被调用时，需要传递一个 Unicode 码元。

+ 还有 4 个附加的接口：Closeable，Flushable，Readable 和 Appendable。

```Java
Closeable
void close() throws IOException

Flushable
void flush()
```

+ InputStream，OutputStream，Reader 和 Writer 都实现了 Closeable接口
+ `java.io.Closeable` 接口扩展了 `java.lang.AutoCloseable 接口。因此，对任何 Closeable 进行操作时，都可以使用 `try-with-resource` 语句。

    + Closeable 接口的 close 方法只抛出 IOException
    + 而 AutoCloseable.close 方法可以抛出任何异常

+ OutputStream 和 Writer 还实现了 Flushable 接口。

```Java
// Readable 接口只有一个方法：
int read(CharBuffer cb)
```

+ CharBuffer 类拥有按顺序和随机地进行读写访问的方法，它表示一个内存中的缓冲区或者一个内存映射的文件。

```Java
// Appendable 接口有两个用于添加单个字符和字符序列的方法
Appendable append(char c)
Appendable append(CharSequence s)
```

+ CharSequence 接口描述了一个 char 值序列的基本属性，String，CharBuffer，StringBuilder 和 StringBuffer 都实现了它。
+ 在流类的家族中，只有 Writer 实现了 Appendable

```Java
java.io.Closeable 5.0
void close() // 关闭这个 Closeable ，这个方法可能会抛出 IOException

java.io.Flushable 5.0
void flush() // 冲刷这个 Flushable

java.lang.Readable 5.0
int read(CharBuffer cb) // 尝试着向 cb 读入其可持有数量的 char 值。返回读入的 char 值的数量，或者当从这个 Readable 中无法再获得更多的值时返回 -1 。

java.lang.Appendable 5.0
Appendable append(char c)
Appendable append(CharSequence cs) // 向这个 Appendable 中追加给定的码元或者给定的序列中的所有码元，返回 this。

java.lang.CharSequence 1.4
char charAt(int index) // 返回给定索引处的码元
int length() // 返回在这个序列中的码元的数量
CharSequence subSequence(int starIndex, int endIndex) // 返回由存储在 startIndex 到 endIndex-1 处的所有码元构成的 CharSequence
String toString() // 返回这个序列中所有码元构成的字符串。
```

### 组合流过滤器

+ FileInputStream 和 FileOutputStream 可以提供附着在一个磁盘文件上的输入流和输出流，而你只需向其构造期提供文件名或文件的完整路径。

```Java
FileInputStream fin = new FileInputStream("employee.dat");
// 查看在用户目录下名为 "emlyee.dat" 的文件

// java.io 中的类都将相对路径名解释为以用户工作目录开始
System.getProperty("user.dir"); // 获得用户工作目录
```

+ 由于反斜杠自负在 Java 字符串中时转义字符，因此要确保在 Windows 风格的路径名中使用 `\\` （如：`C:\\Windows\\win.ini`）。
    + 在 Windows 中，还可以使用单斜杆字符（`C:/Windows/win.ini`）。
    + 但是，大部分 Windows 文件处理的系统调用都会将斜杠解释成文件分隔符。
    + 因为 Windows 系统函数的行为会因与时俱进而发生变化。因此对于可移植的程序来说，应该使用程序所运行平台的文件分隔符，我们可以通过常量字符串 java.io.File.separator 获得它

```Java
byte b = (byte)fin.read();

DataInputStream din = ...;
double s = din.readDouble();
```

+ 某些流（ FileInputStream openStream）可以从文件和其他更外部的位置上获取字节，而其他的流（DataInputStream PrintWriter）可以将字节组装到更有用的数据类型中。

```Java
FileInputStream fin = new FileInputStream("employee.dat");
DataInputStream din = new DataInputStream(fin);
double s = din.readDouble();
```

+ FilterInputStream 和 FilterOutputStream 类，这些文件的子类用于向原生字节流添加额外的功能。

+ 使用嵌套过滤器来添加多重功能。

```Java
DataInputStream din = new DataInputStream(
    new BufferedInputStream(
        new FileInputStream("employee.dat")
    )
);
```

+ 有时当多个流链接在一起时，你需要跟踪各个中介流（intermediate stream）。

```Java
PushbackInputStream pbin = new PushbackInputStream(
    new BufferedInputStream(
        new FileInputStream("employee.dat")
    )
);
// 预读下一个字节：
int b = pbin.read();
// 并非期望的值，将其推回流中
if(b != '<') pbin.unread(b);

// 读入和推回是可应用于可回推（pushback）输入流的仅有的方法。

DataInputStream din = new DataInputStream(
    pbin = new PushbackInputStream(
        new BufferedInputStream(
            new FileInputStream("employee.dat")
        )
    )
);
```

+ 在其他编程语言的流类库中，诸如缓冲机制和预览等细节都是自动处理的。因此，相比较而言，Java 必须将多个流过滤器组合起来。

```Java
ZipInputStream zin = new ZipInputStream(new FileInputStream("emplyee.zip"));
DataInputStream din = new DataInputStream(zin);
```

```Java
java.io.FileInputStream 1.0
FileInputstream(String name)
FilieInputStream(File file)
// 使用由 name 字符串或 file 对象指定路径名的文件创建一个新的文件输入流。非绝对的路径名将按照相对于 VM 启动时所设置的工作目录来解析。

java.io.FileOutputStream 1.0
FileOutputStream(String name)
FileOutputStream(String name, boolean append)
FileOutputStream(File file)
FileOutputStream(File file, boolean append)
// 使用由 name 字符串或 file 对象指定路径名的文件创建一个新的文件输入流。
// 如果 append 参数为 true，那么数据将被添加到文件尾，而具有相同名字的已有文件不会被删除；否则，这个方法会删除所有具有相同名字的已有文件

java.io.BufferedInputStream 1.0
BufferedInputStream(InputStream in)
// 创建一个带缓冲区的流。带缓冲区的输入流在从流中读入字符时，不会每次都对设备访问。当缓冲区为空时，会向缓冲区中读入一个新的数据块。

java.io.BufferedOutputStream 1.0
BufferedOutputStream(OutputStream out)
// 创建一个带缓冲区的流。带缓冲区的输出流在收集要写出的字符时，不会每次都对设备访问。当缓冲区填满或当流被冲刷时，数据就被写出。

java.io.PushbackInputStream 1.0
PushbackInputStream(InputStream in)
PushbackInputStream(InputStream in, int size)
// 构建一个可以预览一个字节或者具有指定尺寸的回推缓冲区的流。
void unread(int b)
// 回推一个字节，它可以在下次调用 read 时被再次获取。
```

## 文本输入与输出

+ 在保存数据时，可以选择二进制格式或文本格式。

    + 整数 1234 存储成二进制数时，被写为由字节 00 00 04 D2 构成的序列（十六进制表示法）
    + 而存储成文本格式时，它被存成了字符串 "1234" 。

+ 在存储文本字符串时，需要考虑字符编码（character encoding）方式。
+ OutputStreamWriter 类使用选定的字符编码方式，把 Unicode 字符流转换为字节流。而 InputStreamReader 类将包含字节（用某种字符编码方式表示的字符）的输入流转换为可以产生 Unicode 码元的读入器。

```Java
InputStreamReader in = new InputStreamReader(System.in); // 假定使用主机系统默认字符编码方式。
InputStreamReader in = new InputStreamReader(new FileInputStream("kremlin.dat"), "ISO8859_5");
```

### 如何写出文本输出

+ 文本输出 PrintWriter 。 这个类拥有以文本格式打印字符串和数字的方法，它甚至还有一个将 PrintWriter 链接到 FilterWriter 的便捷方法。

```Java
PrintWriter out = new PrintWriter("employee.txt");
// 等同于：
PrintWriter out = new PrintWriter(new FileWriter("employee.txt"));

// 为了输出到打印写出器，需要使用与使用 System.out 时相同的 print, println 和 printf 方法。
// 可以打印数字（int, short, long, float, double），字符，boolean 值，字符串和对象。
String name = "Harry Hacker";
double salary = 75000;
out.print(name);
out.print(' ');
out.println(salary);
```

+ `println` 方法在行中添加对目标系统来说恰当的行结束符（Windows 系统是 "\r\n", UNIX 系统是 "\n"）

    + 通过 `System.getProperty(line.separtor)` 而获得的字符串

+ 自动冲刷机制

```Java
PrintWriter out = new PrintWriter(new FileWriter("employee.txt"), true); //启用自动冲刷机制。
```

+ Print 不抛出异常，你可以调用 checkError 方法来查看流是否出现了某些错误。

```Java
java.io.PrintWriter 1.1
PrintWriter(Writer out)
PrintWriter(Writer out, boolean autoFlush)
PrintWriter(OutputStream out)
PrintWriter(OutputStream out, boolean autoflush)
PrintWriter(String filename)
PrintWriter(File file)

void print(Object obj)
void print(String s)
void println(String s)
void print(char[] s)
void print(char c)
void print(int i)
void print(long l)
void print(float f)
void print(double d)
void print(boolean b)
void printf(String format, Object... args)
boolean checkError()
```

### 如何读入文本输入

+ 以二进制格式写出数据，需要使用 DataOutPutStream
+ 以文本格式写出数据，需要使用 PrintWriter

```Java
BufferedReader in = new BufferedReader(
    new InputStreamReader(new FileInputStream("employee.txt"), "UTF-8")
);

// readLine 方法在没有输入时返回 NULL
String line;
while((line = in.readLine()) != null)
{
    do something with line
}
```

+ BufferedReader 没有任何用于读入数字的方法，我们建议你使用 Scanner 来读入文本输入。

### 以文本格式存储对象

```Java
// textFile/TextFileTest.java

public class TextFieTest
{
    public static void main(String[] args) throws IOException
    {
        Employee[] staff = new Employee[3];
        staff[0] = new Employee("Carl Cracker", 75000, 1987, 12, 15);
        staff[1] = new Employee("Harry Hacker", 50000, 1989, 10, 1);
        staff[2] = new Employee("Tony Tester", 40000, 1990, 3, 15);
        
        try (PrintWriter out = new PrintWriter("employee.dat", "UTF-8"))
        {
            writeData(staff, out);
        }
        
        try (Scanner in = new Scanner(
            new FileInputStream("employee.dat"), "UTF-8"
        ))
        {
            Employee[] newStaff = readData(in);
            for(Employee e : newStaff)
                System.out.println(e);
        }
    }
    
    private static void writerData(Employee[] employees, PrintWriter out) throws IOException
    {
        out.println(employees.length);
        
        for(Employee e : employees)
            writeEmployee(out, e);
    }
    
    private static Employee[] readData(Scanner in)
    {
        int n = in.nextInt();
        in.nextLine();
        
        Employee[] employees = new Employee[n];
        for(int i = 0; i < n; i++)
        {
            employees[i] = readEmployee(in);
        }
        return employees;
    }
    
    public static void writeEmployee(PrintWriter out, Employee e)
    {
        GregorianCalendar calendar = new GregorianCalendar();
        calendar.setTime(e.getHiredDay());
        out.println(e.getName() + "|" + e.getSalary() + "|" + calendar.get(Calendar.YEAR) + "|" + (calendar.get(Calendar.MONTH) + 1) + "|" + calendar.get(Calendar.DAY_OF_MONTH));
    }
    
    public static Employee readEmployee(Scanner in)
    {
        String line = in.nextLine();
        String[] tokens = line.split("\\|");
        String name = tokens[0];
        double salary = Double.parseDouble(tokens[1]);
        int year = Integer.parseInt(tokens[2]);
        int month = Integer.parseInt(tokens[3]);
        int day = Integer.parseInt(tokens[4]);
        return new Employee(name, salary, year, month, day);
    }
}
```

### 字符集

+ Java SE 1.4 中引入的 java.nio 包用 Charset 类统一了对字符集的转换。
+ 字符集建立了两字节 Unicode 码元序列与使用本地字符编码方式的字节序列进行单字节编码的方式。
+ Charset 类使用的是由 IANA 字符集注册中心标准化的字符集名字，这些名字与以前版本所使用的名字略有差异。ISO-8859-1 的"官方"名字现在是“ISO-8859-1”而不再是“ISO8859-1”。
+ 为了兼容其他的命名惯例，每个字符集都可以拥有许多别名。

```Java
// aliases 方法返回由别名构成的 Set 对象。
Set<String> aliases = cset.aliases();
for(String alias : aliases)
    System.out.println(alias);

// 字符集名字大小写是不敏感的。

Charset cset = Charset.forName("ISO-8859-1");

// 为了确定在某个特定实现中哪些字符集是可用的
Map<String, Charset> charsets = Charset.availableCharsets();
for(String name : charsets.keySet())
    System.out.println(name);
```

+ 本地编码方式模式不能表示所有的 Unicode 字符，如果某个字符不能表示，它将被转换成`？`。

```Java
// 编码
String str = ...;
ByteBuffer buffer = cset.encode(str);
byte[] bytes = buffer.array();

// 解码
byte[] bytes = ...;
ByteBuffer bbuf = ByteBuffer.wrap(bytes, offset, length);
CharBuffer cbuf = cdet.decode(bbuf);
String str = cbuf.toString();
```

```Java
java.nio.charset.Charset 1.4
static SorteMap availableCharsets()
static Charset forName(String name)
Set aliases()
ByteBuffer encode(String str)
CharBuffer decode(ByteBuffer buffer)

java.nio.ByteBuffer 1.4
byte[] arrray[]
static ByteBuffer wrap(byte[] bytes)
static ByteBuffer wrap(byte[] bytes, int offset, int length)
// 返回管理给定字节数组或给定字节数组的某个范围的字节缓冲区。

java.nio.charBuffer
char[] array() // 返回这个缓冲区所管理的码元数组
char charAt(int index)
String toString() // 返回由这个缓冲区所管理的码元构成的字符串
```

## 读写二进制



