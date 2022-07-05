---
title: 第二部分 Web 中的 Spring
date: 2017-04-08 18:11:00 +0800
tags: 
- Spring in Action
---

# 构建 Spring Web 应用程序

## Spring MVC 起步

### 跟踪 Spring MVC 的请求

### 搭建 Spring MVC 

#### 配置 DispatcherServlet

+ 通过 AbstractAnnotationConfigDispatcherServletInitializer 配置 DispatcherServlet 需要Servlet3.0，如Tomcat7或更高版本 (替代了web.xml)

#### 启用 Spring MVC 

+ 配置类

    + 配置视图解析器 InternalResourceViewResolver ( 在视图名称上添加前缀后缀)
    + 启用组件扫描

## 编写基本的控制器

+ `@Controller`
+ `@RequestMapping(value="/", method=GET)`
+ 处理器方法上的`@RequestMapping`注解是对类级别上的`@RequestMapping`的声明进行补充
+ `@ResquestMapping("/")`
+ `@ResquestMapping({"/", "/homepage"})`

## 接受请求的输入

+ SpringMVC允许以多种方式将客户端中的数据传送到控制器的处理器方法中

    + 查询参数(Query Parameter)
    + 表单参数(Form Paramter)
    + 路径参数(Path Variable)

### 处理查询参数

```Java
    @RequestMapping(method = RequestMethod.GET)
    public List<String> spittles(
            @RequestParam(value = "max", defaultValue = MAX_LONG_AS_STRING) long max,
            @RequestParam(value = "count", defaultValue = "20") int count
    ) {
        return spittleRepository.findSpittles(Long.MAX_VALUE, 20);
    }
```

### 通过路径参数接收输入

```Java
    @RequestMapping(value = "/{spittleId}", method = RequestMethod.GET)
    public String spittle(
            @PathVariable("spittleId") long spittleId, Model model
    ) {
        model.addAttribute(spittleRepository, findOne(spittleId));
        return "spittle";
    }
    
    // 因为方法的参数名与占位符的名称相同，可以去掉@PathVariable中的value属性
    @RequestMapping(value = "/{spittleId}", method = RequestMethod.GET)
    public String spittle(
            @PathVariable long spittleId, Model model
    ) {
        model.addAttribute(spittleRepository, findOne(spittleId));
        return "spittle";
    }
```

## 处理表单

+ 当InternalResourceViewResolver看到的视图格式是：

    + "Redirect:/spitter/" + spitter.getUsername();
    + "forward:/..."

+ 校验表单 

    + 注解 ( javax.validation.constraints )

        + @NotNull
        + @Size(min=5, max=25)
    
    + 过滤

        ```Java
        public String processRegistration(
            @Valid Spitter spitter, Errors errors
        ) {
            if(errors.hasErrors()) {
                return ;
            }
        }
        ```

# 渲染Web视图
