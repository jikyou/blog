---
title: 第十四章 多线程
date: 2017-02-14 10:48:00 +0800
tags:
- Core Java Volume I
---

# 多线程

+ 多进程和多线程本质的区别在于每个进程拥有自己的一整套变量，而线程则共享数据。

## 中断线程

+ 强制线程终止的方法。（interrupt）

```Java
// Thread.currentThread()获取当前线程
while(!Thread.currentThread().isInterrupted() && more work to do)
{
    do more work
}
// 如果线程被阻塞，就无法检测中断状态
```

```Java
java.lang.Thread 1.0
void interrupt() //向线程发送中断请求。线程的中断状态将被设置为true。如果目前该线程被一个sleep调用阻塞，那么，InterruptedException异常被抛出
static boolean interrupted() // 测试当前线程是否被中断。静态方法。副作用：它将当前线程的中断状态重置为false
boolean isInterrupted() // 测试线程是否被终止。这一调用不改变线程的中断状态
static Thread currentThread() // 返回代表当前执行线程的Thread对象
```
## 线程状态

+ 线程的6种状态(getState方法确定线程的当前状态)

    + New (新创建)
    + Runnable (可运行)
    + Blocked (被阻塞)
    + Waiting (等待)
    + Timed waiting (计时等待)
    + Terminated (被终止)

### 可运行线程

+ 调度系统

    + 抢占式调度系统 （时间片，优先级）桌面以及服务器操作系统
    + 协作式调度系统 （一个线程只有在调用yield方法或者被阻塞或等待时，线程才失去控制权）

+ 在如何给定的时刻，一个可运行的线程可能正在运行也可能没有运行。

### 被阻塞线程和等待线程

### 被终止的线程

+ 终止原因

    + 因为run方法正常退出而自然死亡
    + 因为一个没有捕获的异常终止了run方法而意外死亡

```Java
void join() // 等待终止指定的线程
void join(long millis) // 等待指定的线程死亡或者经过指定的毫秒数。
Thread.State getState() 5.0 // 得到这一线程的状态；NEW, RUNNABLE, BLOCKED, WAITING, TIMED_WAITING或TERMINATED之一
```

## 线程属性

+ 线程优先级，守护线程，线程组以及处理未捕获异常的处理器

### 线程优先级

+ 一个线程继承它的父线程的优先级。
+ 线程优先级是高度依赖于系统的。当虚拟机依赖于宿主机平台的线程实现机制时，Java线程的优先级被映射到宿主机平台的优先级上。如：Windows有7个优先级。一些Java优先级将映射到相同的操作系统优先级。在Sun为Linux提供的Java虚拟机，线程的优先级别忽略-所有线程具有相同的优先级
+ 不要将程序构建为功能的正确性依赖于优先级

```Java
java.lang.Thread 1.0
void setPriority(int newPriority) // 设置线程的优先级一般使用Thread.NORM_PRIORITY优先级
static int MIN_PRIORITY // 线程的最小优先级。值为1
static int NORM_PRIORITY // 线程的默认优先级。默认优先级为5
static int MAX_PRIORITY // 线程的最高优先级。值为10
static void yield() 导致当前执行线程处于让步状态。如果有其他的可运行线程具有至少与线程同样高的优先级，那么这些线程接下来会被调度。
```

## 守护线程

```Java
java.lang.Thread 1.0
t.setDaemon(true); // 标识该线程为守护线程(daemon thread)或用户线程。
// 用途是为其他线程提供服务
```

### 未捕获异常处理器

+ 线程的run方法不能抛出任何被检测的异常，但是，不被检测的异常会导致线程终止。

+ 不需要任何catch子句来处理可以别传播的异常。在线程死亡之前，异常被传到一个用于捕获异常的处理器。该处理器必须实现Thread.UncaughtExceptionHandler接口的类。可以使用setUncaughtExceptionHandler 为任何线程安装一个处理器。
+ 也可以使用Thread类的静态方法setDefaultUncaughtExceptionHandler为所有线程安装一个默认的处理器。

+ 线程组是一个可以统一管理的线程集合。默认情况下，创建的所有线程属于相同的线程组。

+ ThreadGroup类实现Thread.UncaughtExceptionHandler接口。它的uncaughtException方法做法：

    + 如果改线程组有父线程组，那么父线程组的uncaughtException方法被调用。
    + 否则，如果Thread.getDefaultExceptionHandler方法返回一个非空的处理器，则调用该处理器
    + 否则，如果Throwable是ThreadDeath的一个实例，什么都不做。
    + 否则，线程的名字以及Throwable的栈踪迹被输出到System.err上。

```Java
java.lang.Thread 1.0
static void setDefaultUncaughtExceptionHandler(Thread.UncaughtExceptionHandler handler) 5.0
static ThreadUncaughtExceptionHandler getDefaultUncaughtExceptionHandler() 5.0
// 设置或获取为捕获异常的默认处理器
void setUncaughtExceptionHandler(Thread.UncaughtExceptionHandler handler) 5.0
// 设置或捕获异常的处理器。如果没有安装处理器，则将线程组对象作为处理器。

java.lang.Thread.UncaughtExceptionHandler 5.0
void uncaughtException(Thread t, Throwable e)
// 当一个线程因未捕获异常而终止，按规定要将客户报告记录到日志中。t：由于未捕获异常而终止的线程 e：未捕获的异常对象

java.lang.ThreadGroup 1.0
void uncaughtException(Thread t, Throwable e)
```

## 同步

+ 根据各线程访问数据的次序，可能会产生讹误的对象。称为竞争条件（race condition）
+ 同步存取
+ 查看类中每一个语句的虚拟机的字节码。`javap -c -v Bank`，对Bank.class文件进行反编译，重要的是增值命令是由几条指令组成的，执行它们的线程可以在任何一条指令点上被中断。

### 锁对象

+ Java语言提供了一个synchronized关键字达到这一目的，Java SE 5.0 引入了ReentrantLock类。

```Java
// ReentrantLock
myLock.lock(); // a ReentrantLock object
try
{
    critical section
}
finally
{
 myLock.unlock(); // make sure the lock is unlocked even if an exception is thrown
}
// 确保任何时刻只有一个线程进入临界区。
// 一旦一个线程封锁了锁对象，其他任何线程都无法通过lock语句。当其他线程调用lock时，它们被阻塞，直到第一个线程释放锁对象。
// 把解锁对象括在finally子句之内是至关重要的。如果在临界区的代码跑出异常，锁必须别释放。否则，其他线程将永远阻塞。
```

+ 使用锁，就不能使用带有资源的try语句。

+ 每一个Bank对象有自己的ReentrantLock对象。如果两个线程试图访问同一个Bank对象，那么锁以串行方式提供服务。但是，如果两个线程访问不同的Bank对象，每一个线程得到不同的锁对象，两个线程都不会发生阻塞。
+ 锁是可重入的，因为线程可以重复地获得已经持有的锁。锁保持一个持有计数(hold count)来跟踪对lock方法等嵌套调用被一个锁保护的代码可以调用另一个使用相同的锁的方法。

```Java
java.util.concurrent.locks.Lock 5.0
void lock(); // 获得这个锁；如果锁同时被另一个线程拥有则发生阻塞
void unlock(); // 释放这个锁

java.util.concurrent.locks.ReentrantLock 5.0
ReentrantLock(); // 构建一个可以被用来保护临界区等可重入锁
ReentrantLock(boolean fair); // 构建一个带有公平策略的锁。一个公平锁偏爱等待时间最长的线程。
```

### 条件对象

+ 一旦一个线程调用await方法，它进入该条件的等待集。当锁可用时，该线程不能马上解除阻塞。相反，它处于阻塞状态，直到另一个线程调用同一个条件上的singalAll方法时为止。
+ 当一个线程拥有某个条件的锁时，它仅仅可以在该条件上调用await，signalAll或signal方法。

```Java
java.util.concurrent.locks.Lock 5.0
Condition newCondition() // 返回一个与该锁相关的条件对象

java.util.concurrent.locks.Condition 5.0
void await() // 将该线程放到条件的等待集中
void signalAll() // 解除该条件的等待集中的所欲线程的阻塞状态
void signal() // 从该条件的等待集中随机地选择一个线程，解除其阻塞状态
```

### synchronized关键字

+ 总结：

    + 锁用来保护代码片段，任何时刻只能有一个线程执行被保护的代码。
    + 锁可以管理试图进入被保护代码段段线程。
    + 锁可以拥有一个或多个相关的条件对象。
    + 每个条件对象管理那些已经进入被保护的代码段但还不能运行的线程。

+ 从1.0版开始，Java中的每一个对象都有一个内部锁。

    ```java
    public synchronized void method()
    {
        method body
    }
    // 等价于
    public void method()
    {
        this.intrinsicLock.lock();
        try
        {
            method body
        }
        finally
        {
            this.intrinsicLock.unlock();
        }
    }
    ```

+ wait 方法添加一个线程到等待集中，notifyAll/notify 方法解除等待线程的阻塞状态。

    ```Java
    // 等价于
    intrinsicCondition.await();
    intrinsicCondition.signalAll();
    ```

+ wait, notifyAll以及notify方法是Object类的final方法。Condition方法必须被命名为 await, signalAll 和 signal 以便它们不会与那些方法发生冲突

+ 每一个对象有一个内部锁，并且该锁有一个内部条件。由锁来管理那些试图进入 synchronized 方法的线程，由条件来管理那些调用wait的线程。

+ 将静态方法声明为 synchronized 也是合法的。当该方法调用时，对象的锁被锁住。因此没有其他线程可以调用同一个类的这个或如何其他的同步静态方法。

+ 内部锁和条件存在一些局限。

    + 不能中断一个正在试图获得锁的线程。
    + 试图获得锁时不能设定超时。
    + 每个锁仅有单一的条件，可能是不够的。

+ 使用 Lock 和 Condition 对象还是同步方法

    + 最好既不使用 Lock/Condition 也不使用 synchronized 关键字。在许多情况下你可以使用 java.util.concurrent 包中的一种机制，它会为你处理所有的加锁。
    + 如果 synchronized 关键字适合你的程序，那么尽管使用。
    + 如果特别需要Lock/Condition结构提供的独有特性时，才使用Lock/Condition

### 同步阻塞

```Java
synchronized(obj)
{
    critical section
}
// 获得obj的锁
```

### 监视器概念

+ 监视器特征：

    + 监视器是只包含私有域的类。
    + 每个监视器类的对象有一个相关的锁。
    + 使用该锁对所有的方法进行加锁。obj.method()，obj对象的锁在方法调用开始时自动获得，并且当方法返回时自动释放该锁。
    + 该锁可以有任意多个相关条件。

+ 每一个条件变量管理一个独立的线程集
+ 3个方面Java对象不同于监视器，使得线程的安全性下降：

    + 域不要求必须是 private
    + 方法不要求必须是 synchronized
    + 内部锁对客户是可用的

### Volatile 域

+ 如果向一个变量写入值，而这个变量接下来可能会被另一个线程读取，或者，从一个变量读值，而这个变量可能是之前被另一个线程写入的，此时必须使用同步。
+ volatile 关键字为实例域的同步访问提供了一种免锁机制。如果声明一个域为 volatile ，那么编译器和虚拟机就知道该域是可能被另一个线程并发更新的。

```Java
private boolean done;
public synchronized boolean isDone() { return done; }
public synchronized void setDone() { done = true; }
// 另一个线程已经对该对象加锁，isDone 和 setDone 可能阻塞。

private volatile boolean done;
public boolean isDone() { return done; }
public void setDone() { done = true; }
```

+ Volatile 变量不能提供原子性。

    ```Java
    public void flipDone() { done = !done;} // not atomic原子
    // 不能确保翻转域中的值
    ```

### final变量

```Java
final Map<String, Double> accounts = new HashMap<>();
// 其他线程会在构造函数完成构造之后才看到这个accounts变量
// 当然对这个映射表的操作并不是安全的。如果多个线程在读写这个映射表，仍然需要进行同步。
```

### 原子性

+ `java.util.concurrent.atomic`包中有很多类使用了很高效的机器级指令（而不是使用锁）来保证其他操作的原子性。

### 死锁

+ 每一个线程要等待更多的钱款存入而导致所有线程都被阻塞。

### 线程局部变量

```Java
public static final ThreadLocal<SimpleDateFormat> dateFormat =
            new ThreadLocal<SimpleDateFormat>()
            {
                protected SimpleDateFormat initialValue()
                {
                    return new SimpleDateFormat("yyyy-MM-dd");
                }
            };
// java.util.Random 类是线程安全的。但是如果多个线程需要等待一个共享的随机数生成器，这会很低效。
// 使用ThreadLocal辅助类为各个线程提供一个单独的生成器
// Java SE 7 提供了一个便利类
in random = ThreadLocalRandom.current().nextInt(upperBond);
// ThreadLocalRandom.current() 调用会返回特定于当前线程的 Random 类实例

java.lang.ThreadLocal<T> 1.2
T get() // 得到这个线程的当前值。如果是首次调用get，会调用 initialize 来得到这个值。
protected initialize() // 应覆盖这个方法来提供一个初始值。默认情况下，这个方法返回 null
void set(T t) // 为这个线程设置一个新值
void remove() // 删除对应这个线程的值

java.util.concurrent.ThreadLocalRandom 7
static ThreadLocal Random current() // 返回特定于当前线程的 Random 类实例
```

### 锁测试与超时

+ 线程在调用 lock 方法来获得另一个线程所持有的锁的时候，很可能发生阻塞。

```Java
if(myLock.tryLock())
    // now the thread owns the lock
    try { ... }
    finally { myLock.unlock(); }
else
    // do something else

// 使用超时参数
if(myLock.tryLock(100, TimeUnit.MILLSECONDS)) ...
// TimeUnit 是个枚举类型，可以取的值包括 SECONDS, MILLISECONDS, MICROSECONDS 和 NANOSECONDS
```

+ lock 方法不能被中断。如果一个线程在等待获得一个锁时被中断，中断线程在获得锁之前一直处于阻塞状态。如果出现死锁，那么，lock 方法就无法终止。
+ 调用超时参数的 tryLock，那么如果线程在等待期间被中断，将抛出 InterruptedException 异常。允许程序打破死锁
+ 调用 lockInterruptibly 方法，它相当于一个超时设为无限的 tryLock 方法。

    ```Java
    // 在等待一个条件时，也可以提供一个超时：
    myCondition.await(100, TimeUnit.MILLISECONDS))
    ```

```Java
java.util.concurrent.locks.Lock 5.0
boolean tryLock()
boolean tryLock(long time, TimeUnit unit) // 尝试获得锁，阻塞时间不会超过给定的值；如果成功返回true
void lockInterruptibly() // 获得锁，但是不确定地发生阻塞。如果线程被中断，抛出一个 InterruptedException 异常

java.util.concurrent.locks.Condition 5.0
boolean await(long time, TimeUnit unit) // 进入该条件等待集，直到线程从等待集中移除或等待了指定的时间之后才解除阻塞。
void awaitUninterruptibly()
```

### 读／写锁

```Java
// 构造一个 ReentrantReadWriteLock 对象
private ReentrantReadWriteLock rwl = new ReentrantReadWriteLock();
// 抽取读锁和写锁：
private Lock readLock = rwl.readLock();
private Lock WriteLock = rwl.writeLock();
// 对所有的获取方法加读锁：
public double getTotalBalance()
{
    readLock.lock();
    try { ... }
    finally { readLock.unlock(); }
}
// 对所有的修改方法加写锁
public void transfer(...)
{
    writeLock.lock();
    try { ... }
    finally { writeLock.unlock();}
}

java.util.concurrent.locks.ReentrantReadWriteLock 5.0
Lock readLock() // 得到一个可以被多个读操作共用的锁，但会排斥所有写操作。
Lock writeLock() // 得到一个写锁，排斥所有其他的读操作和写操作
```

### 为什么弃用 stop 和 suspend 方法

+ stop 和 suspend 方法有一些共同点：都试图控制一个给定线程的行为
+ stop 终止所有未结束的方法，包括 run 方法。当线程被终止，立即释放。被它锁住的所有对象的锁。这会导致对象处于不一致的状态。
+ 如果调用 suspend 方法的线程试图获得同一个锁，那么程序死锁：被挂起的线程等着恢复，而将其挂起的线程等待获得锁。

```Java
// 安全地挂起线程，引入一个变量 suspendRequested 并在 run 方法的某个安全的地方测试它。
private volatile boolean suspendRequested = false;
private Lock suspendLock = new ReentrantLock();
private Condition suspendCondition = suspendLock.newCondition();

public void run()
{
    while(...)
    {
        ...
        if(suspendRequested)
        {
            suspendLock.lock();
            try { while(suspendRequested) suspendCondition.await();}
            finally { suspendLock.unlock();}
        }
    }
}
public void requestSuspend() { suspendRequested = true;}
public void requestResume()
{
    suspendRequested = false;
    suspendLock.lock();
    try { suspendCondition.signalAll(); }
    finally { suspendLock.unlock();}
}
```

## 阻塞队列

+ 许多线程问题，可以通过使用一个或多个多个队列以优雅且安全的方式将其形式化。生产者线程向队列中插入元素，消费者线程则取出它们。

+ 阻塞队列方法

    ```java
    add     // 添加一个因素          // 如果队列满，则抛出 IllegalStateException 异常
    element // 返回队列的头元素       // 空，抛出 NoSuchElementException 异常
    offer   // 添加一个元素并返回 true// 满，返回 false
    peek    // 返回队列的头元素       // 空，返回 null
    poll    // 移出并返回队列的头元素. // 空，返回 null
    put     // 添加一个元素          // 满，则阻塞
    remove  // 移出并返回头元素       // 空，抛出 NoSuchElementException 异常
    take    // 移出并返回头元素       // 空，则阻塞
    
    // 如果将队列当作线程管理工具来使用，将要用到 put 和 take 方法
    // 在一个多线程程序中，队列会在任何时候空或满，一定要使用 offer,poll 和 peek 方法作为替代，这些方法如果不能完成任务，只是给出一个错误提示而不会抛出异常
    // poll 和 peek 方法返回空来指示失败。因此，向这些队列中插入 null 值是非法的
    
    // 超时 offer 方法 和 poll 方法的变体
    boolean success = q.offer(x, 100, TimeUnit.MILLISECONDS)
    Object head = q.poll(100, TimeUnit.MILLISECONDS)
    ```

## 线程安全的集合

### 高效的映射表，集合和队列

+ java.util.concurrent 包提供了映射表，有序集和队列的高效实现：ConcurrentHashMap, ConcurrentSkipListMap, ConcurrentSkipListSet 和 ConcurrentLinkedQueue
+ 集合返回弱一致性（weakly consistent）的迭代器。
+ ConcurrentHashMap 和 ConcurrentSkipListMap 类有相应的方法用于原子性的关联插入以及关联删除。

    ```Java
    cache.putIfAbsent(key, value)
    cache.remove(key, value)
    // 将原子性地删除键值对，如果它们在映像表中出现的话。
    cache.replace(key, oldValue, newValue)
    // 原子性地用新值替换旧值，假定旧值与指定的键值关联
    ```

### 写数组的拷贝

+ CopyOnWriteArrayList 和 CopyOnWriteArraySet 是线程安全的集合，其中所有的修改线程对底层数组进行复制。

### 较早的线程安全集合

+ Vector 和 Hashtable 类就提供线程安全的动态数组和散列表的实现。（被弃用了）
+ 取而代之是 ArrayList 和 HashMap 类。这些类不是线程安全的，而集合库中提供了不同的机制。

    ```Java
    // 任何集合类通过使用同步包装器 ( synchronization wrapper) 变成线程安全的
    List<E> synchArrayList = Collections.synchronizedList(new ArrayList<E>());
    Map<K, V> synchHashMap = Collections.synchronizedMap(new HashMap<K, V>());
    // 结果集合的方法使用锁加以保护，提供了线程的安全访问。
    // 应该确保没有任何线程通过原始的非同步方法访问数据结构。最便利的方法是确保不保存指向原始对象的引用，简单地构造一个结合并立即传递给包装器。
    ```

## Callable 和 Future

+ Runnable 封装了一个异步运行的任务，可以把它想象成为一个没有参数和返回值的异步方法。
+ Callable 与 Runnable 类似，但是有返回值。Callable 接口是一个参数化的类型，只有一个方法 call.

    ```Java
    public interface Callable<V> {
        V call() throws Exception;
    }
    // 类型参数是返回值的类型。
    ```

+ Future 保存异步计算的结果。

    ```Java
    public interface Future<V> {
        V get() throws ...;
        V get(long timeout, TimeUnit unit) throws ...;
        void cancel(boolean mayInterrupt);
        boolean isCancelled();
        boolean isDone();
    }
    ```

+ FutureTask 包装器是一种非常便利的机制，可将 Callable 转换成 Future 和 Runnable, 它同时实现两者的接口。

## 执行器

+ 如果程序中创建了大量的生命期很短的线程，应该使用线程池（ thread pool ）
+ 应该使用一个线程数“固定的”线程池以限制并发线程的总数。

    ```Java
    // 执行器（ Executor ）类有许多静态工厂方法用来构建线程池。
    newCachedThreadPool // 必要时创建新线程；空闲线程会被保留 60 秒
    newFixedThreadPool // 该池包含固定数量的线程；空闲线程会一直被保留
    newSingleThreadExecutor // 只有一个线程的“池”，该线程顺序执行每一个提交任务
    newScheduledThreadPool // 用于预定执行而构建的固定线程池，替代 java.util.Timer
    newSingleThreadScheduleExecutor // 用于预定执行而构建的单线程“池”
    ```

### 线程池

+ newCachedThreadPool , newFixedThreadPool , newSingleThreadExecutor 。这三个方法返回实现了 ExecutorService 接口的 ThreadPoolExecutor 类的对象。

    ```Java
    // 将一个 Runnable 对象或 Callable 对象提交给 ExecutorService
    Future<?> submit(Runnable task)
    Future<T> submit(Runnable task, T result)
    Future<T> submit(Callable<T> task)
    
    // 当用完一个线程池的时候。
    shutdown // 该方法启动该池的关闭序列。被关闭的执行器不再接受新的任务。当所有任务都完成以后，线程池中的线程死亡。
    shutdownNow // 该池取消尚未开始的所有任务并试图中断正在运行的线程。
    ```

+ 使用连接池应该做的事：

    + 调用 Executors 类中静态的方法 newCachedThreadPool 或 newFixedThreadPool
    + 调用 submit 提交 Runnable 或 Callable 对象
    + 如果想要取消一个任务，或如果提交 Callable 对象，那就要保存好返回的 Future 对象。
    + 当不再提交任何任务时，调用 shutdown

### 预定执行

+ ScheduledExecutorService 接口具有为预定执行（ Scheduled Execution ）或重复执行任务而设计的方法。

### 控制任务组

+ invokeAny 方法提交所有对象到一个 Callable 对象的集合中，并返回某个已经完成了的任务的结果。
+ invokeAll 方法提交所有对象到一个 Callable 对象的集合中 ，并返回一个 Future 对象的列表，代表所有任务的解决方案。

    ```Java
    List<Callable<T>> tasks = ...;
    List<Future<T>> results = executor.invokeAll(tasks);
    for(Future<T> result : result)
        processFurther(result.get());
    
    // 将结果按可获得的顺序保存起来更有实际意义。
    ExecutorCompletionService service = new  ExecutorCompletionService(executor);
    for(Callable<T> task : tasks) service.submit(task);
    for(int i = 0; i < tasks.size(); i++)
        processFurther(service.take().get());
    ```

### Fork-Join 框架（ Java SE 7 ）

```java
// 有一个处理任务，它可以很自然地分解为子任务
if(problemSize < threshold)
    solve problem directly
else 
{
    break problem into subproblems
    recursively solve each subproblem
    combine the results
}
```

+ 完成这种递归计算，需要提供一个扩展 RecursiveTask<T> 的类或者提供一个扩展 RecursiveAction 的类。

    ```Java
    class Counter extends RecursiveTask<Integer>
    {
        ...
        protected Integer compute()
        {
            if(to - from < THRESHOLD)
            {
                solve problem directly
            }
        }
        else
        {
            int mid = (from + to) / 2
            Counter first = new Counter(values, from, mid, filter);
            Counter second = new Counter(values, mid, to, filter);
            invokeAll(first, second);
            return fist.join() + second.join();
        }
    }
    ```

## 同步器

### 信号量

### 倒计时门栓

### 障栅

### 交换器

### 同步队列

## 线程与 Swing

