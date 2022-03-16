---
title: 第一部分 Spring 的核心
date: 2017.04.12 11:46
tags: Spring in Action
---

# 高级装配

## 环境与 profile

### 配置 profile bean

+ `@Profile("dev")`
+ `<beans profile="dev"></beans>`

### 激活 profile

+ spring.profiles.active
+ spring.profiles.default

#### 使用 profile进行测试

+ `@ActiveProfiles("dev")`

## 条件化的 bean

+ @Conditional(MagicExistsCondition.class)

```Java
public interface Condition {
    boolean matches(ConditionContext ctxt, AnnotatedTypeMetadata metadata);
}

public interface ConditionContext {
    BeanDefinitionRegistry getRegistry();
    ConfigurableListableBeanFactory getBeanFactory();
    Environment getEnvironment();
    ResourceLoader getResourceLoader();
    ClassLoader getClassLoader();
}

public interface AnnotatedTypeMetadata {
    boolean isAnnotated(String annotationType);
    Map<String, Object> getAnnotationAttributes(String annotationType);
    Map<String, Object> getAnnotationAttributes(String annotationType, boolean classValuesAsString);
    MultiValueMap<String, Object> getAllAnnotationAttributes(String annotationTyper);
    MultiValueMap<String, Object> getAllAnnotationAttributes(String annotationTyper, boolean classValuesAsString);
}
```

+ Spring4开始，@Profile基于@Conditional和Condition实现

```Java
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.TYPE, ElementType.METHOD})
@Documented
@Conditional(ProfileCondition.class) {
    String[] value();
}
```

## 处理自动装配的歧义性

### 标示首选的 bean

+ `@Primary`

```Java
@Component
@Primary
public class IceCream implements Dessert {...}

//Java显示配置
@Bean
@Primary
public Dessert iceCream {
    return new IceCream();
}

// XML
<bean id="iceCream" class="com.desserteater.IceCream" primary="true" />
```

### 限定自动装配的 bean

+ `@Qualifier("iceCream")`

```Java
@Autowired
@Qualifier("iceCream")
public void setDessert(Dessert dessert) {
    this.dessert = dessert;
}
```

#### 创建自定义的限定符

```Java
@Component
@Qualifier("cold")
public class IceCream implements Dessert {...}

@Autowired
@Qualifier("cold")
public void setDessert(Dessert dessert) {
    this.dessert = dessert;
}

// Java配置注解
@Bean
@Qualifier("cold")
public Dessert iceCream() {
    return new IceCream();
}
```

#### 使用自定义的限定符注解

+ 由于Java不允许在同一个条目上重复出现的多个注解。Java8可以，只要这个注解本身在定义时带有@Repeatable注解就可以。

```Java
@Target({ElementType.CONSTRUCTOR, ElementType.FIELD, Element.METHOD, ElementType.TYPE)})
@Retention(RetentionPolicy.RUNTIME)
@Qualifier
public @interface Cold { }

@Component
@Cold
@Creamy
public class IceCream implements Dessert {...}

// 注入点
@Autowired
@Cold
@Creamy
public void setDessert(Dessert dessert) {
    this.dessert = dessert;
}
```

+ 相对于使用原始的@Qualifier并借助String类型来指定限定符，自定义的注解也更为类型安全。

## bean 的作用域

+ Spring作用域
    + 单例(Singleton): 在整个应用中，只创建一个bean的一个实例(默认)
    + 原型(Prototype): 每次注入或通过Spring应用上下文获取的时候，都会创建一个新的bean实例。
    + 会话(Session): 在Web应用中，为每个会话创建一个bean实例
    + 请求(Request): 在Web应用中，为每个请求创建一个bean实例

+ `@Scope`注解作用域

```Java
@Component
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public class Notepad {...}

// 或使用@Scope("prototype")
// 但是使用SCOPE_PROTOTYPE常量更加安全并且不易出错

@Bean
@Scope(ConfigurableFactory.SCOPE_PROTOTYPE)
public Notepad notepad() {
    return new Notepad();
}

<bean id="notepad" class="com.myapp.Notepad" scope="prototype"/>
```

### 使用会话和请求作用域

+ 会话

    ```Java
    @Component
    @Scope(
        value=WebApplicationContext.SCOPE_SESSION,
        proxyMode=ScopedProxyMode.INTERFACES)
    public ShoppingCart cart() { ... }
    // proxyMode解决了将会话或请求作用域的bean注入到单例bean中所遇到的问题。
    // 当StoreService调用ShoppingCart的方法时，代理会对其进行懒解析并调用给会话作用域内真正的ShoppingCart bean
    
    proxyMode=ScopedProxyMode.TARGET_CLASS
    // 表明要以生成目标类扩展的方式创建代理
    ```
    
+ 作用域代理能够延迟注入请求和会话作用域的bean

### 在 XML 中声明作用域代理

```Java
<bean id="cart" class="com.myapp.ShoppingCart" scope="session">
    <aop:scoped-proxy />
</bean>

<aop:scoped-proxy proxy-target-class="false" />
// 要求它生成基于接口的代理
```

## 运行时值注入

+ Spring 提供了两种在运行时求值的方式：

    + 属性占位符(Property placeholder)
    + Spring表达式语言(SpEL)

### 注入外部的值

```Java
@Configuration
@PropertySource("classpatch:/com/soundsystem/app/properties")
public class ExpressiveConfig {
    @Autowired
    Environment env;
    
    @Bean
    public BlankDisc disc() {
        return new BlankDisc(
            env.getProperty("disc.title"),
            env.getProperty("disc.artist"));
    }
}
```

#### 深入学习 Spring 的 Environment

+ getProperty()

    + String getProperty(String key) // ，没有定义时，获取到的值是null
    + String getProperty(String key, String defaultValue)
    + T getProperty(String key, Class<T> type)
    + T getProperty(String key, Class<T> type, T defaultValue)
        + int connectionCount = env.getProperty("db.connection.count", Integer.class, 30);

+ getRequiredProperty("disc.title") // 属性没有定义的话，会抛出IllegalStateException

+ boolean containsProperty()
+ getPropertyAsClass() // 将属性解析为类
    + Class<CompactDisc> cdClass = env.getPropertyAsClass("disc.class"
, CompactDisc.class);
+ String[] getActiveProfiles(); // 返回激活profile名称的数组
+ String[] getDefaultfiles(); // 返回默认profile名称的数组
+ boolean acceptsProfiles(String... profiles)

### 解析属性占位符

+ `${ ... }`

    ```xml
    <bean id="sgtPeppers" 
            class="soundsystem.BlankDisc" 
            c:_title="${disc.title}" 
            c:_artist="${disc.artist}" />
    ```
    
    + 依赖于组件扫描和自动装配来创建和初始化应用组件
    
        ```Java
        public BlackDisc(
                @Value("${disc.title}") String title,
                @Value("${disc.artist}") String artist) {
            this.title = title;
            this.artist = artist;
        }
        ```

+ 为了使用占位符，必须配置一个PropertySourcesPlaceholderConfigurer bean

    ```Java
    @Bean
    public static PropertySourcesPlaceholderConfigurer placeholderConfigurer() {
        return new PropertySourcePlaceholderConfigurer();
    }
    
    // XML
    <context:property-placeholder />
    ```

+ 解析外部属性能够将值的处理推迟到运行时，但是它的关注点在于根据名称解析来自于Spring Environment和属性源的属性。

### 使用 Spring 表达式语言进行装配

+ （Spring引入）Spring Expression Language (SpEL),特性：

    + 使用bean的ID来引用bean
    + 调用方法和访问对象的属性
    + 对值进行算术，关系和逻辑运算
    + 正则表达式匹配
    + 集合操作

+ SpEL表达式要放到“#{ ... }"之中

    ```Java
    #{T(System).currentTimeMillis()
    // 计算机表达式的那一刻当前时间的毫秒数
    // T()表达式 会将java.lang.System视为Java中对应的类型
    
    // 引用其他的bean或其他bean的属性
    #{sgtPeppers.artist}
    
    #{systemProperties['disc.title']}
    // 引用系统属性
    
    public BlankDisc(
            @Value("#{systemProperty['disc.title']}" String title,
            @Value("#{systemProperty['disc.artist']}" String artist) {
        this.title = title;
        this.artist = artist;
    }
    
    <bean id="sgtPeppers" 
          class="soundsystem.BlankDisc"
          c:_title="#{systemProperties['disc.title']}"
          c:_artist="#{systemProperties['disc.artist']}" />
    ```

#### 表示字面值

#### 引用 bean，属性和方法

+ SpEL所能做的另外一件基础的事情就是通过ID引用其他的bean。

```Java
#{artistSelector.selectArtist()?.toUpperCase()}
// 与使用“.”符号不同，"?."可以在访问它右边内容之前，确保它对应的元素不是null
// 如果artistSelector.selectArtist()返回值时是null的话，那么SpEL将不会调用toUpperCase()方法。表达式返回值是null
```

#### 在表达式中使用类型

+ 在SpEL中访问类作用域的方法和常量的话，要依赖T()这个关键的运算符

```Java
T(java.lang.Math) // 结果会是一个Class对象
T(java.lang.Math).PI
T(java.lang.Math).random()
```

#### SpEL 运算符

```Java
#{T(java.lang.math).PI * circle.radius ^ 2}
#{disc.title ' by ' + disc.artist}
#{counter.total == 100}
#{scoreboard.score > 1000 ? "Winner!" : "Loser"}

// 三元表达式一个常见的场景就是检查null，并用一个默认值来代替null
#{disc.title ?: 'Rattle and Hum'}
// 这种表达式通常称为Elvis运算符。
```

#### 计算正则表达式

```Java
#{admin.email matches '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.com'}
// 返回Boolean值
```

#### 计算集合

```Java
#{jukebox.songs[4].title}
#{'This is a test'[3]}

// 查询运算符（.?[]）,对集合进行过滤
#{jukebox.songs.?[artist eq 'Aerosmith']}

// .^[], .$[]  分别用来在集合中查询第一个匹配项和最后一个匹配项
#{jukebox.sons.^[artist eq 'Aerosmith']}

// 投影运算符 .![], 会从集合的每个成员中选择特定的属性放到另外一个集合中。
#{jukebox.songs.![title]}

#{jukebox.songs.?[artist eq 'Aerosmith'].![title]}
```

# 面向切面的 Spring

+ 软件开发中，散布于应用中多处的功能被称为横切关注点（cross-cutting concern）
+ AspectJ

## 什么是面向切面编程

### 定义 AOP 术语

+ 通知（Advice）
    + 定义了切面是什么以及何时使用

    + Spring切面可以应用5种类型的通知：
    
        + 前置通知(Before)
        + 后置通知(After)
        + 返回通知(After-returning)
        + 异常通知(After-throwing)
        + 环绕通知(Around)

+ 连接点(Join point)

    + 连接点是在应用执行过程中能够插入切面的一个点。这个可以是调用方法时，抛出异常时，甚至是修改一个字段时。切面代码可以利用这些插入到应用的正常流程之中，并添加到新的行为。

+ 切点(Poincut)

    + 通知定义了切面的“什么”和“何时”的话，那切点就定义了“何处”。
    + 切点的定义会匹配通知所要织入的一个或多个切点。
    + 我们通常使用明确的类和方法名称，或是利用正则表达式定义所匹配的类和方法来指定这些切点。

+ 切面(Aspect)

    + 切面是通知和切点的结合。

+ 引入(Introduction)

    + 引入允许我们向现有的类添加新方法或属性。

+ 织入(Weaving)

    + 织入是把切面应用到目标对象并创建新的代理对象的过程。
    + 切面在指定的连接点被织入到对象目标对象中。
    + 在目标对象的生命周期里有多个点可以进行织入：
        + 编译期 // 切面在目标类编译时被织入。 AspectJ
        + 类加载期 // 切面在目标类加载到JVM时被织入。 AspectJ5
        + 运行期 // 切面在应用运行的某个时刻被织入。在织入切面时，AOP容器会为目标对象动态地创建一个代理对象。 Spring AOP

### Spring 对 AOP 的支持

+ 不同的AOP框架在连接点模型上可能有强弱之分

+ Spring提供了4种类型的AOP支持
    + 基于代理的经典Spring AOP
    + 纯POJO切面
    + @AspectJ注解驱动的切面
    + 注入式AspectJ切面(适用于Spring各版本)

+ 前三种都是Spring AOP实现的变体，Spring AOP构建在动态代理基础之上。Spring对AOP的支持局限于方法拦截

#### Spring 通知是 Java 编写的

#### Spring 在运行时通知对象

+ 直到应用需要被代理的bean时，Spring才创建代理对象。

#### Spring 只支持方法级别的连接点

+ 因为Spring是基于动态代理的。

## 通过切点来选择连接点

+ Spring仅支持AspectJ切点指示器(pointcut designator)的一个子集。
+ Spring借助AspectJ的切点表达式语言来定义Spring切面。

    + arg() 限制连接点匹配参数为指定类型的执行方法
    + @args() 限制连接点匹配参数由指定注解标注的执行方法
    + execution() 用于匹配是连接点的执行方法
    + this() 限制连接点匹配AOP代理的bean引用为指定类型的类
    + target 限制连接点匹配目标对象为指定类型的类
    + @target() 限制连接点匹配待定的执行对象，这些对象对应的类型要具有指定类型的注解
    + within() 限制连接点匹配指定的类型
    + @within() 限制连接点匹配指定注解所标注的类型(当使用Spring AOP时，方法定义在由指定的注解所标注的类型)
    + @annotation 限定匹配带有指定注解的连接点

+ 以上只有execution指示器是实际执行匹配，而其他指示器都是用来限制匹配的
+ execution指示器是我们在编写切点定义时最主要使用的指示器，在此基础上我们其他指示器阿里限制所匹配的切点

### 编写切点

```Java
execution(* concert.Performance.perform(..))

// execution 在方法执行时触发
// * 返回任意类型
// concert.Performance 方法所属的类
// perform 方法
// .. 指定任意参数，表明切点要选择任意的perform()方法，无论该方法的入参是什么

execution(* concert.Performance.perform(..)) && within(concert.*)
// XML中使用and，not，or
```

### 在切点中选择 bean

+ Spring引入了一个新的bean()指示器，它允许我们在切点表达式中使用bean的ID来标识。

```Java
execution(* concert.Performance.perform() and bean('woodstock'))
```

## 使用注解创建切面

+ 使用注解来创建切面是AspectJ5所引入的关键特性。

### 定义切面

```Java
@Aspect
public class Audience {
    @Before("execution(** concert.Performance.perform(..))")
    public void silenceCellPhones() {
        System.out.println("Silence cell phones");
    }
    
    @Before("execution(** concert.Performance.perform(..))")
    public void takeSeats() {
        System.out.println("Taking seats");
    }
    
    // 表演之后
    @AfterReturning("execution(** concert.Performance.perform(..))")
    public void applause() {
        System.out.println("CLAP CLAP CLAP!!!");
    }
    
    // 表演失败之后
    @AfterThrowing("execution(** concert.Performance.perform(..))")
    public void demandRefund() {
        System.out.println("Demanding a refund");
    }
}
```

+ Spring使用AspectJ注解来声明通知方法

    + @After 通知方法会在目标方法返回值或抛出异常后调用
    + @AfterReturning 通知方法会在目标方法返回后调用
    + @AfterThrowing 通知方法会在目标方法抛出异常后调用
    + @Around 通知方法会将目标方法封装起来
    + @Before 通知方法会在目标方法调用之前执行

+ `@Pointcut`注解能够在一个`@AspectJ`切面内定义可重用的切点。

    ```java
    @Aspect
    public class Audience {
        @Pointcut("execution(** concert.Performance.perform(..))") // 定义命名的切点
        public void performance() {}
        
        @Before("performance()")
        public void silenceCellPhones() {
            System.out.println("Silence cell phones");
        }
        
        @Before("performance()")
        public void takeSeats() {
            System.out.println("Taking seats");
        }
        
        @AfterReturning("performance()")
        public void applause() {
            System.out.println("CLAP CLAP CLAP!!!");
        }
        
        @AfterThrowing("performance()")
        public void demandRefund() {
            System.out.println("Demanding a refund");
        }
    }
    ```

+ JavaConfig中启用AspectJ注解的自动代理

    ```Java
    @Configuration
    @EnableAspectJAutoProxy // 启用AspectJ自动代理
    @ComponentScan
    public class ConcertConfig() {
        
        @Bean
        public Audience audience() { // 声明Audience bean
            return new Audience();
        }
    }
    ```

+ XML装配bean

     ```xml
     <context:component-scan base-package="concert" />
     <aop:aspectj-autoproxy />
     <bean class="concert.Audience" />
     ```

### 创建环绕通知



