---
title: 看透 SpringMvc 源代码分析与实践
date: 2017-06-19T09:22:00+08:00
tags:
- Spring
---

# 网络基础知识

## 软件的三大类型

+ 单机类型
+ CS 类型
+ BS 类型

## 基础的结构

+ BS 结构网络传输的分解方式有两种

    + 标准的 OSI 参考模型

        + 应用层，表示层，会话层，传输层，网络层，数据链路层，物理层

    + TCP／IP 参考模型

        + 应用层，传输层，网际互联层，网络接入层

            + 网络接入层 讲需要相互连接的节点介入网络中，从而为数据传输提供条件（没有相应的协议）
            + 网际互联层 找到要传输数据的目标节点（IP）
            + 传输层 实际传输数据（TCP）
            + 应用层 使用接收到的数据（HTTP）

+ BS 结构中还使用了 DNS 协议，在 HTTP 上层还有相应的规范，如 Java Web 开发中使用的是 Servlet 标准。
+ 数据传输的本质就是按照晶体震动周期或者其整数倍来传输代表 0/1 的高低电平，传输过程中最核心就是各种传输协议，对直接连接的硬件来说就是各种总线协议，对网络传输来说就是网络协议。
+ 解决速度问题的核心主要就是解决海量数据操作问题和高并发问题。

## 架构演变的起点

+ 当数据和流量变得越来越大的时候就难以应付，这时候就需要讲应用程序和数据库分别放到不同的主机中。

## 海量数据的解决方案

### 缓存和页面静态化

+ 数据量大这个问题最直接的解决方案就是使用缓存。
+ 缓存的使用方式可以分为通过程序直接保存到内存中和使用缓存框架两种方式。

    + 程序直接操作主要是使用 Map ，尤其是 ConcurrentHashMap
    + 常用到缓存框架有 Ehcache,Memcache 和 Redis

+ 缓存使用过程中最重要的问题是什么时候创建缓存和缓存的失效机制。

    + 缓存可以在第一次获取的时候创建也可以在程序启动和缓冲失效之后立即创建
    + 缓存的失效可以定期失效，也可以在数据发生变化的时候失效。如果按数据变化让缓存失效，还可以分粗粒度和细粒度实效。

+ 缓存中空数据的管理方法

    + 如果缓存是在第一次获取的时候创建的，那么在使用缓存的时候最好将没有数据的缓存使用特定的类型值来保存
        + 因为这种方式下如果从缓存中获取不到数据就会从数据库中获取，如果数据库中本来就没有相应的数据就不会创建缓存，这样将每次都会查询数据库。
        + 创建一个专门的类来保存没有评论的缓存。

+ 主要用于数据变化不是很频繁的情况。

+ 页面静态化，缓存是将从数据库中获取到的数据（当然也可以是别的任何可以序列化的东西）保存起来，而页面静态化是将程序最后生成的页面保存起来。
    + 页面静态化可以在程序中使用模版技术生成，如常用的 Freemarker 和  Velocity 都可以根据模版生成静态页面
    + 也可以使用缓存服务器在应用服务器的上一层缓存生成的页面，如可以使用 Squid 另外 Nginx 也提供了相应的功能。

### 数据库优化

+ 解决数据量大的问题

#### 表结构优化

#### SQL 语句优化

+ 基础的 SQL 优化是语法层面的优化，不过更重要的是处理逻辑的优化，要和索引缓存等配合使用。
+ 通用做法，涉及大数据的业务等 SQL 语句执行时间详细记录下，其次通过仔细分析日志（同一条语句对不同条件的执行时间也可能不同，这点需要仔细分析）找出需要优化的语句和其中的问题。而不是不分重点对每条语句都花同样的时间和精力优化。

#### 分区

+ 分区就是将一张表中的数据按照一定的规则分到不同的区来保存，这样在查询数据时如果数据的范围在同一个区内那么可以只对一个区的数据进行操作。（如：按月份）

#### 分表

+ 用一个字段来做卡片状态的标志位，将卡片分成不同的类型。第一个表保存正常卡片，第二个表保存删除后的卡片，第三个表保存修改之前的卡片，并对每个表都进行分区。
+ 将一个表中不同类型的字段分到不同的表中保存，这么做最直接的好处就是增删改数据的时候锁定的范围减小了。

#### 索引优化

+ 在数据发生变化（增删改）的时候就预先按指定字段的顺序排列后保存到一个类似表的结构中，这样在查找索引字段为条件的记录时就可以很快地从索引中找到对应记录的指针并从表中获取到记录。
+ 不过索引也是一把双刃剑，它在提高查询速度的同时也降低了增删改的速度，因为每次数据的变化都需要更新相应的索引。
+ 合理使用索引对提升查询速度的效果非常明显，所以对哪些字段使用索引，使用什么类型的索引都需要仔细琢磨，并且再做一些测试。

#### 使用存储过程代替直接操作

+ 在操作过程复杂而且调用频率高的业务中，可以通过使用存储过程代替直接操作来提高效率。
+ 存储过程只需要编译一次，而且可以在一个存储过程里面做一些复杂的操作。

### 分离活跃数据

+ 虽然有些数据总数据量非常大，但是活跃数据并不多，这种情况就可以将活跃数据单独保存起来从而提高处理效率。

### 批量读区和延迟修改

+ 原理通过减少操作的次数来提高效率。

    + 批量读取是将多次查询合并到一次中进行

        + 同一个请求中的数据批量读取  将所有要保存的数据的相应字段读取到一个变量中，然后使用 in 语句统一查询一个数据库，这样就就可以将 n 次查询变为一次查询了。
        + 在高并发的情况下还可以将多个请求的查询合并到一次进行，如将 3 秒或 5 秒内的所有请求合并到一起统一查询一次数据库，这种类型可以用异步请求来处理。

    + 延迟修改主要针对高并发而且频繁修改（包括新增）的数据。

        + 可以先将需要修改的数据暂时保存到缓存中，然后定时将缓存中的数据保存到数据库中，程序在读取数据时可以同时读取数据库中和缓存中的数据。（这里的缓存和前面介绍的缓存有本质的区别，前面的缓存在使用过程中，数据库中的数据一直时最完整的，但这里数据库中的数据会有一段时间不完整）
        + 这种方式下如果保存缓存的机器出现了问题将可能会丢失数据，所以如果是重要的数据就要需要做一些特殊处理。

### 读写分离

+ 读写分离的本质是对数据库进行集群，这样就可以在高并发的情况下将数据库的操作分配到多个数据库服务器去处理从而降低单台服务器的压力。
+ 由于数据库的特殊性，每台服务器所保存的数据都需要一致。所以数据同步就成了数据库集群中最核心的问题。

    + 一般情况下是将写操作交给专门的一台服务器处理，这台专门负责写的服务器叫做主服务器。当主服务器写入（增删改）数据后从底层同步到别的服务器（从服务器）
    + 主服务器向从服务器同步数据时，如果从服务器数量多，那么可以让主服务器先向其中一部分从服务器同步数据，第一部分从服务器收到数据后再向另外一部分同步。

+ 简单的数据同步方式可以采用数据库的热备份功能，不过读取到的数据可能会存在一定的滞后性。
+ 高级的方式需要使用专门的软硬件配合。另外既然是集群就涉及负载均衡问题，负载均衡和读写分离的操作一般采用专门程序处理，而且对应用系统来说是透明的。

### 分布式数据库

+ 分布式数据库是将不同的表存放到不同的数据库中然后再放到不同的服务器。
+ 这样在处理请求时，如果需要调用多个表，则可以让多个请求分配到不同的服务器处理。
+ 数据库集群（读写分离）的作用是将多个请求分配到不同的服务器处理，从而减轻单台服务器的压力，而分布式数据库是解决单个请求本身就非常复杂的问题，它可以将单个请求分配到多个服务器处理，使用分布式后的每个节点还可以同时使用读写分离，从而组成多个节点群。

+ 分布式数据库有很多复杂的问题需要解决，如事务处理，多表查询。
+ 分布式另一种使用的思路是将不同业务的数据表保存到不同的节点，让不同的业务调用不同的数据库，这种用法其实是和集群一样起分流的作用，不过这种情况就不需要同步数据了。

### NoSQL 和 Hadoop

+ NoSQL 核心就是非结构化。
+ NoSQL 通过多个块存储数据的特点，其操作大数据的速度也非常快。

+ Hadoop 对数据的存储和处理都提供了相应的解决方案，底层数据的存储思路类似于分布式加集群的方案。
+ Hadoop 是将同一个表中的数据分成多块保存到多个节点（分布式），而且每个块数据都有多个节点保存（集群）。
+ Hadoop 对数据的处理是先对每一块的数据找到相应的节点并进行处理，然后再对每一个处理结果进行处理，最后生成最终的结果。

## 高并发的解决方案

### 应用和静态资源分离

+ 刚开始的时候应用和静态资源是保存在一起的，当并发量达到一定程度时就需要将静态资源保存到专门的服务器中，静态资源主要包括图片，视频，js，css 和 一些资源文件等。
+ 这些文件没有状态，所以分离比较简单，直接存放到相应的服务器就可以了，一般会使用专门的域名去访问。通过不同的域名可以让浏览器直接访问资源服务器而不需要再访问应用服务器。

### 页面缓存

+ 页面缓存是将应用生成的页面缓存起来，这样就不需要每次都重新生成页面了。
+ 页面缓存的默认失效机制一般是按缓存时间处理的，当然也可以在修改数据之后手动相应缓存实效。

+ 页面缓存主要是使用在数据很少发生变化的页面中，但是有很多页面是大部分数据都很少变化，而其中有很少一部分数据变化的频率却非常高。

    + 可以先静态页面然后使用 Ajax 来读取并修改相应的数据。

### 集群与分布式

+ 集群和分布式处理都是使用多台服务器进行处理的。
+ 集群是每台服务器都具有相同的功能，处理请求时调用哪台服务器都可以，主要起分流的作用
+ 分布式是将不同的业务放到不同的服务器中，处理一个请求可能需要用到多台服务器。

+ 集群有两种方式

    + 静态资源集群
    + 应用程序集群

        + 应用程序在处理中可能会使用到一些缓存的数据，如果集群就需要同步这些数据，其中最重要的就是 Session ，Session 同步也是应用程序集群中非常核心的一个问题。

        + Session 同步有两种处理方式

            + 在 Session 发生变化后自动同步到其他服务器
            + 另外一种方式用一个程序统一管理 Session

        + 所有集群的服务器都使用一个 Session ，Tomcat 默认使用的就是第一种方式，通过简单的配置就可以实现。
        + 第二种方式可以使用专门的服务器安装 Memcached 等高效的缓存程序来统一管理 Session，然后在应用程序中通过重写 Request 并覆盖 getSession 方法来获取指定服务器中的 Session.

+ 对于集群来说还有一个核心问题就是负载均衡，也就是接受到一个请求后具体分配到哪个服务器去处理的问题，可以通过软件处理也可以使用专门的硬件解决。

+ 一个思路简单解决 Session 同步的问题，Session 需要同步的本质原因就是要使用不同的服务器给同一个用户提供服务，如果负载均衡在分配请求时可以将同一个用户（如按 IP ）分配到同一个服务器进行处理也就不需要 Session 同步了。
+ 考虑到稳定性，为了防止有机器宕机后丢失数据还可以将集群的服务器分成多个组，然后在小范围的组（如2，3台服务器）内同步 Session

### 反向代理

+ 反向代理指的是客户端直接访问的服务器并不真正提供服务，它从别的服务器获取资源然后将结果返回给用户的。

+ 反向代理服务器和代理服务器的区别

    + 代理服务器的作用是代我们获得想要的资源然后将结果返回给我们，所要获取的资源是我们主动告诉代理服务器的
    + 反向代理服务器是我们正常访问一台服务器的时候，服务器自己调用了别的服务器的资源并将结果返回给我们。
    + 代理服务器是我们主动使用的，是为我们服务的，它不需要有自己的域名。反向代理服务器是服务器自己使用的，我们并不知道，它有自己的域名，我们访问它跟访问正常的网址没有任何区别。

+ 反向代理服务器可以和实际处理请求的服务器在同一个主机上，而且一台反向代理服务器也可以访问多台实际处理请求的服务器。
+ 反向代理服务器主要作用有三个作用

    + 可以作为前端服务器跟实际处理请求的服务器（如 Tomcat）集成
    + 可以用做负载均衡
    + 转发请求

### CDN

+ CDN 其实是一种特殊的集群页面缓存服务器，它和普通集群的多台页面缓存服务器比主要是它存放的位置和分配请求的方式有点特殊。
+ CDN 的服务器是分布在全国各地的，当接受到用户的请求后会将请求分配到最合适的 CDN 服务器节点获取数据。

+ CDN 的每个节点其实就是一个页面缓存服务器，如果没有请求资源的缓存就会从主服务器获取，否则直接返回缓存的页面。
+ 一般的做法是在 ISP （Internet Service Provider） 那里使用 CNAME 将域名解析到一个特定的域名，在将解析到的那个域名用专门的 CDN 服务器解析到相应的 CDN 节点。

+ 访问 CDN 的 DNS 服务器是因为 CNAME 记录的目标域名使用 NS 记录指向了 CDN 的 DNS 服务器。

## 底层的优化

## 小结

+ 网站架构的整个演变过程主要是围绕大数据和高并发者两个问题展开的，解决方案主要分为使用缓存和使用多资源两种类型。
+ 多资源主要指多存储（包括多内存），多 CPU 和多网络
+ 对于多资源来说又可以分为单个资源处理一个完整的请求和多个资源合作处理一个请求。如多存储和多 CPU 中的集群和分布式，多网络中的 CDN 和静态资源分离。

# 常见协议和标准

## DNS 协议

+ DNS 协议的作用是将域名解析为 IP
+ 域名和 IP 的对应关系经常变化，所以就需要专门将域名解析为 IP 的服务器。（DNS 服务器）

## TCP/IP 协议 与 Socket

+ IP 协议是用来查找地址的，对应着网际互联层，TCP 协议是用来规范传输规则的，对应着传输层。
+ TCP 在传输之前会进行三次沟通，一般称为“三次握手”，传完数据断开的时候要进行四次沟通，一般称为“四次握手”。
+ TCP 中的两个序号和三个标志位

    + seq sequence number 表示所传数据的序号。TCP 传输时每一个字节都有一个序号，发送数据时会将数据的第一个序号发送给对方，接收方会按序号检查是否接受完整了，如果没接受完整就需要重新传送，这样就可以保证数据的完整性。
    + ack acknoledgement number 表示确认号。接收端用它来给发送端反馈已经成功接收到的数据信息的，它的值为希望接受的下一个数据包起始序号，也就是 ack 值所代表的序号前面数据已经成功接收到了。
    + ACK 确认位，只有 ACK=1 的时候 ack 才起作用。正常通信时 ACK 位 1，第一次发起请求因为没有需要确认接收的数据所以 ACK 为 0
    + SYN 同步位，用于建立连接时同步序号。刚开始建立连接时并没有历史接收的数据，所以 ack 也就没办法设置，这时按照正常的机制就无法运行了，SYN 作用就是来解决这个问题的，当接收端接收到 SYN=1 的报文时就会直接将 ack 设置为接收到的 seq + 1 的值，注意这里的值并不是校验后设置的，而是根据 SYN 直接设置的，这样正常的机制就可以运行了，所以 SYN 叫同步位。

        + SYN 会在前两次握手时都为 1 ，这是因为通信的双方的 ack 都需要设置一个初始值。

    + FIN 终止位，用来在数据传输完毕后释放连接。

### 缺点

+ 传输效率上会比较低。
+ 三次握手的过程中客户端需要发送两次数据才可以建立连接。（DDOS 攻击中的 SYN Flood 攻击）

### UDP

+ TCP 是有连接的，UDP 是没有连接的，也就是说 TCP 协议是在沟通好后才会传数据，而 UDP 协议是拿到地址后直接传了。
+ TCP 协议传输的数据更可靠，而 UDP 传输的速度更快。

+ HTTP 协议的底层传输默认使用可靠的 TCP 协议。
+ TCP/IP 协议只是一套规则，就像程序中的接口一样，而 Socket 是 TCP/IP 协议 的一个具体实现。

## HTTP 协议

+ HTTP 协议是应用层的协议，在 TCP/IP 协议接收到的数据之后需要通过 HTTP 协议来解析才可以使用。
+ HTTP 协议中的报文结构非常重要。
+ HTTP 中报文分为请求报文（request message）和响应报文（response message）
+ 报文
    + 首行
        + 请求报文的首行是请求行，包括方法（请求类型），URL 和 HTTP 版本
        + 响应请求的首行是状态行包括方法（请求类型），URL和 HTTP 版本
    + 头部
        + 保存一些键值对。用冒号分割
    + 主体
        + 保存具体内容
        + 请求报文中主要保存 POST 类型的参数
        + 响应报文中保存页面要显示的结果

+ 首行，头部和主体以及头部的各项内容用回车换行（\r\n）分割，另外头部和主体之间多一个空行，也就是两个连续的空行。

+ 请求报文中的方法指 GET，HEAD，POST，PUT，DELETE 等类型。
+ 响应报文中的状态码就是 Response 中 status，分为 5 类

    + 1XX：信息性状态码
    + 2XX：成功状态吗，如 200 表示成功
    + 3XX：重定向状态吗，如 301 表示重定向
    + 4XX：客户端错误状态码，如 404 表示没找到请求的资源
    + 5XX：服务端错误状态码，如 500 表示内部错误

## Servlet 和 Java Web 开发

+ Servlet 是 J2EE 标准的一部分，是 Java Web 开发的标准。
+ Servlet 的作用是对接收到的数据进行处理并生成要返回给客户端的结果。
+ 要想使用 Servlet 需要有相应的 Servlet 容器才行。

# DNS 的设置

+ 在自己电脑设置域名和 IP 的对应关系（hosts 文件中）
+ 设置格式是 “IP + 空格 + 域名” 一行一条记录，空格可以有多个。
+ 做测试的时候可以使用 hosts 文件的设置来模拟实际主机。

# Java 中 Socket 的用法

+ Java 中的 Socket 可以分为普通 Socket 和 NioSocket 两种。

## 普通的 Socket 的用法

+ Java 中的网络通信是通过 Socket 实现的，Socket 分为 ServerSocket 和 Socket 两大类。
+ ServerSocket用于服务端，可以通过 accept 方法（阻塞方法）监听请求，监听到请求后返回 Socket，Socket 用于具体完成数据传输，客户端直接使用 Socket 发起请求并传输数据。

```Java
// sever
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;

public class Server
{
    public static void main(String[] args)
    {
        try
        {
            ServerSocket server = new ServerSocket(8080);
            Socket socket = server.accept();
            BufferedReader is = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            String line = is.readLine();
            System.out.println("received from client:" + line);

            PrintWriter pw = new PrintWriter(socket.getOutputStream());
            pw.println("received data:" + line);
            pw.close();
            is.close();
            socket.close();
            server.close();

        } catch (Exception e)
        {
            e.printStackTrace();
        }
    }
}

// Client
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

public class Client
{
    public static void main(String[] args)
    {
        String msg = "Client Data";
        try
        {
            Socket socket = new Socket("127.0.0.1", 8080);
            PrintWriter pw = new PrintWriter(socket.getOutputStream());
            BufferedReader is = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            pw.println(msg);
            pw.flush();
            String line = is.readLine();
            System.out.println("received from server:" + line);
            pw.close();
            is.close();
            socket.close();

        } catch (Exception e)
        {
            e.printStackTrace();
        }
    }
}
```

## NioSocket 的用法

+ 从 JDK1.4 开始，Java 增加了新的 io 模式 - nio（new IO），nio 在底层采用了新的处理方式，极大地提高了 IO 的效率。
+ nio 提供了相应的工具：ServerSocketChannel 和 SocketChannel。
+ NioSocket : Buffer, Channel 和 Selector

+ NioSocket 中服务端端处理过程可以分为 5 步：

    + 创建 ServerSocketChannel 并设置相应参数
    + 创建 Selector 并注册到 ServerSocketChannel 上
    + 调用 Selector 的 select 方法等待请求
    + Selector 接收到请求后使用 selectedKeys 返回 SelectionKey 集合
    + 使用 SelectionKey 获取到 Channel ，Selector 和操作类型并进行具体操作。

    ```Java
    import java.io.IOException;
    import java.net.InetSocketAddress;
    import java.nio.ByteBuffer;
    import java.nio.channels.SelectionKey;
    import java.nio.channels.Selector;
    import java.nio.channels.ServerSocketChannel;
    import java.nio.channels.SocketChannel;
    import java.nio.charset.Charset;
    import java.util.Iterator;

    public class NIOServer
    {
        public static void main(String[] args) throws Exception
        {
            ServerSocketChannel ssc = ServerSocketChannel.open();
            ssc.socket().bind(new InetSocketAddress(8080));

            // 设置非阻塞模式
            ssc.configureBlocking(false);

            // 为 ssc 注册选择器
            Selector selector = Selector.open();
            ssc.register(selector, SelectionKey.OP_ACCEPT);

            // 创建处理器
            Handler handler = new Handler(1024);
            while (true)
            {
                // 等待请求，每次等待阻塞 3s，超过 3s 后线程继续向下运行。
                // 如果传入 0 或者不传参数将一直阻塞
                if (selector.select(3000) == 0)
                {
                    System.out.println("等待请求超时……");
                    continue;
                }
                System.out.println("处理请求......");

                // 获得待处理的 SelectionKey
                Iterator<SelectionKey> keyIter = selector.selectedKeys().iterator();

                while (keyIter.hasNext())
                {
                    SelectionKey key = keyIter.next();
                    try
                    {
                        // 接收到连接请求时
                        if (key.isAcceptable())
                        {
                            handler.handleAccept(key);
                        }

                        // 读数据
                        if (key.isReadable())
                        {
                            handler.handleRead(key);
                        }
                    } catch (IOException ex)
                    {
                        keyIter.remove();
                        continue;
                    }
                    keyIter.remove();
                }
            }
        }

        private static class Handler
        {
            private int bufferSize = 1024;
            private String localCharset = "UTF-8";

            public Handler(int bufferSize)
            {
                this(bufferSize, null);
            }

            public Handler(String localCharset)
            {
                this(-1, localCharset);
            }

            public Handler(int bufferSize, String localCharset)
            {
                this.bufferSize = bufferSize;
                this.localCharset = localCharset;
            }

            public void handleAccept(SelectionKey key) throws IOException
            {
                SocketChannel sc = ((ServerSocketChannel) key.channel()).accept();
                sc.configureBlocking(false);
                sc.register(key.selector(), SelectionKey.OP_READ, ByteBuffer.allocate(bufferSize));
            }

            public void handleRead(SelectionKey key) throws IOException
            {
                // 获取 channel
                SocketChannel sc = (SocketChannel) key.channel();
                // 获取 buffer 并重置
                ByteBuffer buffer = (ByteBuffer) key.attachment();
                buffer.clear();

                if (sc.read(buffer) == -1)
                {
                    sc.close();
                } else
                {
                    // 将 buffer 转换为读状态
                    buffer.flip();
                    String receivedString = Charset.forName(localCharset).newDecoder().decode(buffer).toString();
                    System.out.println("received from client:" + receivedString);

                    // 返回数据给客户端
                    String sendString = "received data:" + receivedString;
                    buffer = ByteBuffer.wrap(sendString.getBytes(localCharset));
                    sc.write(buffer);
                    sc.close();
                }
            }
        }
    }

    ```

+ SelectionKey

    + SelectionKey.OP_ACCEPT    接收请求操作
    + SelectionKey.OP_CONNECT   连接操作
    + SelectionKey.OP_READ      读操作
    + SelectionKey.OP_WRITE     写操作

+ 通过 SelectionKey 的 channel 方法和 selector 方法来获取对应的 Channel 和 Selector，可以通过 isAcceptable, isConnectable, isReadable, isWritable 方法来判断是什么类型的操作。

+ main 方法启动监听，当监听到请求时根据 SelectionKey 的状态交给内部类 Handler 进行处理，Handler 可以通过重载的构造方法设置编码格式和每次读取数据的最大值。
+ Handler 处理过程中用到了 Buffer,Buffer 是 java.nio 包中的一个类，专门用于存储数据，Buffer 里有 4 个属性非常重要。

    + capacity 容量，也就是 Buffer 最多可以保存元素的数量，在创建时设置，使用过程中不可改变。
    + limit 可以使用的上限，开始创建时设置 limit 和 capacity 相同，limit 就成了最大可以访问的值，其值不可以超过 capacity。
    + position 当前所操作元素所在的索引位置，position 从 0 开始，随着 get 和 put 方法自动更新。
    + mark 用来暂时保存 position 的值，position 保存到 mark 后就可以修改并进行相关相关的操作，操作完后可以通过 reset 方法将 mark 的值恢复到 position。

        + mark 默认值为 -1 而且其值必须小于 position 的值。
        + Buffer#position(int new Position)时传入的 new Position 比 mark 小则会 mark 设为 -1

    + 大小关系 mark <= position <= limit <= capacity

+ NioServer

    + clear() 重新初始化 limit，position 和 mark

    ```Java
    public final Buffer clear()
    {
        position = 0;
        limit = capacity;
        mark = -1;
        return this;
    }
    ```

    + flip() 读取保存的数据

    ```Java
    public final Buffer flip()
    {
        limit = position;
        position = 0;
        mark = -1;
        return this;
    }
    ```

# 自己动手实现 HTTP 协议

```Java
import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.nio.charset.Charset;
import java.util.Iterator;

public class HttpServer
{
    public static void main(String[] args) throws Exception
    {
        ServerSocketChannel ssc = ServerSocketChannel.open();
        ssc.socket().bind(new InetSocketAddress(8080));
        ssc.configureBlocking(false);

        Selector selector = Selector.open();
        ssc.register(selector, SelectionKey.OP_ACCEPT);
        while (true)
        {
            if (selector.select(3000) == 0)
            {
                continue;
            }

            Iterator<SelectionKey> keyIter = selector.selectedKeys().iterator();

            while (keyIter.hasNext())
            {
                SelectionKey key = keyIter.next();
                new Thread(new HttpHandler(key)).run();
                keyIter.remove();
            }
        }

    }

    private static class HttpHandler implements Runnable
    {
        private int bufferSize = 1024;
        private String localCharset = "UTF-8";
        private SelectionKey key;

        public HttpHandler(SelectionKey key)
        {
            this.key = key;
        }

        public void handleAccept() throws IOException
        {
            SocketChannel clientChannel = ((ServerSocketChannel) key.channel()).accept();
            clientChannel.configureBlocking(false);
            clientChannel.register(key.selector(), SelectionKey.OP_READ, ByteBuffer.allocate(bufferSize));
        }

        public void handleRead() throws IOException
        {
            SocketChannel sc = (SocketChannel) key.channel();
            ByteBuffer buffer = (ByteBuffer) key.attachment();
            buffer.clear();

            if (sc.read(buffer) == -1)
            {
                sc.close();
            } else
            {
                buffer.flip();
                String receivedString = Charset.forName(localCharset).newDecoder().decode(buffer).toString();
                String[] requestMessage = receivedString.split("\r\n");
                for (String s : requestMessage)
                {
                    System.out.println(s);
                    if (s.isEmpty())
                    {
                        break;
                    }
                }
                String[] firstLine = requestMessage[0].split("");
                System.out.println();
                System.out.println("Method:\t" + firstLine[0]);
                System.out.println("url:\t" + firstLine[1]);
                System.out.println("HTTP Version:\t" + firstLine[2]);
                System.out.println();

                // 返回客户端
                StringBuilder sendString = new StringBuilder();
                sendString.append("HTTP/1.1 200 OK\r\t");
                sendString.append("Content-Type:text/html;charset=" + localCharset + "\r\n");
                sendString.append("\r\n");

                sendString.append("<html><head><title>显示报文</title></head><body>");
                sendString.append("接收到请求报文是：<br/>");
                for (String s : requestMessage)
                {
                    sendString.append(s + "<br/>");
                }
                sendString.append("</body><html>");
                buffer = ByteBuffer.wrap(sendString.toString().getBytes(localCharset));
                sc.write(buffer);
                sc.close();
            }
        }

        @Override
        public void run()
        {
            try
            {
                if (key.isAcceptable())
                {
                    handleAccept();
                }

                if (key.isReadable())
                {
                    handleRead();
                }
            } catch (IOException e)
            {
                e.printStackTrace();
            }
        }
    }
}
```

+ 流类型只需要在响应报文中写清楚 Content-Type 的类型，并将响应数据写入报文的主体就可以了。

# 详解 Servlet

+ Servlet 是 Server + Applet 的缩写，表示一个服务器应用。
+ Servlet 其实就是一套规范。我们按照这套规范写的代码可以直接在 Java 的服务器上面运行。
+ Servelt3.1

    ```Java
    Interface ServletConfig
    Interface Servlet
    ⇡⇡
    Class GenericServlet
    ↑
    Class HttpServlet
    ```

## Servlet 接口

+ Servlet 3.1

    ```Java
    // javax.servlet.Servlet
    public interface Servlet
    {
        public void init(ServletConfig) throws ServletException;
        public ServletConfig getServletConfig();
        public void service(ServletRequest req, ServletResponse res) throws ServletException, IOException;
        public String getServletInfo();
        public void destroy();
    }

    // init 方法在容器启动时被容器调用（当 load-on-startup 设置为负数或者不设置会在 Servlet 第一次用到时才被调用 ）只会调用一次。
    // getConfig 方法用于获取 ServletConfig
    // service 方法用于具体处理一个请求
    // getServletInfo 方法可以获取一些 Servlet 相关的信息，如作者，版权等，这个方法需要自己实现，默认返回空字符串。
    // destroy 主要用于在 Servlet 销毁（一般指关闭服务器）时释放一些资源，也只会调用一次。
    ```

+ Init 方法被调用时会接收到一个 SerlvetConfig 类型的参数，是容器传进去的。
+ ServletConfig 指的是 Serlvet 的配置，我们在 web.xml 中定义 Servlet 时通过 init-param 标签配置的参数就是通过 ServletConfig 来保存的

    ```XML
    <servlet>
        <servlet-name>demoDispathcher</>
        <servlet-class>org.springframework.web.servlet.DispathcherServlet</serlvet-class>
        <init-param>
            <param-name>contextConfigLocation</>
            <param-value>demo-servlet.xml</>
        </>
        <load-on-startup>1</>
    </servlet>
    ```

+ ServletConfig 接口定义

    ```Java
    public interface ServletConfig
    {
        public String getServletName();
        public ServeltContext getServletContext();
        public String getInitParamter(String name);
        public Enumeration<String> getInitParamterNames();
    }
    ```

+ ServletContext 其实就是 Tomcat 中 Context 的门面类 ApplicationContextFacade。既然 ServletContext 代表应用本身，那么 SerlvetContext 里面设置的参数就可以被当前应用的所有 Servlet 共享了。
+ 做项目的时候都知道参数可以保存在 Session 中，也可以保存在 Application  中，而后者很多时候就是保存在了 ServletContext 中。
+ ServletConfig 是 Servlet 级的，而 ServleteContext 是 Context （也就是 Application ）级的。

+ ServletConfig 和 ServletContext 最常见的使用之一是传递初始化参数。

```XML
//web.xml
<display-name>initParam Demo</>
<context-param>
    <param-name>contextConfigLocation</>
    <param-value>application-context.xml</>
</>
<servlet>
    <servlet-name>DemoServlet</>
    <servlet-class>com.excelib.DemoServlet</>
    <init-param>
        <param-name>contextConfigLocation</>
        <param-value>demo-servlet.xml</>
    </>
</>

// 获取
String contextLocation = getServletConfig().getServletContext().getInitParamter("contextConfigLocation");
String servletLocation = getServletConfig().getInitParameter("contextConfigLocation");
```

+ GenericServlet 定义了 getInitParameter 方法，内部返回 getServletConfig().getInitParamter 的返回值。

```Java
// ServletContext - 保存 Application 级的属性
getServletContext().setAttribute("contextCongfigLocation", "new path");

// 需要注意的是，这里设置的同名 Attribute 并不会覆盖 initParameter 中的参数值，它们是两套数据，互不干扰。
// ServletConfig 不可以设置属性。
```

## GenericServlet

+ GenericServelt 是 Servet 的默认实现

    + 实现了 ServletConfig 接口，我们可以直接调用 ServletConfig 里面的方法
    + 提供了无参的 init 方法
    + 提供了 log 方法

```Java
public ServletContext getServletContext()
{
    ServletConfig sc = getServletConfig();
    if(sc == null)
    {
        throw new IllegalStateException(1Strings.getString("err.servlet_config_not_initialized"));
    }
    return sc.getServletContext();
}

public void init(ServletConfig config) throws ServletException
{
    this.config = config;
    this.init();
}
public void init() throws ServletException{} // 模版方法，在子类可以通过覆盖它来完成自己的初始化工作。
```

+ GenericServlet 提供了两个 log 方法，一个记录日志，一个记录异常。

```Java
public void log(String msg)
{
    getServletContext().log(getServletName() + ": " + msg);
}
public void log(String message, Throwable t)
{
    getServletContext().log(getServletName() + ": " + message, t);
}
```

+ GenericServlet 是与具体协议无关的。

## HttpServlet

+ HttpServlet 是用于 HTTP 协议实现的 Servlet 的基类。
+ DispatcherServlet 就是继承的 HttpServlet

```Java
protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException
{
    String protocol = req.getProtocol();
    String msg = 1Strings.getString("http.method_get_not_supported");

    if(protocol.endsWith("1.1"))
    {
        resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, msg);
    } else
    {
        resp.sendError(HttpServletResponse.SC_BAD_REQUEST, msg);
    }
}
```

# Tomcat 分析

## Tomcat 的顶层结构及启动过程

### Tomcat 的顶层结构

+ Complex

# 俯视 Spring MVC

+ 分析源码

    + 分析Spring MVC 是怎么创建出来的
    + 分析它是怎么干活的

## 环境搭建

```XML
<dependency>
    <groupId>java.servlet</>
    <artifactId>javax.servlet-api</>
    <version>3.1.0</>
    <scope>provided</>
</dependency>
<dependency>
    <groupId>org.springframework</>
    <artifactId>spring-webmvc</>
    <version>4.1.5.RELEASE</>
</dependency>
```

## Spring MVC 最简单的配置

+ 在 web.xml 中配置 Serlet
+ 创建 Spring MVC 的 xml 配置文件
+ 创建 Controller 和 view

### 在 web.xml 中配置 Servlet

```XML
<servlet>
    <servlet-name>let'sGo</>
    <servlet-class>org.springframework.web.servlet.DispatherServlet</>
    <load-on-startup></>
</>

<servlet-mapping>
    <servlet-name>let'sGo</>
    <url-pattern>/</>
</>

<welcome-file-list>
    <welcome-file>index</welcome-file>
</>
```

+ 所配置的 Servlet 是 DispatcherServlet 类型，它就是 Spring MVC 的入口，Spring MVC 的本质就是一个 Servlet。
+ 在配置 DispatcherServlet 的时候可以设置 contextConfigLocation 参数来指定的 SpringMVC 配置文件的位置，如果不指定就默认使用 WEB-INF/[ServletName]-servlet.xml 文件
+ 这里使用了默认值，就是 WEB-INF/let'sGo-servlet.xml 文件

### 创建 Spring MVC 的 xml 配置文件

```XML
// let'sGo-servlet.xml
<beans xmlns="">
    <mvc:annotation-driven/> // 配置后，Spring MVC 会帮我们自动做一些注册组件之类的事
    <context:component-scan base-package="com.excelib"/> // 扫描通过注册配置的类

    //  或者设置 context:include-filter 子标签来设置只扫描 @Controller 就可以
    <context:component-scan base-package="com.excelib" use-default-filters="false">
        <context:include-filter type="annotation" expression="org.springframework.stereotype.Controller">
    </>
</beans>
```

### 创建 Controller 和 View

```Java
package com.excelib.controller;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class GoController
{
    private final Log logger = LogFactory.getLog(GoController.class);

    @RequestMapping(value = {"/"}, method = {RequestMethod.HEAD})
    public String head()
    {
        return "go.jsp";
    }

    @RequestMapping(value = {"/index", "/"}, method = {RequestMethod.GET})
    public String index(Model model) throws Exception
    {
        logger.info("===== processed by index======");
        model.addAttribute("msg", "Go Go Go!");
        return "go.jsp";
    }
}

```

+ 这里单独写了处理 HEAD 请求的方法，此方法可以用来检测服务器的状态，因为它不返回 body 所以比 GET 请求更节省网络资源。
+ 如果没有配置 ViewResolver ，Spring MVC 将默认使用 org.springframework.web.servlet.view.InternalResourceViewResolver 作为 ViewResolver。而且 prefix 和 suffix 都为空。

## 关联 spring 源代码

# 创建 Spring MVC 之器

## 整体结构介绍

```Java
interface Aware
⇡⇡⇡
interface EnvironmentCapable
interface EnvironmentAware
interface ApplicationContextAware
↑
class HttpServletBean(implements HttpServlet,EnvironmentCapable, EnvironmentAware)
↑
class FrameworkServlet(extends HttpServletBean implements ApplicationContextAware)
↑
class DispatcherServlet(implements DispatcherServlet)
```

+ HttpServletBean StardServleteEnvironment
    + propertySources

        + ServletConfigPropertySource // 封装了 ServletConfig
        + ServletContextPropertySource // 保存的是 ServletContext
        + JndiPropertySource // 存放的时 Jndi
        + MapPropertySource // 虚拟机的属性
        + SystemEnvironmentPropertySource // 环境变量

## HttpServletBean

```Java
initBeanWrapper(bw);
bw.setPropertyValues(pbs, true);

// 模版方法。子类初始化的入口方法
initServletBean();
```

+ 在 HttpServletBean 的 init 中，首先将 Servlet 中配置的参数使用 BeanWrapper 设置到 DispatcherServlet 的相关属性，然后调用模版方法 initServletBean，子类就通过这个方法初始化。

+ BeanWrapper 是 Spring 提供的一个用来操作 JavaBean 属性的工具，使用它可以直接修改一个对象的属性。

## FrameworkServlet

```Java
this.webApplicationContext = initWebApplicationContext(); // 初始化 WebApplicationContext
initFrameworkServlet(); // 模版方法
```

+ 可见 FrameworkServlet 在构建中的过程中主要作用就是初始化了 WebApplicationContext。

+ initWebApplicationContext 方法做了三件事

    + 获取 spring 的根容器 rootContext
    + 设置 webApplicationContext 并根据情况调用 onRefresh 方法

        + webApplicationContext 三种方法

            + 在构造方法中已经传递 webApplicationContext 参数，这时只需要对其进行一些设置
            + webApplicationContext 已经在 ServletContext 中。（web.xml 配置 init-param）
            + 前面两种方式都无效的情况下自己创建一个。

    + 将 webApplicationContext 设置到 ServletContext 中。

        + `init-param` 参数

            + `contextAttribute`: 在 ServletContext 的属性中，要用作 WebApplicationContext 的属性名称
            + `contextClass`: 创建 WebApplicationContext 的类型
            + `contextConfigLocation`: Spring MVC 配置文件的位置
            + `publishContext`: 是否将 webApplicationContext 设置到 ServletContext 的属性

## DispatcherServlet

+ `onRefresh` 方法是 DispatcherServlet 的入口方法。

```Java
// org.springframework.web.servlet.DispatcherSerlvlet
protected void onRefresh(ApplicationContext contexrt)
{
    initStrategies(context);
}

protected void initStrategies(ApplicationContext context)
{
    initMultipartResolver(context);
    initLocaleResolver(context);
    initThemeResolver(context);
    initHandlerMappings(context);
    initHandlerAdapters(context);
    initHandlerExceptionResolvers(context);
    initRequestToViewNameTranslator(context);
    initViewResolvers(context);
    initFlashMapManager(context);
}

// 分层的原因
// onRefresh 是用来刷新容器的
// initStrategies 用来初始化一些策略组件
// initStrategies 直接写到 onRefresh 中
//      如果在 onRefresh 中想要再添加别的功能，就会没有将其单独写一个方法出来的逻辑清晰。
//      单独将 initStrategies 写出来还可以被子类覆盖，使用新的模式进行初始化。
```

+ LocalResolver

```Java
private void initLocaleResolver(ApplicationContext context)
{
    try
    {
        this.localeResolver = (LocaleResolver)context.getBean("localeResolver", LocaleResolver.class);

        if(logger.isDebugEnabled()) {...}
    }
    catch (NoSuchBeanDefinitionException ex)
    {
        // 使用默认策略
        this.localResolver = getDefaultStrategy(context, LocalResolver.class);
        if(logger.isDebugEnabled()) {...}
    }
}

getDefaultStrategy
    getDefaultStrategies
        ClassUtils.forName(className, DispatcherServlet.class.getClassLoader());
            defaultStrategies.getProperty(key);

            static {
                try {
                    ClassPathResource resource = new ClassPathResource("DispatcherServlet.properties", DispatcherServlet.class);
                    defaultStrategies = PropertiesLoaderUtils.loadProperties(resource);
                } catch (IOException var1) {
                    throw new IllegalStateException("Could not load 'DispatcherServlet.properties': " + var1.getMessage());
                }
            }

DispatcherServlet.properties // 存放 8 个组件
```

+ DispatcherServlet 的创建过程主要是对 9 大组件进行初始化。

## 解析 spring 的 xml 文件中通过命名空间配置的标签。

```Java
// 解析配置的接口
NamespaceHandler
⇡⇡⇡
NamespaceHandlerSupport // 默认实现
SimplePropertyNamespaceHandler // 用于统一对通过 c: 配置的构造方法进行解析
SimpleConstructorNamespaceHandler // 用于统一对通过 p: 配置的参数进行解析
↑
MvcNamespaceHandler(extends NamespaceHandlerSupport)
```

### NamespaceHandler

    + `init` 用来初始化自己的
    + `parse` 用于将配置的标签转换成 spring 所需要的 BeanDefinition
    + `decorate` 方法的作用是对所在 BeanDefinition 进行一些修改

### NamespaceHandlerSupport

+ `NamespaceHandlerSupport` 并没有做具体的解析工作，而是定义了三个处理器

    + parsers 处理解析工作
    + decorators 处理标签类型
    + attributeDecorators 处理属性类型的装饰

+ `parse` 和 `decorate` 方法的执行方式是先找到相应的处理器，具体的处理器由子类实现，然后注册到 `NamespaceHandlerSupport` 上面。
+ 所以要定义一个空间的解析器，只需要在 init 中定义相应的 parsers, decorators, attributeDecorators 并注册到 NamespacehandlerSupport 上面。

### MvcNamespaceHandler

+ 看到 mvc 命名空间使用到的所有解析器，其中解析 “annotation-driven” 的是 `AnnotationDrivenBeanDefinitionParser`

## 小结

+ `Spring MVC` 中 `Servlet` 一共有三个层次，分别是

    + `HttpServletBean` (extends HttpServlet) // 将 Servlet 中配置的参数设置到相应的属性
    + `FrameworkServlet` // 初始化了 WebApplicationContext
    + `DispatcherServlet` // DispatcherServlet 初始化了自身的 9 个组件

+ spring 的特点：结构简单，实现复杂。结构简单主要是顶层设计好，实现复杂的主要是提供的功能比较多，可配置的地方也非常多。

# Spring MVC 之用

+ 分析 Spring MVC 是怎么处理请求的。

    + 分析 HttpServletBean, FrameworkServlet 和 DispatcherServlet 这三个 Servlet 的处理过程。
    + 再重点分析 Spring MVC 中最核心的处理方法 doDispatch 的结构。

## HttpServletBean

+ HttpServletBean 主要参与了创建工作，并没有涉及请求的处理。

## FrameworkServlet

+ Spring MVC 对将不同类型的请求的支持非常好。
+ processRequest 是 FrameworkServlet 类在处理请求中最核心的方法。

    + 核心语句是 doService(request, response)，是一个模版方法，在 DispatcherServlet 中具体实现。
    + 做了两件事

        + 对 LocaleContext 和 RequestAttributes 的设置及恢复
        + 处理完后发布了 ServletHandledEvent 消息

### LocaleContext

+ 存放着 Locale （也就是本地化信息，zh-cn 等）

### RequestAttributes

+ RequestAttributes 是一个接口。这里具体使用的是 ServletRequestAttributes 类，这里封装了 request, response 和 session。

```Java
// org.springframework.web.context.request.ServletRequestAttributes
public void setAttribute(String name, Object value, int scope) {
   if(scope == 0) {
       if(!this.isRequestActive()) {
           throw new IllegalStateException("Cannot set request attribute - request is not active anymore!");
       }

       this.request.setAttribute(name, value);
   } else {
       HttpSession session = this.getSession(true);
       this.sessionAttributesToUpdate.remove(name);
       session.setAttribute(name, value);
   }

}
```

+ 管理 request 和 session 的属性

### LocaleContextHolder

+ 这是一个 abstract 类，不过里面的方法都是 static 的，可以直接调用，而且没有父类也没有子类。也就是说我们不能对它实例化，只能调用其定义的 static 方法。这种 abstract 的使用方式也值得我们学习。
