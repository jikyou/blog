---
title: Maven 实战
date: 2017-06-09 14:00:00 +0800
tags:
- Maven
---

# Maven 安装和配置

## 设置 HTTP 代理

```SHELL
ping repo1.maven.org
telnet 218.14.227.197 3128
```

+ 代理配置

```XML
// ~/.m2/settings.xml

<settings>
...
<proxies>
<proxy>
<id>my-proxy</id>
<active>true</active> // 表示 true 激活
<protocol>http</protocol> // 表示使用的代理协议
<host>218.14.227.197</host>
<port>3128</port>
<! --
<username>***</username>
<password>***</password>
<nonProxyHosts>repository.mycom.com|*.google.com</nonProxyHosts> // 哪些主机名不需要代理
-- >
</proxy>
</proxies>
...
</settings>
```

## Maven 安装最佳实践

+ 设置 MAVEN_OPTS 环境变量，需要设置为 `-Xms128m-Xmx512m`，因为 Java 默认的最大可用内存往往不能够满足 Maven 运行的需要。
+ 配置用户范围的 ~/.m2/settings.xml
+ 不要使用 IDE 内嵌的 Maven

    + 内嵌的版本和命令行的版本可能不一致。

# Maven 使用入门

## 编写 POM

```XML
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="http://maven/apache.org/POM/4.0.0
http://maven.apache/org/maven-v4_0_0.xsd">
<modelVersion>4.0.0</modelVersion> // POM 模型的版本
<groupId>com.juvenxu.mvnbook</groupId> // 组
<artifactId>hello-world</artifactId> // 组中的唯一 ID
<version>1.0-SNAPSHOT</version>
<name>Maven Hello World Project</name> // 项目名称
</project>
```

## 编写主代码

+ 项目主代码位于 `src/main/java`

```terminal
mvn clean compile
   clean:clean // 删除 target/ 目录
   resources:resources
   compiler:compile // 将项目主代码编译至 target/classes 目录
```

## 编写测试代码

+ Maven 项目中默认的测试代码目录是 `src/test/java`

```XML
...
<dependencies>
<dependency>
<groupId>junit</groupId>
<artifactId>junit</artifactId>
<version>4.7</version>
<scope>test</scope> // 依赖范围为 test 表示只对测试有效
</dependency>
</dependencies>
...
```

+ groupId, artifactId 和 version 是任何一个 Maven 项目最基本的坐标。
+ 典型的单元测试包含三个步骤

    + 准备测试类及数据
    + 执行要测试的行为
    + 检查结果

+ 约定，执行测试的方法都以 test 开头

```terminal
mvn clean test
    clean:clean
    resources:resources
    compiler:compile
    resources:testResources
    compiler:testCompile // 在 target/test-classes 下生成了二进制文件
    surefire:test // 负责执行测试的插件
```

```XML
// 配置 maven-compiler-plugin 支持 Java5
<project>
...
<build>
<plugins>
<plugin>
<groupId>org.apache.maven.plugins</groupId>
<artifactId>maven-compiler-plugin</artifactId>
<configuration>
<source>1.5</source>
<target>1.5</target>
</configuraction>
</plugins>
</plugin>
</build>
...
</project>
```

## 打包和运行

```terminal
// 打包
mvn clean package
    jar:jar // 负责打包

// 根据 artifact-version.jar 规则进行命名
// 还可以使用 finalName 来自定义该文件的名称

// 引用
mvn clean install
    install:install // 将项目输出的 jar 安装到了 Maven 本地仓库中
```

+ 执行 test 之前是会先执行 compile 的，执行 package 之前是会先执行 test 的，而类似地，install 之前会执行 package

+ 因为带有 main 方法的类信息是不会添加到 mainfest 中，为了生成可执行的 jar 文件，需要借助 maven-shade-plugin 

```XML
<plugin>
<groupId>org.apache.maven.plugins</groupId>
<artifactId>maven-shade-plugin</artifactId>
<version>1.2.1</version>
<executions>
<execution>
<phase>package</phase>
<goals>
<goal>shade</goal>
</goals>
<configuration>
<transformers>
<transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTramsformer">
<mainClass>com.juvenxu.mvnbook.helloworld.HelloWorld</mainClass>
</transformer>
</transformers>
</configuration>
</execution>
</executions>
</plugin>

// plugin 位置位于在 POM 中 <project><build><plugins> 下面
```

## 使用 Archetype 生成项目骨架

+ Maven 约定

    + 在项目的根目录中放置 pom.xml
    + 在 src/main/java 目录中放置项目的主代码
    + 在 src/test/java 中放置项目的测试代码

+ 我们称这些基本的目录结构和 pom.xml 文件内容称为项目的骨架。

```XML
mvn archetype:generate
```

# 背景案例

```text
com.juvenxu.mvnbook.account.service // 系统的核心，封装了所有下层细节，对外暴露简单的接口  Facade 模式
com.juvenxy.mvnbook.account.web // 该模块包含所有与 web 相关的内容，包括 jsp,Servlet, web.xml
com.juvenxy.mvnbook.account.persist // 处理信息的持久化
com.jubenxy.mvnbook.account.captcha // 处理验证码的 key 生成，图片生成
com.juvenxy.mvnbook.account.email // 处理邮件服务的配置，激活邮件的编写和发送
```

# 坐标和依赖

+ Maven 坐标的元素包括 groupId, artifactId, version, packaging, classifier
+ Maven 内置了一个[中央仓库](http://repo1/maven/org/maven2)

+ groupId 定义当前 Maven 项目隶属的实际项目。和 Java 包名的表示方式，通常与域名反向一一对应。（org.sonatype.nexus）
+ artifactId 该元素定义实际项目中的一个 Maven 项目（模块），推荐的做法是使用实际项目名称作为 artifactId 的前缀。方便寻找时机构件。
+ version 该元素定义 Maven 项目当前所处的版本。
+ packaging 该元素定义 Maven 项目的打包方式。

    + 打包方式通常与所生成构件的文件扩展名对应。（jar 打包方式，war 打包方式）不过这不是绝对的。
    + 打包方式会影响到构建的生命周期。
    + 不定义 packaging 的时候，Maven 会使用默认值 jar

+ classifier 该元素用来帮助定义构建输出的一些附属构建。不能直接定义项目的 classifier ，附属的插件帮助生成。

+ 项目构件的文件名是与坐标相对应的，一般的规则为 artifactid-version[-classifier].packaging（ [-classifier] 表示可选 ）
+ packaging 并非一定与构件扩展名对应。

+ mvn clean test 执行测试，Maven 会编译主代码和测试代码，并执行测试。
+ mvn clean install 执行编译，测试，打包等工作。最后将项目生成的构件安装到本地仓库中。

## 依赖的配置

```XML
<project>
...
<dependencies>
<dependency>
<artifactId></artifactId>
<type></type>
<scope></scope>
<optional></optional>
<exclusions>
<exclustion>
...
</exclusion>
...
</exclusions>
</dependency>
...
</dependencies>
...
</project>
```

+ 根元素 project 下的 dependencies 可以包含一个或者多个 dependency 元素，以声明一个或者多个项目依赖。

+ 每个依赖可以包含的元素有

    + groupId,artifactId 和 version 依赖的基本坐标，对于任何一个依赖来说，基本坐标是最重要的，Maven 根据坐标才能找到需要的依赖。
    + type 依赖的类型。对应于项目坐标定义的 packaging。大部分情况下，该元素不必声明，其默认值为 jar
    + scope 依赖的范围
    + optional 标记依赖是否可选
    + exclusions 用来排除传递性依赖

## 依赖范围

+ JUnit 依赖的测试范围是 test，测试范围用元素 scope 表示。

+ 依赖范围哦就是用来控制依赖与这三种 classpath（编译 classpath，测试 classpath，运行 classpath）

    + compile 编译依赖范围。如果没有指定，就会默认使用该依赖范围。使用此依赖范围的 Maven 依赖，对于编译，测试，运行三种 classpath 都有效。
    + test 测试依赖范围。使用此依赖范围的 Maven 依赖，只对于测试 classpath 有效。
    + provided 已提供依赖范围。对于编译和测试 class-path 有效，但在运行时无效。典型的例子是 servlet-api ，编译和测试项目的时候需要该依赖，但在运行项目的时候，由于容器已经提供，就不需要 Maven 重复地引入一遍
    + runtime 运行时依赖范围。对于测试和运行 class-path 有效，但在编译主代码时无效。典型的例子是 JDBC 驱动实现，项目主代码的编译只需要 JDK 提供的 JDBC 接口，只有在执行测试或者运行项目的时候才需要实现上述接口的具体 JDBC 驱动。
    + system 系统依赖范围。和 provided 依赖范围完全一致。但是，使用 system 范围的依赖时必须通过 systemPath 元素显示地指定依赖文件的路径。（由于此类依赖不是通过 Maven 仓库解析的，而且往往于本机系统绑定，可能造成构建的不可移植，谨慎使用）
    
        + systemPath 元素可以引用环境变量。

        ```XML
        <dependency>
        <groupId>javax.sql</groupId>
        <artifactId>jdbc-stdext</artifactId>
        <version>2.0</version>
        <systemPath>${java.home}/lib/rt.jar</systemPath>
        </dependency>
        ```
    
    + import (Maven 2.0.9 及以上) 导入依赖范围。该该依赖范围不会对三种 classpath 产生实际的影响。

## 传递性依赖

+ account-mail 有一个 compile 范围的 spring-core 依赖， spring-core 有一个 compile 范围的 commons-logging 依赖，那么 commons-logging 就会称为 account-email 的 compile 范围依赖， commons-logging 是 account-email 的一个传递性依赖。
+ Maven 会解析各个直接依赖的 POM，将那些必要的间接依赖，以传递性依赖的形式引入到当前的项目中。

### 传递性依赖和依赖范围

+ 当第二直接依赖的范围是 compile 的时候，传递性依赖的范围与第一直接依赖的范围一致
+ 当第二直接依赖的范围是 test 的时候，依赖不会得以传递
+ 当第二直接依赖的范围是 provided 的依赖，且传递性依赖的范围同样为 provided
+ 当第二直接依赖的范围是 runntime 的时候，传递性依赖的范围与第一直接依赖的范围一致，但 compile 例外，此时传递性依赖的范围为 runtime

## 依赖调解

+ Maven 依赖调解（Dependency Mediation）的第一原则是：路径最近者优先。
+ 从 Maven2.0.9 开始，Maven 定义了依赖调解的第二原则：第一声明者优先。

## 可选依赖

+ 可能项目 B 实现了两个特性，其中的特性一依赖于 X，特性二依赖于 Y ，而且这两个特性是互斥的，用户不能同时使用两个特性

```XML
<project>
<modelVersion>4.0.0</modelVersion>
<groupId>com.juvenxy.mvnbook</groupId>
<artifactId>project-b</artifactId>
<version>1.0.0</version>
<dependencies>
<dependency>
<groupId>mysql<groupId>
<artifactId>mysql-connector-java</artifactId>
<version>5.1.10</version>
<optional>true</optional>
</dependency>
<dependency>
<groupId>postgresql</groupId>
<artifactId>postgresql</artifactId>
<version>8.4-701.jdbc3</version>
<optional>true</optional>
</dependency>
</dependencies>
</project>

// mysql-connector-java 和 postgresql 这两个依赖是可选依赖，这两个依赖不会被传递。
```

+ 可选依赖不被传递

+ 理想的情况下，是不应该使用可选依赖的。根据单一职责性原则，一个类应该只能有一项职责。更好的做法是，为 MySQL 和 PostgreSQL 分别创建一个 Maven 项目，基于同样的 groupId 分配不同的 artifactId

## 最佳实践

### 排除依赖

```XML
<dependencies>
<dependency>
<groupId>com.juvenxu.mvnbook</groupId>
<artifactId>project-b</.>
<version>1.0.0</.>
<exclusions> // 声明排除依赖
<exclusion>
<groupId>com.juvenxu.mvnbook</groupId>
<artifactId>project-c</artifactId>
</exclusion>
</exclusions>
</dependency>
<dependency>
<groupId>com.juvenxu.mvnbook</.>
<artifactId>project-c</artifactId>
<version>1.1.0</>
</dependency>
</dependencies>
```

+ exclusions 元素声明排除依赖。声明 exclusion 的时候只需要 groupId 和 artifactId，而不要 version 元素。

### 归类依赖

```XML
// Spring Framework 中的不同模块版本号
<project>
<modelVersion>4.0.0</modelVersion>
<groupId>com.juven.mvnbook.account</groupId>
<artifactId>account-mail</artifactId>
<name>Account Email</name>
<version>1.0.0-SNAPSHOT</version>
<properties>
<springframework.version>2.5.6</springframework.version>
</properties>
<dependencies>
<dependency>
<groupId>org.springframework</groupId>
<artifactId>spring-core</artifactId>
<version>${springframework.version}</version>
</dependency>
<dependency>
<groupId>org.springframework</groupId>
<artifactId>spring-beans</artifactId>
<version>${springframework.version}</version>
</dependency>
<dependency>
<groupId>org.springframework</groupId>
<artifactId>spring-context</artifactId>
<version>${springframework.version}</version>
</dependency>
<dependency>
<groupId>org.springframework</groupId>
<artifactId>spring-context-support</artifactId>
<version>${springframework.version}</version>
</dependency>
</dependencies>
</project>
```

### 优化依赖

+ Maven 会自动解析所有项目的直接依赖和传递性依赖，并且根据正确判断每个依赖的范围，对于一些依赖冲突，也能进行调节，以确保任何一个构建只有唯一的版本在依赖中存在。
+ 最后得到的那些依赖被称为已解析依赖。

```terminal
// 查看当前项目的已解析依赖
mvn dependency:list

// 依赖树
mvn dependency:tree

// 分析当前项目的依赖
mvn dependency:analyze
    Used undeclared dependencies // 指项目中使用到的，但没有显示声明的依赖。
    Unuserd undeclared dependencies // 未使用，但显示声明的依赖。应该仔细分析， dependency:analyze 只会分析编译主代码和测试代码需要用到的依赖，一些执行测试和运行时需要的依赖它发现不了。
```

# 仓库

+ 坐标和依赖是任何一个构件在 Maven 世界上的逻辑表示方式。
+ 而构件的物理表示方式是文件，Maven 通过仓库来统一管理这些文件。
