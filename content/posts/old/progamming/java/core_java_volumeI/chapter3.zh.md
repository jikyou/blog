---
title: 第三章 Java基本程序设计结构
date: 2016-08-03 23:16:00 +0800
tags:
- Core Java Volume I
mathjax: true
---

+ 逐一声明每一个变量可以提高程序的可读性。
+ 在Java中，变量的声明尽可能地靠近变量第一次使用的地方，这是一种良好的程序编写风格。
+ 常量名使用全大写。使用关键字static final设置一个类常量。
`public static final double CM_PER_INCH = 2.54;`类常量定义位于main方法的外部。
+ 我们建议不要在其他表达式的内部使用`++`，这样编写的代码很容易令人困惑，并会产生烦人的bug。(一个笑话C++)
+ `&&`和`||`按照短路的方式求值。`&`,`|`运算符应用于布尔值，得到的结果也是布尔值。不按**短路**方式计算。
+ `>>>`运算符将用0填充高位；`>>`运算符用符号位填充高位。没有`<<<`运算符。
+ 强制类型转换

    ```
    得到最接近的整数 
    double x = 9.997;
    int nx = (int) Math.round(x);//round返回的结果是long类型
    ```

+ `&&`优先级比`||`的优先级高。`+=`右结合运算符。
+ substring方法的第二个参数是不想复制的第一个位置，substring可以计算字符串长度。
+ 当一个字符串和一个非字符串的值进行拼接时，后者被转换成字符串（任何一个对象都可以转换成字符串。
+ 在java文档中将String类对象称为不可变字符串。java的设计者认为共享带来的高效率远远胜过于提取，拼接字符串带来的低效率。
+ 检测字符串是否相等 `s.equals(t)`s,t可以是字符串变量可以是字符串常量。`==`判断字符串是否放在同样位置上，如果在同样位置上，它们必然相等。
+ if(str.length() == 0) 或 if(str.equals(""))   是否为空
+ if(str != null && str.length() != 0)  检查字符串既不是null也不是空串
+ length()方法返回采用UTF-16编码表示到给定字符串所需要到代码单元数量.//3.6.6

    ```java
    int cpCount = greeting.codePointCount(0, greeting.length());//得到实际长度,即代码点得数量.
    char first = greeting.chatAt(0);//调用s.char.charAt(n)将返回位置n到代码单元.
    //得到第i个代码点.
    int index = gretting.offsetByCodePoint(0, i);
    int cp = gertting.codePintAt(index);//
    //遍历一个字符串,依次查看每一个代码点
    int cp = sentence.codePointAt(i);
    if(Chartacter.isSupplementaryCodePoint(cp)) i += 2;
    else i++;
    //回退操作
    i--;
    if(Chartacter.isSupplementaryCodePoint(cp)) i--;
    int cp = sentence.codePointAt(i);
    ```

+ 常用的字符串API

    ```java
    API java.lang.Stirng 1.0
    int codePointAt(int index);//返回给定位置开始或结束到代码点
    int offsetByCodePoints(int startIndex, int cpCount);//返回从startIndex代码点开始,位移cpCount后的代码点索引
    int compareTo(String other);//按照字典顺序,如果字符串位于other之前,返回一个负数;如果字符串位于other之后返回一个正数;如果两个字符串相等,返回0
    int indexOf(String str);
    int indexOf(Sting str, int fromIndex);
    int indexOf(int cp);
    int indexOf(int cp, int fromIndex);//返回与字符串str或代码点cp匹配的第一个子串得开始位置.这个位置从索引0或fromIndex开始计算.如果在原始串中不存在str,返回-1.
    int codePointCount(int startIndex, int endIndex);//返回startIndex和endIndex-1 之间的代码点数量.没有配成对到代用字符将计入代码点.
    Stirng trim();//返回一个新字符串.这个字符串将删除年原始字符串头部和尾部到空格.
    ```

+ StringBuilder（JDK5.0引入StringBilder类，前身是StringBuffer）

    ```java
    StringBuilder builder = new StringBuilder();//构造空的字符串构建器
    bulider.append(ch);添加内容
    String completedString = builder.toStirng();//构建字符串，得到一个String对象，其中包含了构建器中的字符序列。
    ```

    ```java
    API java.lang.StringBuilder 5.0
    StringBuilder();//构造一个空的字符串构建器
    int length();//返回构建器或缓冲器中的代码单元
    StringBuilder append(String str);//追加一个字符串并返回this
    StringBuilder append(char c);//追加一个代码单元并返回this
    StringBuilder appendCodePoint(int cp);//追加一个代码点，并将其转换为一个或两个代码单元并返回this
    String toStrinig();//返回一个与构造器或缓冲区内容相同的字符串。
    ```

+ 标准输入流System.in，Scanner

    ```java
    API java.util.Scanner 5.0
    Scanner in = new Scanner(System.in);//用给定的输入流创建一个scanner对象。
    System.out.print("What is your name?");
    String name = in.nextLine();//输入一行，包括空格。
    String firstName = in.next();//读取一个单词，以空格符作为分隔符。
    System.out.print("How old are you?");
    int age = in.nextInt();//读取一个整数。nextDouble()读取下一个浮点数。
    ```

+ 当使用的类不是定义在基本java.lang包中时，一定要使用import指定字将相应的包加载进来。
+ Scanner类，输入是可见的，不适合用于控制台读取密码。Java SE 6引入Console类实现读取密码

    ```java
    API java.io.Console 6
    Console cons = System.console();
    String username = cons.readLine("User name: ");
    char[] passwd = cons.readPassword("Password: ");//Console每次只能读取一行，没有读取一个单词或者一个数值的方法。
    ```

    ```java
    API java.lang.System 1.0
    staic Console console() 6 //交互操作
    ```

+ 每一个以%字符开始的格式说明符都用相应的参数替换。格式说明符尾部的转换符将指示被格式化的数值类型。
+ printf方法中日期与时间的格式化选项。以t开始，以表3-7中任意字母结束的两个字母格式。

    ```java
    System.printf("%tc", new Date());//Mon Feb 09 18:05:19 PST 2004
    System.printf("%1$s %2StB %2$te, %2$tY", "Due date", new Date());//Due date: February 9, 2004
    System.out.printf("%s %tB %<te, %<tY", "Due date: ", new Dte());//<标志，它指示前面格式说明中的参数将再次被使用。
    ```

+ 参数索引值从1开始，而不是从0开始，`%1$...`对第1个参数格式化。
+ 文件输入输出

    ```java
    Scanner in = new Scanner(Paths.get("myfile.txt"));
    PrintWriter out = new PrintWriter("myfile.txt");
    Scanner in = new Scanner("myfile.txt");//字符串
    ```

    ```java
    API java.io.PrintWrier 1.1
    PrintWriter(String fileName);//构造一个将数据写入文件的PrintWriter。文件名由参数决定。
    API java.nio.file.Pahts 7
    static Path get(String pathname);//根据给定的路径名构造一个Path。
    ```

+ else与最邻近的if构成一组

    ```java
    if(x <= 0) if(x == 0) sign = 0; else sign = -1;
    ```

+ 不成文的规定：for语句中的3个部分应该对同一个计数器变量进行初始化，检测，更新。
+ 在循环中检测两个浮点数是否相等需要格外小心。

    ```java
    for(double x = 0; x != 10; x += 0.1)...//可能永远不会结束，由于舍入的误差，最终可能得不到精确值。循环中，因为0.1无法精确地用二进制表示，x将从9.99...98跳到10.09...98
    ```

+ 从n个数字中抽取k个数字

$$\frac{n*(n-1)*(n-2)*...*(n-k+1)}{1*2*3*4*5*6}$$

```java
int lotterOdds = 1;
for(int i = 1; i <= k; i++) {
   lotterOdds = lotterOdds * (n-i+1) / i;
}
```

+ switch的case标签可以是:
> 类型为char, byte, short或int(或其包装类Character, Byte, Short和Integer)的常量表达式.
> 枚举变量
> 从Java SE 7 开始,case标签还可以是字符串字面量.
+ 当在switch语句中使用枚举常量时,不必在每个标签中指明枚举名,可以由switch得表达式值确定.

    ```java
    Size sz = ...;
    switch(sz) {
        case SMALL: //no need to use Size.SMALL
            ...
            breakl
        ...
    }
    ```

+ 带标签的break,continue(标签必须放在希望跳出到最外层循环之前,并且必须紧跟一个冒号.)
+ 大数值BigInteger(实现任意精度的整数运算),BigDecimal(实现任意精度的浮点数运算)

    ```java
    API java.math.BigInteger 1.1
    BigInteger add(BigInteger other);//和
    BigInteger subtract(BigInteger other);//差
    BigInteger multiply(BigInteger other);//积
    BigInteger divide(BigInteger other);//商
    BigInteger mod(BigInteger other);//余数
    //返回一个大整数和另一个大整数other的和，差，积，商以及余数。
    static BigInteger valueOf(long x);//返回值等于x的大整数。
    BigDecimal add(BigDecimal other);//和
    BIgDecimal subtract(BigDecimal other);//差
    BigDecimal multiply(BigDecimal other);//积
    BigDecimal divide(BigDecimal other RoundingMode mode);//商
    //返回这个大实数与另一个大实数other.HALF_UP是在学校学习的四舍五入方式。
    static BigDecimal valueOf(long x);
    static BigDecimal valueOf(long x, int scale);
    //返回值位x或x/10^scale的大实数
    ```

$$x/10^{scale}$$

```java
int[] a;//声明整型数组a
int[] a = new int[100];//初始化一个数组，数组的长度不要求是常量，new int[n]创建一个长度位n的数组。
```

+ 创建一个数字数组时，所有的元素都会被初始化为0.boolean数组的元素会初始化称false。对象数组的元素则初始化为一个特殊值null，这表示元素还未存放任何对象。
+ 一旦创建数组就不能再改变它的大小，如果经常需要在运行过程中扩展数组的大小，就应该使用另一种数据结构-数组列表(array list)。
+ 增强for循环的语句格式为：for(variable : collection) statement.定义一个变量用于暂存集合中的每一个元素，并执行相应的语句(或者语句块)。collection这一集合表达式必须是一个数组或者是一个实现类Iterable接口的类对象(如ArrayList).(for each element in a)
+ 更简单的方式打印数组中的所有值，Arrays.toString(a),返回一个包含数组元素的字符串，这些元素放在括号内，并用逗号分开，如："[2, 3, 5, 7, 11, 13]".

    ```java
    int[] smallPrimes = {2, 3, 5, 7, 11, 13};//创建数组并初始化的简化形式，不需要new
    new int[] {17, 19, 23, 29, 31, 37};//初始化一个匿名数组
    samllPrimes = new int[] {17, 19, 23, 29, 31, 37};
    ```

+ 在java中允许数组的长度为0.

    ```java
    int[] copiedLuckyNumbers = Array.copyOf(luckNumbers, luckNumbers.length);//将一个数组的所有值拷贝到一个新的数组中去。
    luckNumbers = Arrays.copyOf(luckNumbers, 2 * luckyNUmbers.length);//这种方法通常用来增加数组的大小。如果数组是数值型，那么多余的元素将被赋值为0；布尔型，将赋值为false；如果长度小于原始数组的长度，则只拷贝最前面的数据元素。
    ```

+ java中的[]运算符被预定义为检查数组边界，而且没有指针运算，即不能通过a加1得到数组的下一个元素。

    ```java
    public class Message {
        public static void main(String[] args) {
            if...
        }
    }
    java Message -g cruel world;//args数组将包含下列内容:args[0]:"-g";args[1]:"cruel";args[2]:"world"
    ```

+ 在java运行应用程序的应用程序到main方法中,程序名并没有存储在args数组中.例如,当使用下列命令运行程序时.java Message -h world;//args[0]是"-h",而不是"Message"或"java".
+ Arrays.sort(a);//对数值型数组进行排序,使用了优化的快速排序算法.

    ```java
    import java.util.*;
    /**
      *3-7
      */
    public class LotteryDrawing {
        public static void main(String[] args) {
            Scanner in = new Scanner(System.in);
            System.out.print("How many numbers do you need to draw?");
            int k = in.nextInt();
            System.out.print("What is the highest number you can deaw?");
            int n = in.nextInt();
            int[] numbers = new int[n];
            for(int i = 0; i < numbers.length; i++) {
                int r = (int) (Math.random() * n);
                result[i] = number[r];
                numbers[r] = numbers[n - 1];
                n--;
                Arrays.sort(result);
                System.out.println("Bet the following combination.It'll make you rish!");
                for(int r : result)
                    System.out.println(r);
            }
        }
    }
    ```

    ```java
    API java.util.Arrays 1.2
    //参数a 类型为int,long,char,byte,boolean,float或double的数组.
    //start 包含这个值.
    //end 不包含这个值.
    //v 同a的数据元素类型相同的值.
    static String toString(type[] a);//返回包含a中数据元素的字符串,这些数据元素被放在括号中,并用逗号分隔.
    static type copyOf(type[] a, int length);
    static type copyOf(type[] a, int start, int end);
    static void sort(type[] a);
    static int binarySearch(type[] a, type v);
    static int binarySearch(type[] a, int start, int end, type v);//采用二分搜索算法查找v.如果查找成功,则返回相应到下标值;否则,返回一个负数值,-r-1是为保持a有序v应插入到位置.
    static void fill(type[] a, type v);//将数组的所有数据元素值设置为v.
    static boolean equals(type[] a, type[] b);//如果两个数组大小相同,并且下标相同的元素都对应相等,返回true.
    ```
    + 二维数组(3.10.6),要想快速打印二位数组Arrays.deepToString(a);//格式:[[1, 2, 3], [2, 3, 4], [5, 6, 7]]
    + 不规则数组:只能单独创建行数组.(3.10.7)

    ```java
    public class LotteryArray {
        public static void main(String[] args) {
            final int NMAX = 10;
            int[][] odds = new int[NMAX + 1][];
            for(int n = 0; n <= NMAX; n++)
                odds[n] = new int[n + 1];
            for(int n = 0; n < odds.length; n++) {
                for(int k = 0;k < odds[n].length; k++) {
                    int lotteryOdds = 1;
                    for(int i = 1; i <= k; i++)
                        lotteryOdds = lotteryOdds * (n - i + 1) / i;
                    odds[n][k] = lotteryOdds;
                }
                for(int[] row : odds)
                    System.out.printf("%4d", odd);
                System.out.println();
            }
        }
    }
    ```

> 表3-3 特殊字符的转义序列符
图3-1 数值类型之间的合法转换
表3-4 运算符优先级
表3-5 用于printf的转换符
表3-6 用于printf的标志
表3-7 日期和时间的转换符
图3-6 格式说明符语法


