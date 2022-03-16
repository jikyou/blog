---
title: Struts2.x 权威指南
date: 2017-06-26 09:00
tags: Struts2
---

# Struts 2 核心技术

## Struts 2 的 Action

### Action 访问 Servlet API

+ Servlet API HttpServletRequest, HttpSession, ServletContext 对应 JSP 内置对象中的 request, session, appliaction

+ Struts2 ActionContext 类，访问 Servlet API

### Action 直接访问 Servlet API

+ ActionContext 来访问 Servlet API ,但这种访问毕竟不能直接获得 Servlet API 实例，提供接口直接访问 Servlet API

    + `ServletContextAware` 直接访问 Web 应用中的 ServeltContext 实例
    + `ServletRequestAware` HttpServletRequest 实例
    + `ServletResponseAware` HttpServletResponse 实例

+ 提供 ServletActionContext 类

+ 即使我们在 Struts2 的 Action 类中获得了 HttpServletResponse 对象，也不要尝试直接在 Action 中生成对客户端的输出。

### 配置 Action

+ class 属性不是必需的，系统默认使用 ActionSupport 类
+ 配置逻辑试图和物理视图之间的映射

### 配置 Action 的默认处理类

+ 配置 Action 的默认处理使用 `<default-class-ref class="..."/>`

### 动态方法调用（DMI）

```jsp
// Form 表单
action="action!methodName.action"
```

+ 开启系统的动态方法调用

```XML
struts.enable.DynamicMethodInvocation=true
```

### 为 action 元素指定 method 属性

+ 将一个 Action 类定义成多个逻辑 Action，Action 类的每个处理方法被映射成一个逻辑 Action

### 使用通配符

```XML
<action name="*Pro" class="org.action.LoginRegisAction" method="{1}">
</action>

<action name="*Pro" class="org.action.{1}Action">
</action>

<action name="*">
    <result>/WEB-INF/content/{1}.jsp</result>
</action>

<action name="*_*" method="{2}" class="actions.{1}">
</action>
```

+ Struts2 默认的校验文件命名规则：ActionName-validation.xml

+ 除非请求的 URL 与 Action 的 name 属性绝对相同，否则将按先后顺序决定由哪个 Action 来处理用户请求。
+ 因此我们应该将名为 * 的 Action 配置在最后。

### 配置默认的 Action

+ 在某些情况下，用户请求非常简单，并不需要进行过多的处理，只是需要进行简单的转发。
+ 所有请求都发送给 Struts2 框架，让该框架来处理用户请求，即使只是简单的超链接也如此。

+ 对于只是简单的超链接的请求，可以通过定义 name 为 * 的 Action（该 Action 应该放在最后定义）
+ 还可以定义一个默认的 Action，当用户请求的 URL 在容器中找不到对应的 Action 时，系统将使用默认的 Action 来处理用户请求。（package 下）

## 管理处理结果

### 配置结果

```XML
// 局部结果
<action ..>
    <result name="success"></>
</>

// 全局结果
<global-results>
    <result name=""></>
</>
```

+ `param`

```XML
<result name="success" type="dispatcher">
    <param name="location">/thank_you.jsp</>
    <param name="parse">true</>
</>

// name 逻辑视图名 默认为 success
// type 结果类型 默认结果类型是 dispatcher 
// 还可以通过配置文件来改变默认的结果类型

// param name
// location 实际视图资源
// parse 指定是否允许在实际视图名字中使用 OGNL 表达式，默认值为 true

<result>/thank_you.jsp</result>
```

### Struts2 支持的处理类型

+ Struts2 的结果类型要求实现 com.opensymphony.xwork.Result
+ 需要自己的结果类型，则应该提供一个实现该接口的类，并且在 struts.xml 文件中配置该结果类型

+ 结果类型

    + chain
    + dispatcher
    + freemarker
    + httpheader
    + redirectAction
    + stream
    + velocity
    + xslt
    + plainText

### chain 结果类型

+ 当一个 Action 处理完成之后，系统不想转发到 视图资源，而是希望让另一个 Action 进行下一步处理，此时就需要两个 Action 形成 “链式” 处理。

```XML
<action name="addBook" class="org.action.AddBookAction">
    <result type="chain">getBooks</result>
</action>
```

### plainText 结果类型

+ 用于显示实际视图资源的源代码

```XML
<result type="plainText">
    <param name="location">/WEB-INF/content/welcome.jsp</>
    <param name="charSet">GBK</>
</>
```

### redirect 结果类型

+ 重定向会失去所有的请求参数，请求属性。也丢失了 Action 的处理结果。
+ 使用 redirect 结果类型的效果是，系统将调用 HttpServletResponse 的 sendRedirect(String) 方法来重定向指定的视图资源，就是重新产生一个请求，因此，所有的请求参数，请求属性，Action 实例和 Action 中封装的属性全部丢失。

```XML
<action name="login" class="org.action.LoginAction">
    <result type="redirect">/WEB-INF/content/welcome.jsp</>
</>
// Action 处理用户请求结束后，系统将重新生成一个请求，直接转入 /WEB-INF/content/welcome.jsp
```

### redirectAction 结果类型

+ redirectAction 结果类型与 redirect 类型非常相似，一样是重新生成一个全新的请求。区别在于，redirectAction 使用 ActionMapperFactory 提供的 ActionMapper 来重定向请求。
+ 当需要让一个 Action 处理结束后，直接将请求重定向到另一个 Action 时，应该使用 redirectAction 结果类型。

```XML
<package name="public" extends="struts-default">
    <action name="login" class="org.action.LoginAction">
        <result type="redirectAction">
            <param name="actionName">dashboard</>
            <param name="namespace">/secure</>
        </>
    </action>
</>
<package name="secure" extends="struts-default" namespace="/secure">
    <action name="dashboard" class="org.action.Dashboard">
        <result>dashboard.jsp</>
        <result name="error" type="redirectAction">error</>
    </>
    <action name="error">
        <result>/WEB-INF/content/error.jsp</>
    </>
</>
```

### 动态结果

```XML
<action name="crud_*" class="lee.CrubAction" method="{1}">
    <result name="input">/WEB-INF/content/input.jsp</>
    <result>/WEB-INF/content/{1}.jsp</>
</>
```

### 请求参数决定结果

+ `${属性名.属性名}`

```XML
<result type="redirect">edit.action?skill=${curSkill.name}</>
<result>/WEB-INF/content/${target}.jsp</>
```

### 全局结果

```XML
<global-results>
    <result>/WEB-INF/content/${target}.jsp</>
</>
```

+ 同名的结果，局部结果会覆盖全局结果
+ 只有在 Action 的局部结果里找不到逻辑视图对应的结果时，才会到全局结果里搜索。

## 属性驱动和模型驱动

### 模型的作用

+ 模型驱动，模型封装了所有数据，贯穿整个 MVC 流程。模型的作用是，封装用户请求参数和处理结果。

### 使用模型驱动

```XML
<s:property value="model.tip"/>

// 或者
<s:property value="tip"/>
```

## Struts2 的异常机制

+ 通过声明式的方式管理异常处理

### Struts2 的异常处理哲学

+ Action 接口的 execute() 方法抛出全部异常，把异常直接抛出 Struts2 框架处理，Struts2 框架接收到 Action 抛出的异常之后，根据 struts.xml 文件配置的异常映射，转入指定的视图资源。

### 声明式异常捕捉

```XML
<package name="default" extends="struts-default">
   <global-results>
       <result>/WEB-INF/content/welcome.jsp</result>
       <result name="sql">/WEB-INF/content/exception.jsp</result>
       <result name="root">/WEB-INF/content/exception.jsp</result>
   </global-results>

// 全局异常映射
   <global-exception-mappings>
       <exception-mapping exception="java.sql.SQLException" result="sql"></exception-mapping>
       <exception-mapping exception="java.lang.Exception" result="root"></exception-mapping>
   </global-exception-mappings>

   <action name="login" class="action.LoginTestAction">
    // 局部异常映射
       <exception-mapping exception="exception.MyException" result="my"/>
       <result name="my">/WEB-INF/content/exception.jsp</result>
       <result name="error">/WEB-INF/content/error.jsp</result>
       <result name="success">/WEB-INF/content/welcome.jsp</result>
   </action>

   <action name="*">
       <result>/WEB-INF/content/{1}.jsp</result>
   </action>
</package>

// exception-mapping 
//  exception 此属性指定该异常映射所设置的异常类型
//  result 系统转入 result 属性所指向的结果
```

+ 通常，全局异常映射的 result 属性值通常不要使用局部结果。局部则都可以使用。

### 输出异常信息

```JSP
<s:property value="exception"/> // 输出异常本身
<s:property value="exceptionStack"/> // 输出异常堆栈信息
```

## 未知处理器

# Struts2 的类型转换

+ Struts2 的类型转换是基于 OGNL 表达式的。

## 类型转换的意义

+ B/S 结构应用的请求参数是通过浏览器发送到服务器的，这些参数不可能有丰富的数据类型，因此必须在服务器端完成数据的类型转换。

### 表现层数据处理

+ 表现层数据的流向主要有两个方向：输入数据和输出数据
+ 对于服务器状态呈现给客户而言，支持多种数据类型的直接输出。
+ 对于输入数据，则需要完成由字符串类型向多种数据类型转换。程序通常无法自动完成数据类型转换，需要在代码中手动转换。

+ MVC 框架的另一个数据是数据校验，数据校验可分为客户端校验和服务器端校验。两者都是必不可少的，分别完成不同的过滤。

### 传统的类型转换

```Java
String strAge = request.getParamter("age");
int age = Integer.parseInt(strAge);
```

### Struts2 内建的类型转换器

+ 内建了字符类型和如下类型之间的类型转换器

    + boolean 和 Boolean
    + char Character
    + int Integer
    + long Long
    + float Float
    + double Double
    + Date 日期格式使用用户请求所在 Locale 的 SHORT 格式
    + 数组 默认情况下，数组元素是字符串
    + 集合 默认情况下，集合元素类型为 String，并创建一个新的 ArrayList 封装所有的字符串

+ 对于数组的类型转换，将按照数组元素的类型来单独转换每一个元素；但对于其他的类型转换，如果转换无法完成，系统将出现类型转换错误。

+ 属性驱动 Action 里加上无参构造器和初始化全部属性的构造器。

```Java
public class RegisAction extends ActionSupport
{
    private String name;
    private String pass;
    private int age;
    private Date birth;

    public RegisAction()
    {
    }

    public RegisAction(String name, String pass, int age, Date birth)
    {
        this.name = name;
        this.pass = pass;
        this.age = age;
        this.birth = birth;
    }
    
    //setter and getter
}

// struts.xml 配置一样
```

## 基于 OGNL 的类型转换

+ 字符串参数转换成复合类型。

```Java
public class RegistAction implemetns Action
{
    private User user;
    private String tip;
    
    // setter and getter
    
    public String execute() throws Exception
    {
        setTip("转换成功");
        return SUCCESS;
    }
}
```

```JSP
<form method="post" action="regist">
    <input type="text" name="user.name" /><br/>
    <input type="password" name="user.pass" /><br/>
    <input type="text" name="user.age" /><br/>
    <input type="text" name="user.birth" /><br/>
    <input type="submit" value="注册">
</>
```

+ 注意点

    + Struts2 需要直接创建一个复合类（User 类）的实例，因此系统必须保证该复合类有无参数的构造器。
    + 必须为复合类提供 setter 方法，Struts2是通过调用 Set 方法来赋值的，当然 Action 类中还有应该有包含 setUser() 方法。

### 使用 OGNL 转换成 Map 集合

```Java
public class LoginAction implements Action
{
    private Map<String, User> users;
    private String tip;
    
    // setter and getter
    
    @Override
    public String execute() throws Exception
    {
        if (getUsers().get("one").getName().equals("czqlan") && getUsers().get("one").getPass().equals("123"))
        {
            setTip("success");
            return SUCCESS;
        } else
        {
            setTip("fail");
            return ERROR;
        }
    }
}
```

```JSP
<form action="login.action" method="post">
   <table align="center" width="360">
       <caption><h3>封装成对象 Map</h3></caption>
       <tr>
           <td><input name="users['one'].name"></td>
       </tr>
       <tr>
           <td><input name="users['one'].pass"></td>
       </tr>
       <tr>
           <td><input name="users['two'].name"></td>
       </tr>
       <tr>
           <td><input name="users['two'].name"></td>
       </tr>
       <tr align="center">
           <td>
               <input type="submit" value="转换">
               <input type="reset" value="重填">
           </td>
       </tr>
   </table>
</form>

// 访问 Action 的 Map 类型属性
<s:property value="users['one'].name"/><br/>
<s:property value="users['one'].pass"/><br/>
```

+ 将表单域的 name 属性设置为 "Action 属性名['key 值'].属性名"

### 使用 OGNL 转换成 List 集合

```JSP
// List<User>

<input type="text" name="user[0].name"/>
<input type="text" name="user[0].pass"/>
<input type="text" name="user[1].name"/>
<input type="text" name="user[1].pass"/>

<s:property value="users[0].name"/>
<s:property value="users[0].pass"/>
```

## 自定义类型转换器

+ 一个字符串转换成一个符合对象。（`abc,xyz`转换成 一个 User 类型实例）

### 系统需求

+ 用户信息的用户名和密码以英文逗号隔开

### 实现类型转换器

+ TypeConverter 接口

```Java
public interface TypeConverter
{
    public Object convertValue(Map context, Object target, Member member, String propertyName, Object value, Class toType);
}
```

+ OGNL 项目提供了一个该接口的实现类：DefaultTypeConverter
+ 实现自定义类型转换器需要重写 DefaultTypeConverter 类的 convertValue 方法。

```Java
public class UserConverter extends DefaultTypeConverter
{
    @Override
    public Object convertValue(Map context, Object value, Class toType)
    {
        if (toType == User.class)
        {
            String[] params = (String[]) value;
            User user = new User();
            String[] userValues = params[0].split(",");
            user.setName(userValues[0]);
            user.setPass(userValues[1]);
            return user;
        } else if (toType == String.class)
        {
            User user = (User) value;
            return "<" + user.getName() + "," + user.getPass() + ">";
        }
        return null;
    }
}

// 双向转换
// context 是类型转换环境的上下文
// value 是需要转换的参数
// toType 是需要转换的目标类型
```

+ 把所有请求都视为字符串数组。
+ `DefaultTypeConverter` 是通过 HttpServletRequest 的 getParameterValues(name) 方法来获取请求参数值的。因此它获取的请求参数总是字符串数组。

### 局部类型转换器

+ 类型转换器的注册方式

    + 注册局部类型转换器：局部类型转换器仅仅对某个 Action 的属性起作用。
    + 注册全局类型转换器：全局类型转换器对所有 Action 的特定类型的属性都会生效。
    + 使用 JDK 1.5 的 Annotation 来注册类型转换器

```properties
// 同目录下 ActionName-conversion.properties
// propertyName=类型转换器

// LoginAction-conversion.properties
user=org.action.UserConverter
// 当浏览者提交请求时，请求中的 user 请求参数将会先被该类型转换器处理
```

+ 局部转换器只对指定 Action 的制定属性生效，全局类型转换器对指定类型的全部属性起作用。

### 全局类型转换器

```properties
// xwork-conversion.properties
// 复合类型=对应的类型转换器

org.domain.User=org.action.UserConverter

```

### 局部类型转换器和全局类型转换器的说明

+ 局部类型转换器对指定 Action 的指定属性起作用，一个属性只调用 convertValue 方法一次。`List<User>`
+ 全局类型转换器对所有 Action 的特定类型起作用，因此可能对一个属性多次调用 convertValue 方法进行转换。

    + 当该属性是一个数组或集合时，该数组或集合中包含几个该类型的元素，那就会调用几次 convertValue 方法。

### 基于 Struts2 的类型转换器

+ Struts 2 提供了一个 Struts2TypeConverter 抽象类。

```Java
public abstract class StrutsTypeConverter extends DefaultTypeConverter 
{
    @Override
    public Object convertValue(Map context, Object o, Class toClass)
    {
        if (toClass.equals(String.class))
        {
            return convertToString(context, o);
        } else if (o instanceof String[])
        {
            return convertFromString(context, (String[]) o, toClass);
        } else if (o instanceof String)
        {
            return performFallbackConversion(context, new String[]{(String) o}, toClass);
        } else
        {
            return performFallbackConversion(context, o, toClass);
        }
    }

    protected Object performFallbackConversion(Map context, Object o, Class toClass) {
        return super.convertValue(context, o, toClass);
    }

    public abstract Object convertFromString(Map content, String[] values, Class toClass);

    public abstract String convertToString(Map context, Object o);
}

// 将两个不同的转换方向替换成不同方法。
```

+ 实现两个方法。

```Java
public class UserDemoConverter extends StrutsTypeConverter
{
    @Override
    public Object convertFromString(Map context, String[] values, Class toClass)
    {
        User user = new User();
        String[] userValues = values[0].split(",");
        user.setName(userValues[0]);
        user.setPass(userValues[1]);
        return user;
    }

    @Override
    public String convertToString(Map map, Object o)
    {
        User user = (User) o;
        return "<" + user.getName() + "," + user.getPass() + ">";
    }
}
```

### 数组属性的类型转换器

+ `User[]`，多个 user 需要遍历

### 集合属性的类型转换器

+ `List<User>`

## 集合类型转换的高级特性

+ `List<User>` 不使用泛型。

### 指定集合元素的类型

+ 使用 Struts2 的配置文件：在局部类型转换配置文件中指定集合元素的数据类型。

```properties
// Element_xxx=集合元素类型
Element_users=org.domain.User

// Map
// Key_xxx=key元素类型
// Element_xxx=value元素类型

```

### 为 Set 集合的元素指定索引属性

+ 对 Set 类型的属性则无法通过索引访问集合元素。

+ 访问 Set 元素用的是 圆括号，而不是方括号。但对于数组，List 和 Map 属性，通过方括号来访问指定的集合元素。

## 类型转换中的错误处理

+ 表现层数据涉及两个处理：数据校验和类型转换是紧密相关的。

### 类型转换的错误处理流程

+ Struts2 提供了一个名为 conversionError 的拦截器
+ 如果 Struts2 的类型转换器执行类型转换时出现错误，该拦截器负责将对应错误封装成表单域错误（fieldError），并将错误信息放入 ActionContext 中。

+ conversionError 拦截器实际上是一个 Throws 处理。
+ 当 conversionError 拦截器对转换异常进行处理后，系统会跳转到名为 input 的逻辑视图。

+ 为了让 Struts2 框架处理类型转换错误，以及使用后面的数据校验机制，系统的 Action 类都应该通过继承 ActionSupport 类来实现。
+ ActionSupport 类为完成类型转换错误处理，数据校验实现了许多基础工作。

### 处理类型转换错误

### 输出类型转换错误

```JSP
<s:fielderror/>
// Invalid filed value for fileld "user"
// user ，Action 中的属性名
```

+ 如果使用 Struts2 的表单标签来生成表单，并使用 xhtml 主题，Struts2 的表单标签将会自动输出错误提示。

```XML
xwork.default.invalid.fieldvalue={0}字段类型转换失败！

// struts.xml
<constant name="struts.custom.il8n.resources" value="globalMessages"/>
```

+ 对特定字段指定特别的提示信息

```properties
// ActionName.properties
// invalid.fieldvalue.属性名=提示信息

// LoginAction.properties 与 Action 相同位置
invalid.fieldvalue.birth=生日信息必须满足 yyyy-MM-dd 格式
```

### 处理集合属性的转换错误

+ 分别显示错误

```JSP
<s:iterator value="new int[3]" status="stat">
   <tr>
       <td>用户<s:property value="%{#stat.index}"/></td>
       <input name="users[<s:property value="%{#stat.index}"/>" type="text">
   </tr>
</s:iterator>
```

# Struts2 的输入校验

+ 输入校验分为客户端校验和服务器校验

    + 客户端校验主要是过滤正常用户的误操作，主要通过 JavaScript 代码完成
    + 服务端校验是整个应用阻止非法数据的最后防线，主要通过在应用中编程实现。

## 输入校验概述

### 为什么需要输入校验

+ 在 `《Writing Secure Code》` 一书中名言：All Input Is Evil

### 客户端校验

+ 客户端校验就是通过 JavaScript 在数据收集页面（通常是表单输入页）中进行初步过滤。
+ 使用第三方校验库 Valiadation.js 库

### 服务器端校验

+ 很多恶意的 Cracker ，并不是通过浏览器来 crack 某个应用，他会采用更低层的 Socket 通信进行 crack
+ 或者，将网页源代码保存到本机，修改源代码取消表单元素的输入校验绑定，并修改该表单的 action 属性。

+ 客户端校验把这些误输入阻止在客户端，从而降低了服务器的负载。服务器端校验是请求数据进入系统之前的最后屏障。

### 类型转换和输入校验

+ 类型转换在输入校验之前进行。
+ 有时类型转换和输入校验同时完成。进行类型转换时可以完成基本的输入校验，成功转换成有效数据类型只是成为有效数据的必要条件，在类型转换的基础上，还要进行额外的输入校验。

## 基本输入校验

### 编写校验规则文件

+ 采用 Struts2 的校验框架时，只需要为该 Action 指定一个校验文件即可。

```XML
// RegistAction-validation.xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE validators PUBLIC "-//Apache Struts//XWork Validator 1.0.3//EN"
        "http://struts.apache.org/dtds/xwork-validator-1.0.3.dtd">

<validators>
    <field name="name">
        <field-validator type="requiredstring">
            <param name="trim">true</param>
            <message key="user.required"/>
        </field-validator>
        <field-validator type="regex">
            <param name="regexExpression"><![CDATA[
            (\w{4,25})
            ]]></param>
            <message>您输入的用户名只能是字母和数字，且长度必须在 4 到 25 之间</message>
        </field-validator>
    </field>
    <field name="pass">
        <field-validator type="requiredstring">
            <param name="trim">true</param>
            <message key="pass.required"/>
        </field-validator>
        <field-validator type="regex">
            <param name="regexExpression"><![CDATA[
            (\w{4,25})
            ]]></param>
            <message>您输入的密码只能是字母和数字，且长度必须在 4 到 25 之间</message>
        </field-validator>
    </field>
    <field name="age">
        <field-validator type="int">
            <param name="min">1</param>
            <param name="max">150</param>
            <message>年龄必须在 1 到 150 之间</message>
        </field-validator>
    </field>
    <field name="birth">
        <field-validator type="date">
            <param name="min">1900-01-01</param>
            <param name="max">2050-02-21</param>
            <message>生日必须在${min}到${max}之间</message>
        </field-validator>
    </field>
</validators>
```

+ Struts2 的校验文件规则与 Struts1 的校验文件设计方式不同，Struts2 中的每个 Action 都有一个校验文件。Struts2 的校验框架可以更方便地进行模块化开发。
+ Struts2的 Action 与校验规则文件具有如下共性

    + Action 类与校验规则文件保存在同一路径下。
    + Action 类的类名作为校验规则文件的文件名前缀。`<Action名字>-validate.xml`

+ 增加了校验文件后，系统会自动加载该文件。当用户提交请求时，Struts2 的校验框架会根据该文件对用户请求进行校验。
+ 校验失败后，Struts2 将会自动返回名为 input 的逻辑视图。

```XML
// 国际化 RegistAction.properties
name.required=..
name.regex=...
pass.required=..
pass.regex=...
age.regex=..
birth.range=..
```

### 使用客户端校验

+ 增加客户端校验，将输入页面的表单元素改为使用 Struts2 标签来生成表单，并为该表单增加 `validate="true"` 属性即可。

```JSP
// registForm.jsp
<s:form action="regist" validate="true">
    <s:textfield label="用户名" name="name"/>
    <s:password label="密码" name="pass"/>
    <s:textfield label="年龄" name="age"/>
    <s:textfield label="生日" name="birth"/>
    <s:submit value="提交"/>
</s:form>
```

```XML
// RegistAction-validation.xml
<field name="name">
   <field-validator type="requiredstring">
       <param name="trim">true</param>
       <message>${getText("name.required")}</message>
   </field-validator>
   <field-validator type="regex">
       <param name="regexExpression"><![CDATA[
       (\w{4,25})
       ]]></param>
       <message>${getText("name.regex")}</message>
   </field-validator>
</field>
```

+ 客户端校验是基于 JavaScript 完成的，由于 JavaScript 脚本本身的限制，有些服务器端校验不能转换成客户端校验。
+ 客户端校验支持几种校验器

    + require validator 必填校验器
    + requirestring validator 必填字符串校验器
    + stringlength validator 字符串长度校验器
    + regex validator 正则表达式校验器
    + email validaror 邮件校验器
    + url validator 网址校验器
    + int validator 整数校验器
    + double validator 双精度数校验器

+ 客户端校验注意点

    + Struts2 的 <s:form.../> 元素有一个 theme 属性，不要将该属性指定为 simple
    + 不要在校验规则文件的错误提示信息中，直接食用 key 来指定国际化信息。

## 校验器的配置风格

+ Struts2 提供了两种方式来配置校验规则 

    + 字段校验器风格 字段优先
    + 非字段校验器风格 校验器优先

### 字段校验器

```DTD
// 在 validators 元素的 field 或 validator 中都可以出现一次或无限次。
<!ELEMENT validators (field|validator)+>

// validators 是校验规则文件的根元素，该根元素下可以出现两个元素
// <field../>
// <validator../>

// 出现第一种就是 字段优先，就是字段校验器配置风格
// 出现第二种元素，就是校验器优先，就是非字段校验器风格
```

+ 形式

```XML
<field name="被校验的字段">
   <field-validator type="校验器名">
       <param name="参数名">参数值</param>
       <message key="I18Nkey">校验失败后的提示信息</>
   </field-validator>
   ...
</field>
...

// 每个 field-validator 都必须有 <message.../> 元素
```

### 非字段校验器配置风格

```XML
<validator type="校验器名">
    <param name="fieldName">需要被校验的字段</param>
    ...
    <param name="参数名">参数值</param>
    ...
    
    <message key="I18Nkey">校验失败后的提示信息</message>
</validator>
...
```

### 短路校验器
