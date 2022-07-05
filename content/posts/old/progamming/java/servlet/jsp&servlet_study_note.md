---
title: JSP&Servlet 学习笔记
date: 2017-03-27 20:25:00 +0800
tags:
- Java
- Servlet
- Book
---

# Web应用程序简介

## URL

+ URL(Uniform Resource Locator)的主要格式为：<协议>:<特定协议部分>

	+ 协议(scheme)指定了以何种方式取得资源。
		+ ftp(文件传输协议，File Transfer Protocol)
		+ http(超文本传输协议，HyperText Transfer Protocol)
		+ mailto(电子邮件)
		+ file(特定主机文件名)
	+ 协议之后跟随冒号，特定协议部分的格式则为：//<用户>:<密码>@<主机>:<端口号>/<路径>
		+ http://openhome.cc:8080/Gossip/index.html
		+ file://c:/workspace/jdbc.pdf

+ URL代表资源的地址信息，URN(Uniform Resource Name)则代表某个资源独一无二的名称。如：国家标准书号(ISBN)

+ 由于URL或URN的目的，都是用啦标识某个资源，后来的标准制定了URI，而URL与URN成为URI的子集。

## HTTP

+ HTTP两个基本但极为重要的特性：
	+ 基于请求(Request)/响应(Response)模型
		+ 客户端对服务器发出一个取得资源的请求，服务器将要求的资源响应个客户端
		+ 每次联机只作一次请求/响应
		+ 没有请求就不会有响应

	+ 无状态(Stateless)通信协议
		+ 服务器响应客户端之后，就不会记得客户端的信息

+ 浏览器在使用HTTP发出请求时，可以有几种请求方法，如GET, POST, HEAD, PUT, DELETE等。

# 编写与设置servlet

## 在HelloServlet之后

### 使用@WebServlet

```Java
@WebServlet {
    name="Hello",
    urlPatterns={"/hello.view"},
    loadOnStartup=1
}
```

### 使用Web.xml

```xml
<servlet>
	<servlet-name>HelloServlet</servlet-name>
	<servlet-class>cc.openhome.HelloServlet</servlet-class>
	<load-on-startup>1</load-on-startup>
</servlet>
<servlet-mapping>
	<servlet-name>HelloServlet</servlet-name>
	<url-pattern>/helloUser.view</url-pattern>
</servlet-mapping>
```

### 文件组织与部署

+ WEB-INF: 这个目录是固定的，而且一定是位于应用程序根目录下。放置在WEB-INF中的文件或目录，对外界来说是封闭的，也就是客户端无法试用HTTP的任何方式直接访问到WEB-INF中的文件或目录。若有这类需要，则必须通过Servlet/Jsp的请求转发(Forward)。不想让外界存取的资源，可以放置在这个目录下。

## 进阶部署设置

### URL模式设置

+ 一个请求URI实际上是由三个部分组成的：

    > requestURI = contentPath + servletPath + pathInfo
     getRequestURI()

    + 环境变量（Context path) - getContentPath()
        + 路径映射(Path mapping): 以“/”开头但以“/*”结尾的URL模式。
        + 扩展映射(extension mapping): 以“*.“开头的URL模式。
        + 环境根目录(Context root): 空字符串”“是个特殊的URL模式，对应至环境根目录，也就是”/“的请求，但不用与设置<url-pattern>或urlPattern属性。
        + 预设Servlet: 仅包括”/“的URL模式对应时，就会使用预设Servlet。
        + 完全匹配(Exact match): 不符合以上设置的其他字符串，都要作路径的严格对应。

    + Servlet路径 - getServletPath()
        + 不包括路径信息(Path info)与请求参数(Request parameter)。

    + 路径信息
        + 不包括请求参数。
        + 如果没有额外路径信息，则为null(扩展映射，预设Servlet，完全匹配的情况下，getPathInfo()就会取得null)
        + 如果有额外信息，则是一个以”/”开头的字符串。

/FirstServlet/servlet/path.view = /FirstServlet + /servlet + /path.view

### Web目录结构

+ 如果Web应用程序的URI最后是以“/”结尾，而且确实存在改目录，则Web容器必须传回该目录下的欢迎页面，可以在部署描述文件web.xml中包括以下的定义，指出可用的欢迎页面名称为何。

    ```xml
    // Web容器会依序看看是否有对应的文件存在
    <welcome-file-list>
        <welcome-file>index.html</welcome-file>
        <welcome-file>default.jsp</welcome-file>
    </welcome-file-list>
    
    // 如果找不到以上文件，则会尝试至JAR的/META-INF/resources中寻找已放置的资源页面。
    // 如果URL最后是以“/”结尾，但不存在该目录，则会使用，预设Servlet(如果有定义的话)
    ```

### 使用web-fragment.xml

1. web-fragment.xml

    + 一个JAR文件中，除了可使用标注定义的Servlet，监听器，过滤器，还可以拥有自己的部署描述文件，这个文件的名称是web-fragment.xml，必须放置在JAR文件的META-INF目录中。
    + web-fragment.xml的根标签是<web-fragment>而不是<web-app>
    + 实际上，web-fragment.xml中所指定的类，不一定要在JAR文件中，也可以是子啊web应用程序的/WEB-INF/classes中。

2. web.xml与web-fragment.xml

    + Servlet3.0对web.xml与标注的配置顺序并没有定义，对web-fragment.xml及标注的配置顺序也没有定义，然而可以决定web.xml与web-fragment.xml的配置顺序，其中一个设置方式实在web.xml中使用<absolute-ordering>定义绝对顺序。

    + 另一个定义顺序的方式，是直接在每个JAR文件的web-fragment.xml中使用<ordering>，其中使用<before>或<after>来定义顺序。

3. metadata-complete属性

    + 如果将web.xml中<web-app>的metadata-complete属性设置为true(默认是false)，则表示web.xml中已完成Web应用程序的相关定义，部署时将不会扫描标注与web-fragment.xml中的定义，如果有<absolute-ordering>与<ordering>也会被忽略。

# 请求与响应

## 从容器到HttpServlet

+ Web容器是生成Servlet/Jsp唯一认识的HTTP服务器！

### Web容器做了什么

+ Web容器做的事就是，创建Servlet实例，并完成Servlet名称注册及URL模式的对应。在请求到来时，Web容器会转发给正确的Servlet来处理请求。

+ 容器收集相关信息，并创建代表请求与响应的对象。（HttpServletRequest,HttpServletResponse接口）
+ Web容器本身就是一个Java所编写的应用程序。

+ Http服务器对浏览器进行响应，之后容器将HttpServletResponse对象，HttpServletResponse对象销毁回收，该次请求响应结束。

+ Web容器
    + 请求信息的收集
    + HttpServiceRequest对象，HttpServiceResponse对象等的创建
    + 输出Http响应的转换
    + HttpServiceRequest对象，HttpServiceResponse对象等的销毁创建和回收。

+ Servlet接口的Service方法签名(Signature)其实接受的是ServletRequest，ServletResponse:

    ```Java
    public void service(ServiceRequest req, ServletResponse res) throws ServletException, IOException;
    // 当初定义Servlet时，期待的是Servlet不仅使用于HTTP。(ServletRequest, ServletResponse)-javax.servlet
    //而与HTTP相关的行为(HttpServletRequest, HttpServletResponse)-javax.servlet.http
    ```

+ HttpServlet中的实现service()

    ```Java
    public void service(ServletRequest req, ServletResponse res) throws ServletException, IOException {
        HttpServletRequest request;
        HttpServletResponse response;

        try {
        	request = (HttpServletRequest) req;
        	response = (HttpServletResponse) res;
        } catch(ClassCastException e) {
        	throw new ServletException("non-HTTP request or response");
        }
        service(request, response);
    }
    
    //Http新定义的方法
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    	String method = req.getMethod();
    	if(method.equals(METHOD_GET)) {
    		long lastModified = getLastModified(req);
    		if(lastModified = -1) {
    			doGet(req, resp);
    		} else {
    			long ifModifiedSince = req.getDateHeader(HEADER_IFMODSINCE);
    			if(ifModifiedSince < (lastModified / 1000 * 1000)) {
    				maybeSetLastModified(resp, lastModified);
    				doGet(req, resp);
    			} else {
    				resp.setStatus(HttpServletResponse.SC_NOT_MODIFIED);
    			}
    		} else if(method.equals(METHOD_HEAD)) {
    			long lastModified = getLastModified(req);
    			maybeSetLastModified(resp, lastModified);
    			doHead(req, resp);
    		} else if(method.equals(METHOD_POST) {
    			doPost(req, resp);
    		} else if(method.equals(METHOD_PUT)) {
    			...
    		}
    	}
    ```

+ 继承HttpServlet之后，没有重新定义doGet()方法，而客户端对该Servlet发出了GET请求，则会收到错误信息。
+ 对于GET请求，可以实现getLastModified()方法（默认返回-1，也就是默认不支持if-modified-since表头），来决定是否调用doGet()方法，getLastModified()方法返回自1970年1月1日凌晨至资源最后一次更新期间所经过的毫秒数，返回的这个时间如果晚于浏览器发出的if-modified-since标头，才会调用doGet()方法

## 关于HttpServletRequest

### 处理请求参数与标头

#### 取得请求参数

```Java
    String getParameter();
    
    String username = request.getParameter("name");
    // 若请求中没有所指定的参数名称，则返回null
        
    String[] getParameterValues();
    Enumeration getParameterNames();
    
    Enumeration<String> e = req.getParameterNames();
    
    Map getParameterMap();
    // Map中的键是请求参数名称，值的部分是请求参数值，以字符串数组类型String[]返回（考虑有同一请求参数有多个值的情况）
```
    
#### 获取HTTP的标头（Header）信息

```Java
    String getHeader();//指定标头名称后可返回字符串值，代表浏览器所送出的标头信息
    Enumeration getHeaders();//元素为字符串
    Enumeration getHeaderNames();//取得标头名称
    
    @Webservlet("/header.view")
    public class HeaderServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest res, HttpServletResponse resp) throws ServletException, IOException {
            PrintWriter out = resp.getWriter();
            out.println("<html>");
            out.println("<head>");
            out.println("<title>HeaderServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>HeaderServlet at" + req.getContextPath() + "</h1>");
            Enumeration<String> names = req.getHeaderNames();
            while(names.hasMoreElements() {
                String name = names.nextElements();
                out.println(name + ":" + req.getHeader(name) + "<br>");
            }
            out.println("</body>");
            out.println("</html>");
        }
    }

标头值本身是个整数或日期的字符串表示法
getIntHeader() 
// 转换为int 失败则 抛出NumberFormatException
getDateHeader()
// 转换为Date 失败则抛出IllegalArgumentException
```

### 请求参数编码处理

#### POST请求参数编码处理

```Java
// 网页编码是UTF-8，相当于浏览器做了这个操作
String text = java.net.URLEncoder.encode("林"， “UTF-8；“)

// 在Servlet中取得请求参数时，容器若默认使用ISO-8859-1来处理编码
String text = java.net.URLDecoder.decode("%E6%9E%97", "ISO-8859-1");

req.setCharacterEncoding("UTF-8");
// 指定取得POST请求参数时使用的编码
```

#### GET请求参数编码处理

+ setCharacterEncoding()这个对于请求Body中的字符编码才有作用，也就是只对POST产生作用。

+ 通过String的getBytes()指定编码来取得该字符串的字节数组，然后重新构造为正确编码的字符串

	```Java
	String name = req.getParameter("name");
	String name = new String(name.getBytes("ISO-8859-1"), "UTF-8");
	```

### getReader(), getInputStream()读取Body内容

+ form标签没有设置enctype属性，默认值是application/x-www-form-urlencoded
+ 如果上传文件，enctype属性要设为multipart/form-data
+ 同一个请求期间，getReader()和getInputStream()只能择一调用，否则，抛出illegalStateException异常

+ 例子：Servlet处理上传文件


### getPart(), getParts() 取得上传文件

+ Tomcat中必须设置标注（@MultioartConfig）才能使用getPart()相关API

+ @MultipartConfig 标注可用来设置Servlet处理上传的相关信息
	+ fileSizeThreshold 整数值设置，若上传文件大小超过设置门槛，会先写入缓存文件，默认值为0
	+ location 字符串设置，设置写入文件时的目录
	+ maxFileSize 限制上传文件大小，默认值为-1L，表示不限制大小
	+ maxRequestSize 限制multipart/form-data 请求个数，默认值为-1L，表示不限个数。

	```Java
	@MultipartConfig(location="c:/workspace")
	@WebServlet("/upload2.do")
	public class UploadServlet2 extends HttpServlet {
		@Override
		protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
			req.setCharacterEncoding("UTF-8");//上传的文件名可能会有中文
			Part part = req.getPart("photo");
			String filename = getFilename(part);
			part.write(filename);
		}

		private String getFilename(Part part) {
			String header = part.getHeader("Content-Disposition");
			String filename = header.substring(header.indexOf("filename=\"") + 10, header.lastIndexOf("\""));
			return filename;
		}
	}	
	```

 + getParts()方法，返回一个Collection<part>,其中每个上传文件的Part对象。

    ```Java
    for(Part part : req.getParts()) {
    	if(part.getName.startsWith("file")) {
    		String filename = getFilename(part)；
    		part.write(filename);
    	}
    	//if的原因，因为”上传“按钮也会是其中一个Part对象。 
    }
    ```
    
### 使用RequestDispatcher调派请求

+ 在Web应用程序中，经常需要多个Servlet来完成请求。例如，将另一个Servlet的请求处理流程包含（Include）进来，或将请求转发（Forward）给别的Servlet处理。

+ 使用HttpServletRequest的getRequestDispatcher()方法取得RequestDispatcher接口的实现对象实例，调用时指定转发或包含的相对URL网址

	```Java
	RequestDispatcher dispatcher = request.getRequstDispatcher("some.do");
	// 取得RequestDispatcher还有两个方式，通过ServletContext的getRequestDispatcher()或getNameDispatcher()
	```

#### 使用include()方法

+ 将另一个Servlet的操作流程包括至目前Servlet操作流程之中。

	```Java
	PrintWriter out = resp.getWriter();
	out.println("Some do one...");
	RequestDispatcher dispatcher = req.getRequestDispatcher("other.view");
	dispatcher.include(req, resp);
	out.println("Some do two...");
	out.close();
	// other.view 实际上会依URL模式取得对应的Servlet

	// 在取得RequestDispatcher时，也可以包括查询字符串
	req.getRequestDispatcher("other.view?data=123456").include(req, resp);
	// 那么在被包含（或转发，如果使用的是forward())的Servlet中就可以使用getParameter("data")取得请求参数值。
	```

#### 请求范围属性

+ 在include()或forward()时包括参数的做法，仅适用于传递字符串值另一个Servlet。

+ 在调派请求的过程中，如果有必须共享的”对象“，可以设置给请求对象成为属性，称为请求范围属性(Request Scope Arrribute)。
	+ setAttribute: 指定名称与对象设置属性。
	+ getAttribute: 指定名称取得属性
	+ getAttributeNames(): 取得所有属性名称。
	+ removeAttribute(): 指定名称移除属性。

	```Java
	List<Book> books = bookDAO.query("ServletJSP");
	request.setAttribute("books", books);
	request.getRequestDispatcher("result.view").include(request, response);

	List<Book> books = (List<Book>) request.getAttribute("books");
	```

+ 保留属性，表示上一个Servlet，如果被包含的Servlet还包括其他的Servlet，则这些属性名称的对应值也会被代换。
	+ javax.servlet.include.request_url
	+ javax.servlet.include.context_path
	+ javax.servlet.include.servlet_path
	+ javax.servlet.include.path_info
	+ javax.servlet.include.query_string

#### forward(）方法

+ 调用时同样传入请求与响应对象，这表示你要将请求处理转发给别的Servlet，”对客户端响应同时也转发给另一个Servlet“

	> 若要调用forward()方法，目前Servlet不能有任何响应确认(Commit)，如果在目前的Servlet中通过响应对象设置了一些响应但未确认，则所有响应设置会别忽略。如果已经有响应确认且调用了forward()方法，则会抛出IllegalStateException。

```Servlet
@WebServlet("/hello.do");
public class HelloController extends HttpServlet {
	private HellModel model = new 
	HelloModel();
	@override
	protected void doGet(HttpServletRequest request, HttpServletException response) throws ServletException, IOException {
		String name = request.getParameter("user");
		String message = model.doHello(name);
		request.setAttribute("message", message);
		request.getRequestDispatcher("hello.view").forward(request, response);
	}
}

......

public class HelloModel {
	private Map<String, String> messages = new HashMap<String, String>();
	public HelloModel() {
		messages.put("caterpillar", "Hello");
		messages.put("Justin", "Welcome");
		messages.put("momor", "Hi");
	} 

	public String doHello(String user) {
		String message = messages.get(user);
		return message + ", " + user + "!";
	}
}
```

## 关于HttpServletResponse

### 设置响应标头，缓冲区

+ 设置响应标头：setHeader()设置标头名称与值，addHeader()则可以在同一个标头名称上附加值。

    > 如果标头的值是整数，则可以试用setIntHeader(),addIntHeader()方法
    如果标头的值是个日期，则可以使用setDateHeader(),addDateHeader()方法

+ 所有的标头设置，必须在响应确认之前（Commit），在响应确认之后设置的标头，会被容器忽略。

+ 容器可以对响应进行缓冲，通常容器默认都会响应进行缓冲

    ```Java
    getBufferSize()
    setBufferSize()  // 必须在调用HttpServletResponse的getWriter()或getOutputStream()方法之前调用，所取得的 Writer或ServletOutputStream才会套用这个设置。之后调用，会抛出IllegalStateException
    
    isCommitted()  // 在缓冲区未满之前，设置的响应相关内容都不会真正传至客户端，可以试用isCommitted()看看是否响应确认
    
    reset()  // 重置所有响应内容，这回连同已设置的标头一并清除
    resetBuffer()  // 重置响应内容，但不会清除已设置的标头内容
    // reset（），resetBuffer（）必须在响应未确认前调用，否则，抛出IllegalStateException
    
    flushBuffer()  // 会清除所有缓冲区中已已设置的响应信息至可以端
    ```

+ HttpServletResponse对象若被容器关闭，则必须清除所有的响应内容，响应对象被关闭的时机有
以下几种：

    + Servlet的service()方法已结束，响应的内容长度超过HttpServletResponse的setContentLength()所设置的长度
    + 调用了sendRedirect()方法
    + 调用了sendError()方法
    + 调用了AsyncContext的complete方法

### 试用getWriter()输出字符

+ 在没用设置任何内容类型或编码之前，HttpServletResponse使用的字符编码默认是ISO-8859-1

+ 影响HttpServletResponse输出的编码处理方式

    + 设置Locale
        + 请求中有Accept-Language标头，可以使用getLocale()来取得一个Locale对象，代表客户端可接受的语系。
        + 响应，setLocale()来设置地区（Locale）信息，地区信息就包括了语系与编码信息。
            + 语系信息通常通过响应标头Content-Language来设置
            
            ```Java
            resp.setLocale(Locale.TAIWAN);
            // 将HTTP响应的Content-Language设置为zh-TW，而字符编码处理为BIG5
            
            // HttpServletResponse的getCharacterEncoding()方法取得编码设置。
            // 在web.xml中设置默认的区域与编码对应
            
            
            <locale-encoding-mapping-list>
                <locale-encoding-mapping>
                    <locale>zh_TW<locale>
                    <encoding>UTF-8<encoding>
                </locale-encoding-mapping>
            </locale-encoding-mapping-list>
            
            resp.setLocale(Locale.TAIWAN);
            // 或者是
            resp.setLocale((new Locale("zh", "TW");
            // 字符编码处理就采用UTF-8（web.xml的设置）
            ```
    
    + 使用setCharacterEncoding()或setContentType()

        ```Java
        resp.setCharacterEncoding("UTF-8);
        
        resp.setContentType("text/html; charset=UTF-8");
        // 设置内容类型为text/html,也会自动调用setCharacterEncoding(),设置编码为UTF-8
        ```
    
        + 如果使用了setCharacterEncoding()或 setContentType时指定了charset，则setLocale()就会被忽略
        + 如果要接受中文请求参数并在响应时通过浏览器正确显示中文，必须同时设置HttpServletRequest的 setCharacterEncoding()以及 HttpServletResponse的 setCharacterEncoding()或 setContentType()为正确的编码
        + 浏览器需要知道如何处理你的响应，所以必须告知内容类型 setContentType()，指定MIME（Multipurpose Internet Mail Extensions）
        
        + charset属性，常见的设置有text/html, application/pdf, application/jar, application/x-zip, image/jpeg等
        
        ```xml
            <mime-mapping>
                <extension>pdf</extension>
                <mime-type>application/pdf</mime-type>
            <mime-mapping>
        // <extension>设置文件的后缀，而<mime-type>设置对应的MIME类型名称。
        // 使用ServletContent的getMimeType()方法
        // 指定文件名称，根据web.xml 中设置的后缀对应，取得MIME类型名称
        ```
        
        ```Java
        @WebServlet("/pet")
        public class Pet extends HttpServlet {
            @Override
            protected void doPost(HttpServletResponse request, HttpServletResponse response) throws ServletException, IOException {
                request.setCharacterEncoding("UTF-8");
                response.setContentType("text/html; charset=UTF-8");
                   
                PrintWrite out = response.getWriter();
                out.println("<html>");
                out.println("<head>");
                out.println("<title>感谢填写</title>");
                out.println("</head>");
                out.println("<body>");
                out.println("联系人：<a href='mailto:" 
                + request.getParameter("email") + "'>" 
                + request.getParameter("user") + "</a>");
                out.println("<br>喜爱的宠物类型");
                out.println("<ul>");
                for(String type : request.getParameterValues("type")) { // 取得多级菜单
                out.println("<li>" + type + "</li>");
                }
                out.println("</ul>");
                out.println("</body>");
                out.println("</html>");
                out.close();
            }
        }
        ```

### 使用getOutputStream()输出二进制字符

+ 大部分情况下，会从HttpServletResponse 取得PrintWriter实例，使用println() 对浏览器进行字符输出。
+ 有时候，需要直接对浏览器进行字节输出，这时可以使用HttpServletResponse的getOutputStream实例。它是OutputStream的子类

```Java
@WebServlet("/download.do")
public class Download extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		String passwd = request.getParameter("passwd");
		if("123455".equals(passwd)) {
			response.setContentType("application/pdf");
			InputStream in = getServletContent().getResourceAsStream("/WEB-INF/jdbc.pdf");
			outputStream out = response.getOutputStream();
			WriteBytes(in, out);
		}
	}

	private void writeBytes(InputStream in, OutputStream out) throws IOException {
		byte[] buffer = new byte[1024];
		int length = -1;
		while ((length = in.read(buffer)) != -1) {
			out.write(buffer, 0, length);
		}
		in.close();
		out.close();
	}
}

// 为了取得Web应用程序中的文件串流，可以使用HttpServlet的 getServletContext()取得ServletContext对象，这个对象代表了目前这个Web应用程序，可以使用ServletContext的getResourceAsStream()方法以串流程序读取文件，制定的路径要是相对于Web应用程序环境根目录
```

### 使用sendRedirect(), sendError()

+ forward()会将请求转发至指定URL，这个动作实在Web容器中进行的，浏览器并不会知道请求被转发，地址栏也不会有变化。
+ 在转发过程中，都还是在同一个请求周期。在HttpServletResponse中使用setAttribute()设置的属性对象，都可以在转发过程中共享。

+ 使HttpServletResponse 的sendRedirect要求浏览器重新请求另一个URL，称为重定向。使用时可指定绝对URL或相对URL

```Java
response.sendRedirect("http://openhome.cc");
// 这个方法会在响应中设置HTTP状态码301以及Location标头，浏览器接收到这个标头，会重新使用GET方法请求指定的URL，因此在地址栏上会发现URL的变更。
// 由于是利用HTTP状态码与标头信息，要求浏览器重定向网页，因此这个方法必须子在响应未确认输出前执行，否则会抛出IllegalStateException

// 处理请求的过程中发现一些错误,想要传递服务器默认的状态与错误信息
// 请求参数必须返回的资源根本不存在：
response.sendError(HttpServletResponse.SC_NOT_FOUND);
// SC_NOT_FOUND会令服务器响应404状态码，这类常数定义在HttpServletResponse接口上

// 自定义文字
response.sendError(HttpServletResponse.SC_NOT_FOUND, "笔记文件");
// HttpServlet的doGet()为例，其默认实现就使用了sendError()方法
// 在响应未确认输出前执行，否则会抛出IllegalStateException
```

## 综合练习

### 微博应用程序

## 复习

+  使用forward()作请求转发，是将响应的职责转发给别的URL，所以字啊这之前不可以有实际的响应，否则会发生IllegalStateException异常

# 会话管理

## 会话基本原理

+ 记得此次请求与之后请求间关系的方式，称为会话管理
+ 实现会话管理的基本方式：
    + 隐藏域(Hidden Field),Cookie与URL重写(URL Rewriting)

### 使用隐藏域

+ 服务器不会记得两次请求间的关系，那就由浏览器在每次请求时“主动告知”服务器多次请求间必要的信息，服务器只要单纯地处理请求中的相关信息即可。
+ 可以用隐藏域的方式放在下一页的窗体中这样发送下一页窗体时，就可以一并发送这些隐藏域，每一页的问卷答案就可以保留下来。
+ 隐藏域不是Servlet/Jsp实际管理会话时的机制。

### 使用Cookie

+ Web 应用程序会话管理的基本方式，就是在此次请求中，将下一次请求时服务器应知道的信息，先响应给浏览器，由浏览器在之后的请求再一并发送给应用程序，这样应用程序就可以“得知”多次请求的相关数据。

+ Cookie 是在浏览器存储信息的一种方式，服务器可以响应浏览器 set-cookie标头，浏览器收到这个标头与数值后，会将它以文件的形式存储在计算机上。

+ 可以设定给 Cookie 一个存活期限，保留一些有用的信息在客户端。
+ 如果关闭浏览器之后，再次打开浏览器并连接服务器时，这些 cookie 仍在有效期限中，浏览器会使用 cookie 标头自动将 Cookie 发送给服务器，服务器就可以得知一些先前浏览器请求的相关信息。

+ Cookie 可以设定存活期限，所以在客户端存储的信息可以活得更久一些（除非用户主动清除 Cookie 信息）。

```Java
Cookie cookie = new Cookie("user", "caterpillar");
cookie.setMaxAge(7 * 24 * 60 * 60);// 单位是“秒”;
response.addCookie(cookie);
```

+ HTTP中 Cookie 的设定是通过 set-cookie 标头，所以必须在实际响应浏览器之前使用addCookie() 来新增 Cookie 实例。
+ Cookie 有效期限，默认关闭浏览器之后就失效。

```Java
HTTPServletResponse getCookies();// 取得属于该网页所属域（Domain）的所有Cookie，返回值是Cookie[]数组。
Cookie[] cookies = request.getCookies();
if(cookies != null) {
    for(Cookie cookie : cookies) {
        String name = cookie.getName();
        String value = cookie.getValue();
        ...
    }
}
```

+ Cookie另一个常见的应用，就是实现用户自动登录（Login）功能。

```Java
@WebServlet("/index.do")
public class Index extends HttpServlet {
	protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Cookie[] cookies = request.getCookies();
		if(cookies != null) {
			for(Cookie cookie : cookies) {
				String name = cookie.getName();
				String value = cookie.getValue();
				if("user".equals(name) && "caterpillar".equals(value)) {
					request.setAttribute(name, value);
					request.getRequestDispatcher("/user.view").forward(request, response);
					return ;
				}
			}
		}
		response.sendRedirect("login.html");// 重定向到登录窗体
	}
}

@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	processRequest(request, response);
}

@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	processRequest(request, response);
}
```

+ 自动登录

```Java
@WebServlet("/login.do")
public class Login extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	String user = request.getParameter("user");
    	String passwd = request.getParameter("passwd");
    	if("caterpillar".equals(user) && "123456".equals(passwd)) {
    		String login = request.getParameter("login");
    		if("auto".equals(login)) {
    			Cookie cookie = new Cookie("user", "caterpillar");
    			cookie.setMaxAge(7 * 24 * 60 * 60);
    			response.addCookie(cookie);
    		}
    		request.setAttribute("user", user);
    		request.getRequestDispatcher("user.view").forward(request, response);
    	}else {
    		response.sendRedirect("login.html");
    	}
    }
}
```

+ Servlet3.0 setHttpOnly()  setHttpOnly()

### 使用URL重写

+ 其实就是GET请求参数的应用，当服务器响应浏览器上一次请求时，将某些相关信息以超链接方式响应给浏览器，超链接中包括请求参数。
+ 分页

```Java
@WebServlet("/search")
public class extends HttpServlet {

...
    String start = request.getParameter("start");
    if(start == null) {
    	start ="1";
    }
    int count = Integer.parseInt(start);
    int begin = 10 * count - 9;
    int end = 10 * count;
    out.println("第 " + begin + " 到 " + end + " 搜索结果<br>");
    out.println("<ul>");
    for(int i = 1; i <= 10 ; i++) {
    	out.println("<li>搜寻结果" + i + "</li>");
    }
    out.println("</ul>");
    for(int i = 1; i < 10; i++) {
    	if(i == count) {
    		out.println(i);
    		continue;
    	}
    	out.println("<a href='search?start=" + i + "'>" + i + "</a");
    }
...

}
```

## HttpSession会话管理

### 使用HttpSession

```Java
HttpSession session = request.getSession();

// 另一个版本
// 传入布尔值，默认值时true，表示若尚未存在HttpSession实例时，直接创建一个对象。
// 若传入false，若尚未存在HttpSession实例，则直接返回null

HttpSession setAttribute() getAttribute()
// 这是存放属性对象的第二个地方
// 第三个地方是在ServletContext中
```

+ 忽略HTTP无状态特性，省略亲手对浏览器发送隐藏域的HTML的操作
+ 如果想在此次会话期间，直接让目前的HttpSession失效，可以执行HttpSession的invalidate()方法(注销机制)，执行invalidate()之后，再次getSession()，取得HttpSession就是另一个新对象了。
+ HttpSession并非线程安全，所以必须注意属性设定时共享存取的问题。

### HttpSession会话管理原理

+ 尝试运行 HttpServletRequest 的 getSession 时，Web容器会创建 HttpSession 对象，关键在于每个HttpSession对象都会有个特殊的 ID，Session ID，HttpSession的getId() 来取得Session ID。这个 Session ID 默认会使用Cookie存放在浏览器中。
+ 在Tomcat中，Cookie 的名称是 JSESSIONID，数值是getId()所取得的Session ID

+ 由于Web容器本身是执行于JVM中的一个Java程序，getSession()取得HttpSession，是Web容器中的一个Java对象，HttpSession中存放的属性，自然也就存放于服务器端的Web容器之中。
+ 每一个 HttpSession 各有特殊的 Session ID，当浏览器请求应用程序时，会将 Cookie 中存放的 Session ID 一并发送给应用程序，Web 容器会根据 Session ID来找出对应的HttpSession 对象。


+ 所以使用 HttpSession 来进行会话管理，设定为属性的对象时存储在服务器端，而 Session ID 默认使用 Cookie 存放于浏览器端。Web 容器存储 Session ID 的 Cookie "默认" 为关闭浏览器就实效，所以重新启动浏览器请求应用程序时，通过 getSession() 取得的是新的 HttpSession 对象。

+ 每次请求来到应用程序时，容器会根据发送过来的 Session ID 取得对应的 HttpSession。由于 HttpSession 对象会占用内存空间，所以 HttpSession 的属性中尽量不要存储耗资源的大型对象，必要时将属性移除，或者不需使用 HttpSession 时，执行 invalidate() 让 HttpSession 实效。

+ 默认关闭浏览器会马上失效的是浏览器上的 Cookie，不是 HttpSession。
+ 要让 HttpSession 立即失效，必须运行 invalidate() 方法，否则，HttpSession 会等到设定的失效期间过后才会被容器销毁回收

```Java
// HttpSession的 setMaxInactiveInterval()
// 设定浏览器多久没有请求应用程序的话，浏览器端的HttpSession对象就自动失效，设定的单位是秒。
// web.xml中设定失效时间的单位是分钟。
// 存储Session ID的Cookie默认为关闭浏览器就失效，，而且仅用于存储Session ID
<web-app>
	<session-config>
		<session-timeout>30</session-timeout>
	<session-config>
</web-app>
```

+ SessionCookieConfig接口，通过实现的对象，可以设定存储Session ID的Cookie相关信息
+ 另一个方法是实现ServletContextListener

### HttpSession与URL重写

+ 用户禁用 Cookie 的情况下，仍打算运用 HttpSession 进行会话管理，可以搭配  重写，向浏览器响应一段超链接，超链接 URL 后附加 Session ID，当用户点击超链接，将 Session ID 以 GET 请求发送给 Web 应用程序

+ encodeURL() 会自动产生带有 Session ID 的 URL 重写(如果没禁用Cookie，则显示原URL)
+ 使用encodeURL()，在浏览器第一次请求网站时，容器不知道浏览器是否禁用Cookie，容器的做法是Cookie(set-cookie标头)与URL重写的方式。无论浏览器有无禁用Cookie，第一次请求时，都会显示在Session ID的URL

+ encodeRedirectURL()方法，则可以在要求浏览器重定向时，在URL上显示Session ID

## 综合练习

### 修改微博应用程序

# Servlet进阶API,过滤器与监听器

## Servlet进阶API

### Servlet, ServletConfig 与 GenericServlet 

+ GenericServlet主要的目的就是将初始Servlet调用 init()方法传入ServletConfig封装起来。
+ GenericServlet在实现Servlet的 init()方法时，也调用了另一个无参数的init()方法，在编写Servlet时，如果有一些初始时所要运行的动作，可以重新定义这个无参数的init()方法，而不是直接重新定义有ServletConfig参数的init()方法

### 使用ServletConfig

```Java
@WebServlet(name="ServletOConfigDemo", urlPatterns={"/conf"}, 
		initParams={
			@WebInitParam(name = "PARAM1", value = "VALUE1"),
			@WebInitParam(name = "PARAM2", value = "VALUE2")
		}
)
public class ServletConfigDemo extends HttpServlet {
	private String PARAM1;
	private String PARAM2;
	public void init() throws ServletException {
		PARAM1 = getServletConfig().getInitParameter("PARAM1");
		PARAM2 = getServletConfig().getInitParameter("PARAM2");
	}
	...
}

OR

<Servlet>
    <Servlet-name>ServletConfigDemo</Servlet-name>
    <servlet-class>cc.openhome.ServletConfigDemo</servlet-class>
    <init-param>
        <param-name>PARAM1</param-name>
        <param-value>VALUE1</param-value>
    </init-param>
</Servlet>
// 若要用web.xml覆盖标注设置，web.xml的<servlet-name>设置必须与@WebServlet的name属性相同

// GenericServlet将ServletConfig封装起来，便于取得设置信息
@WebServlet(name="ServletOConfigDemo", urlPatterns={"/conf"}, 
		initParams={
			@WebInitParam(name = "PARAM1", value = "VALUE1"),
			@WebInitParam(name = "PARAM2", value = "VALUE2")
		}
)
public class AddMessage extends HttpServlet {
	private String PARAM1;
	private String PARAM2;
	public void init() throws ServletException {
		PARAM1 = getInitParameter("PARAM1");
		PARAM2 = getInitParameter("PARAM2");
	}
	...
}
```

### ServletContext

+ 当整个Web应用程序加载Web容器之后，容器会生成一个ServletContext对象，作为整个应用程序的代表，并设置给ServletConfig，只要通过ServletConfig的 getServletContext()方法就可以取得ServletContext对象。

    + getRequestDispatcher()
    
        > 取得RequestDispatcher实例
        使用时路径的指定必须以“/”作为开头，这个斜杠代表应用程序环境根目录(Context Root)
        
    + getResourcePaths()

        > Web应用程序的某个目录中有哪些文件
        使用时路径的指定必须以“/”作为开头，表示相对于应用程序环境根目录
        
    + getResourceAsStream()

        > 读取某个文件的内容
        
## 应用程序事件,监听器

### ServletContext事件，监听器

+ ServletContextListener // 生命周期监听器

    + contextInitialized(ServletContext sce)
    + contextDestroyed(ServletContext sce)

    ```Java
    @WebListener// 没有设置初始参数的属性，需要设置，在Web.xml中设置
    public class contextInitialized(ServletContextEvent sce) {
        public void contextInitialized(ServletContextEvent sce) {
            ServletContext context = sce.getServletContext();
            String avatars = context.getInitParameter("AVATAR");
            context.setAttribute("avatars", avatars);
        }
        public void contextDestroyed(ServletContextEvent sce) {} 
    }
    
    ServletContext
        setAttribute()
        getAttribute()
        removeAttribute()
    ```

+ ServletContextAttributeListener // 监听属性改变的监听器

    + attributeAdded(ServletContextAttributeEvent scab)
    + attributeRemoved(ServletContextAttributeEvent scab)
    + attributeReplaced(ServletContextAttributeEvent scab)

    ```Java
    <listener>
        <listener-class>cc.openhome.SomeContextAttrListener</listener-class>
    </listener>
    ```

### HttpSession事件，监听器

+ HttpSessionListener // 在HttpSession对象创建或结束时

    + sessionCreated(HttpSessionEvent se)
    + sessionDestroyed(HttpSessionEvent se)

+ HttpSessionAttributeListener // 属性改变监听器

    + attributeAdded(HttpSessionBindingEvent se)
    + attributeRemoved(HttpSessionBindingEvent se)
    + attributeReplaced(HttpSessionBindingEvent se)

+ HttpSessionBindingListener // 对象绑定监听器

    + valueBound(HttpSessionBindingEvent event)
    + valueUnbound(HttpSessionBindEvent event)

+ HttpSessionActivationListener // 对象迁移监听器

    + sessionWillPassivate()
    + sessionDidActivate()

### HttpServletRequest事件，监听器

+ ServletRequestListener

    + requestDestroyed(ServletRequestEvent sre)
    + requestInitialized(ServletRequestEvent sre)

+ ServletRequestAttributeListener

    + attributeAdded(ServletRequestAttributeEvent srae)
    + attributeRemoved(ServletRequestAttributeEvent srae)
    + attributeReplaced(ServletRequestAttributeEvent srae)

        > ServletRequestAttributeEvent
        getName()，取得属性设置或移除时指定的名称
        getValue()，取得属性设置或移除时的对象
    
+ 生命周期监听器与属性改变监听器都必须使用@WebListener或在web.xml中设置，容器才会知道要加载，读取监听器相关设置

## 过滤器

    + 可以真正运行Servlet的service()方法“前”与Servlet的service()方法运行&#39“后”中间进行实现
    + 将服务需求设计为可抽换的元器件
    + 在请求转发时应用过滤器

### 实现与设置过滤器

+ 必须实现Filter接口，并使用@WebFilter标注或在Web.xml中定义过滤器，让容器知道加载哪些过滤器类
+ Filter
    + init(FilterConfig filterConfig) throws ServletException
    + doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException;
    + destroy();

```Java
Filter filter = filterIterator.next();
if(filter != null) {
    filter.doFilter(request, response, this);
}else {
    targetServlet.service(request, response);
}
```

+ 在陆续调用完Filter实例的doFilter仍至Servlet的service()之后，流程会以堆栈顺序返回，所以在FilterChain的doFilter()运行完毕后，就可以针对service()方法做后续处理

```Java
@WebFilter(filterName="performance", urlPattern={"/*"})
public class PerformanceFilter implements Filter {
	private FilterConfig config;

	@Override
	public void init(FilterConfig config) throws ServletException {
		this.config = config;
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		long begin = System.currentTimeMillis();
		chain.doFilter(request, response);
		config.getServletContext().log("Request process in " + (System.currentTimeMillis() - begin) + "milliseconds");
	}

	@Override
	public void destroy() {}
}
```

+ 出发过滤器的时机，默认时浏览器直接发出请求。

```Java
@WebFilter{
	filterName="some",
	urlPatterns={"/some"},
	dispatcherType={
		DispatcherType.FORWARD,
		DispatcherType.INCLUDE,
		DispatcherType.REQUEST,
		DispatcherType.ERROR,
		DispatcherType.ASYNC
	}
}
// 不设置dispatcherTypes,则认为REQUEST
```

+ 如果同时具备<url-pattern>与<servlet-name>，则先比对<url-pattern>，在比对<servlet-name>。

### 请求封装器

+ 实现字符替换过滤器

    > HttpServletRequestWrapper实现了HttpServletRequest,继承自ServletRequestWrapper
    
    ```Java
    public class EscapeWrapper extends HttpServletRequestWrapper {
        public EscapeWrapper(HttpServletRequest request) {
            super(request);
        }
    
        @Override
        public String getParameter(String name) { // 重新定义getParameter方法
            String value = getRequest().getParameter(name);
            return StringEscapeUtils.escapeHtml(value); // Apache Commons Lang／ 进行文字替换
        }
    }
    ```
    
    ```Java
    @WebFilter("/")
    public class EscapeFilter implements Filter {
        public void init(FilterConfig fConfig) throws ServletException {}
        public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
            HttpServletRequest requestWrapper = new EscapeWrapper((HttpServletRequest) request);
            chain.doFilter(requestWrapper, response);
        }
        public void destroy() {}
    }
    ```
    
+ 实现编码设置过滤器

    ```Java
    
    public class EncodingWrapper extends HttpServletRequestWrapper {
        private String ENCODING;
        public EncodingWrapper(HttpServletRequest request, String ENCODING) {
            super(request);
            this.ENCODING = ENCODING;
        }
    
        @Override
        public String getParameter(String name) {
            String value = getRequest().getParameter(name);
            if(value != null) {
                try {
                    byte[] b = value.getBytes("ISO-8859-1");
                    value = new String(b, ENCODING);
                }catch(UnsupportedEncodingException e) {
                    throw new RuntimeException(e);
                }
            }
            return value;
        }
    }
    ```
    
    ```Java
    @WebFilter(
    	urlPattern = { "/*"},
    	initParams = {
    		@WebInitParam(name = "ENCODING", value = "UTF-8")
    	}
    )
    public class EncodingFilter implements Filter {
    	private String ENCODING;
    	public void init(FilterConfig) throws ServletException {
    		ENCODING = config.getInitParameter("ENCODING");
    	}
    	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
    		HttpServletRequest req = (HttpServletRequest) request;
    		if("GET".equals(req.getMethod())) {
    			req = new EncodingWrapper(req, ENCODING);
    		}else {
    			req.setCharacterEncoding(ENCODING);
    		}
    		chain.doFilter(req, response);
    	}
    	public void destroy() {}
    }
    ```
### 响应过滤器

+ HttpServletResponseWrapper(父类ServletResponseWrapper)
+ 若要对浏览器进行输出响应，必须通过getWriter()取得PrintWriter，或是通过getOutputStream取得ServletOutputStream

+ 压缩输出





#JSP

## 从JSP到Servlet

### JSP生命周期

	+ _jspInit(), _jspDestroy(), _jspService(),转移后重新定义。转译后的Servlet是继承自HttpJSPBase类，HttpJspBase类继承自HttpServlet
	+ 自定义可以重新定义jspInit(), jspService, jspDestroy

### Servlet至JSP的简单转换

### 指示元素

+ JSP指示(Directive)a元素的主要目的，在于指示容器将JSP转译为Servlet源代码时，一些必须遵守的信息。

	```JSP
	<%@ 指示类型 [属性="值"]* %>
	```

+ 常用的指示类型：page, include, taglib
	+ page指示类型告知容器如何转译目前的JSP网页
	+ include指示类型告知容器将别的JSP页面包括进来进行转译
	+ taglib指示类型告知容器如何转译这个页面的标签库(Tag Library)

+ 指示元素中可以有多对的属性/值，必要时，同一个指示类型可以数个指示元素来设置。

	+ page

		```JSP
		<%@page import="java.util.Date" %>
		<%@page contentType="text/html" pageEncoding="UTF-8"%>

		//import属性转译后在Servlet源代码中
		<%@page import="java.util.Date,cc.openhome.*" %>

		//response.setContentType("text/html;charset=UTF8");
		//可以编写在同一个元素中
		```

		+ page指示类型其他属性
			+ info
			+ autoFlush
			+ buffer
			+ errorPage
			+ extends
			+ isErrorPage
			+ language
			+ session

	+ include

		```JSP
		<%@page contentType="text/html" pageEncoding="UTF-8" %>
		<%@include file="/WEB-INF/jspf/header.jspf" %>
		//在转译期间就决定转译后的Servlet内容，静态包括方式
		//<jsp:include>标签的使用，则是运行时动态包括别的网页执行流程进行相应的方式，使用<jsp:include>的网页与被<jsp:include>包括的网页，各自都生成一个独立的Servlet
		```

+ 可以在web.xml中统一默认的网页编写，内容类型，缓冲区大小等。

	```XML
	<web-app>
		<jsp-config>
			<jsp-property-group>
				<url-pattern>*.jsp</url-pattern>
				<page-encoding>UTF-8</page-encoding>
				<default-content-type>text/html</default-content-type>
				<buffer>16kb</buffer>
			</jsp-property-group>
		</jsp-config>
	</web-app>

	//声明JSP的开头与结尾
	<web-app>
		<jsp-config>
			<jsp-property-group>
				<url-pattern>*.jsp</url-pattern>
				<include-prelude>/WEB-INF/jspf/pre.jspf</include-prelude>
				<include-coda>/WEB-INF/jspf/coda.jspf<include-coda>
			</jsp-property-group>
		</jsp-config>
	</web-app>
	```

### 声明，Scriptlet与表达式元素

	```JSP
	//声明(Declaration)元素
	<%! 类成员声明或方法声明 %>
	// 转译成Servlet中的类成员或方法
	//小心数据共享与线程安全的问题
	//jspInit()方法，jspDestroy()的方法通过这个进行初始化操作

	//Scriptlet元素
	<% Java语句 %>
	//转译后为Servlet源代码_jspService()方法中的内容

	// 表达式元素
	<%= Java表达式 %>
	<%= new Date() %>
	// 表达式元素中不要加上分号(;)
	//转译Servlet
	out.print(new Date());//表达式中的内容会直接转译为out对象输出时的指定内容
	```

+ 输出<%或%>符号，要将角括号置换为其他字符。<%-&lt;%  %>-%&gt;或%\>
+ 禁用JSP的Scriptlet，在web.xml中设置<scripting-invalid>true</..

### 注释元素

+ 使用Java注释的方式(// /*...*/)，在Servlet源代码中也有对应的注释文字
+ 使用HTML网页使用的注释方式<!-- -->，HTML源代码中有
+ 使用JSP专门的注释<%-- JSP注释 --%>，转译到Servlet中不会包括注释文字，也不会输出到浏览器

### 隐式对象/隐式变量

+ out: 转译后对应JspWriter对象，其内部关联一个PrintWriter对象

	+ JspWriter直接继承于java.io.Writer类。JspWriter主要模拟了BufferedWriter与PrintWriter的功能

+ request: 转译后对应HttpServletRequest对象
+ response: 转译后对应HttpServletResponse对象
+ config: 对应ServletConfig对象
+ application: 对应ServeltContext对象
+ session: 对应HttpSession对象
+ pageContext: 对应PageContext对象，它提供了JSP页面资源的封装，并可设置页面范围属性

	+ javax.servlet.jsp.PageContext
	+ 所有隐式参数都可以通过pageContext来取得。
	+ 设置页面范围属性(setAttribute(),getAttribute(),removeAttribute())
	+ 页面范围属性表示作用范围仅限同一个页面中

	```java
	<%
		Some some = pageContext.getAttribute("some");
		if(some == null) {
			some = new Some();
			pageContext.setAttribute("some", some);
		}
	%>

	// 通过pageContext设置四种范围属性
	getAttribute(String name, int scope)
	setAttribute(String name, Object value, int scope)
	removeAttribute(String name, int scope)

	//scope常量：pageContext.PAGE_SCOPE, pageContext.REQUEST_SCOPE, pageContext.SESSION_SCOPE, pageContext.APPLICATION_SCOPE

	//不知道属性范围
	pageContext.findAttribute();//依次从页面，请求，会话，应用程序范围寻找有无对应的属性，先找到就先返回

	Object attr = pageContext.findAttribute("attr");
	```

+ exception: 对应Throwable对象，代表由其他JSP页面抛出的异常对象，只会出现与JSP错误页面(isErrorPage设置为true的JSP页面)
+ page: 对应this

+ 隐式对象时只能在<%与%>之间，或<%=与%>之间使用，转译后Servlet后，是_jspService()中的局部变量。

### 错误处理

+ 错误发生在三个时候
	+ JSP转换为Servlet源代码时。
	+ Servlet源代码进行编译时。
	+ Servlet载入容器进行服务但发生运行错误时。

+ 只有在isErrorPage设置为true的页面才可以使用exception隐式对象。
	+ <%=exception %>
	+ 打印异常堆栈跟踪，printStackTrace()接受一个PrintWriter对象作为参数，out构造PrintWriter

	```xml
	// 异常对象
	<web-app>
		<error-page>
			<exception-type>java.lang.NullPointerException</exception-type>
			<location>/report.view</location>
		</error-page>
	</web-app>

	// HTTP错误状态码
	<web-app>
		<error-page>
			<error-code>404</error-code>
			<location>/404.jsp</location>
		</error-page>
	</web-app>
	```

## 标准标签(Standard Tag)

+ 所有容器都支持这些标签，可协助编写JSP时减少Scriptlet的使用。所有标准标签都使用jsp:作为前置

### `<jsp:include>`, `<jsp:forward>`标签

### `<jsp:useBean>`, `<jsp:setProperty>`与`<jsp:getProperty>`简介

+ <jsp:useBean>标签是用来搭配JavaBean元件的标准标签。

+ JavaBean
	+ 必须实现java.io.Serializable接口
	+ 没有公共(public)的类变量
	+ 具有无参数的构造器
	+ 具有公开的设值方法(Setter)与取值方法(Getter)

### 深入`<jsp:useBean>`, `<jsp:setProperty>`与`<jsp:getProperty>`

+ 在使用`<	jsp:useBean>`标签取得或创建JavaBean实例之后，由于`<jsp:setProperty>`与`<jsp:getProperty>`转译后的，都是使用PageContext的findAttribute()来寻找属性，因此寻找的顺序是页面，请求，会话，应用程序范围。

### 谈谈Model1

### XML格式标签

## 表达式语言(EL)

### EL简介

+ 以进行属性，请求参数，标头与Cookie等信息的取得，或一些简单的运算或判断，试着用EL来代替

```JSP
<%
	String a = request.getParameter("a");
	String b = request.getParameter("b");
	out.println("a + b = " + (Integer.parseInt(a) + Integer.parseInt(b)));
%>

${param.a} + ${param.b} = ${param.a + param.b}
// param是EL隐式对象之一，表示用户的请求参数
//对于null值直接以空字符串加以显示

<%= ((HttpServletRequest) pageContext.getRequest()).getMethod() %>
${pageContext.request.method}
```

+ page指示元素的isELIgnored属性(默认是false)，来设置是否使用EL。原因在于，网页中已含有与EL类似的${}语法功能存在

+ web.xml是2.3或以下版本不支持EL

### 使用EL取得属性

	```JSP
	<h1><jsp:property name="user" property="name">登录成功<h1>

	<h1>${user.name>登录成功</h1>

	// EL隐式对象指定范围来存取属性。
	```

+ 运算符说明
	+ 如果使用点(.)运算符，则左边可以是JavaBean或Map对象
	+ 如果使用[]运算符，则左边可以是JavaBean，Map，数组或List对象

### 缺页

### EL运算符

+ EL可以直接进行一些算术运算，逻辑运算与关系运算。

+ 除法(/或div)，求模(%或mod)，小于(<或lt(Less-than))，大于(>或gt(Greater-than))，小于或等于(<=或le)，大于或等于(>=或ge(Greater-than-or-equal))，等于(==或eq(Equal))，不等于(!=或ne(Not-equal))

+ 自定义EL函数

```JSP
<%= Util.length(request.getAttribute("someList))%>
${ util: length(requestScope.someList) }
```

+ 自定义EL函数的第一步是编写类，它必须是个公共类，而想要调用的方法必须是公开且为静态方法。
+ 必须编写一个标签程序库描述(TLD)文件，这个文件是个XML文件，后缀为*.tld，让Web容器知道怎么将这个类中的length()方法当做EL函数来使用。

	```XML
	//openhome.tld
	<?xml version="1.0" encoding="UTF-8"?>
	<taglib version="2.1" xmlns="http://java.sun.com/xml/ns/javaee"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xsi:schemaLication="http://java.sun.com/xml/ns/javaee
		http://java.sun.com/xml/ns/javaee/web-jsptaglibrary_2_1.xsd">
		<tlib-verion>1.0</tlib-version>
		<short-name>openhome</short-name>
		<uri>http://openhome.cc/util</url>//JSP网页中会用到
		<function>
			<description>Collection Length</description>
			<name>length</name>
			<function-class>
				cc.openhome.Util
			</function-class>
			<function-signature>
				int length(java.util.Collection)
			</function-signature>
		</function>
	</taglib>

	//elfunction.jsp
	<%@page contentType="text/html" pageEncoding="UTF-8"%>
	<%@taglib prefix="util" uri="http://openhome.cc/util"%>
	```

### 复习

+ `<jsp:include>`或`<jsp:forward>`标签，在转译为Servlet源代码之后，底层也是取得RequestDispatcher对象，并执行对应的forward()或include()方法

# 使用JSTL

## 简介

+ JSTL标签库
	+ 核心标签库：提供条件判断，属性访问，URL处理及错误处理等标签。
	+ I18N兼容格式标签库：提供数字，日期等的格式化功能，以及区域(Locale)，信息，编码处理等国际化功能的标签。
	+ SQL标签库：提供基本的数据库查询，更新，设置数据源(DataSource)等功能的标签.
	+ XML标签库：提供XML解析，流程控制，转换等功能的标签。
	+ 函数标签库：提供常用字符串处理的自定义EL函数标签库。

	```XML
	<taglib>
		<taglib-uri>http://java.sun.com/jstl/core/</taglib-uri>
		<taglib-location>/WEB-INF/tlds/c.tld</taglib-location>
	</taglib>

	//JSP
	<%@taglib prefix="c" uri="http://java.sun.com/jstl/core"%>
	```

## 核心标签库

### 流程处理标签

```JSP
<c:if test="${param.name == 'momor' && param.password == '1234'}">
	<h1>${param.name} 登录成功</h1>
</c:if>

<c:choose>
	<c:when test="${user.valid}">
		<h1>
			<jsp:getProperty name="user" property="name"/>登录成功
		</h1>
	</c:when>
	<c:otherwise>
		<h1>登录失败</h1>
	</c:otherwise>
</c:choose>
// <c:when>,<c:otherwise>必须放在<c:choose>中
// <c:choose>中可以有多个<c:when>,遇到true就输出
 
<c:forEach var="message" items="${messageService.messages}">
	<tr>
		<td>${message.name}</td>
		<td>${message.text}</td>
	</tr>
</c:forEach>
// items属性可以是数组，Collection，Iterator，Enumeration，Map与字符串

//items指定的是Map
//则设置给var的对象会是Map.Entry，这个对象有getKey()与getValue()方法，可以让你取得键与值
<c:forEach var="item" items="${someMap}">
	Key: ${item.key}<br>
	Value: ${item.value}<br>
</c:forEach>

//items指定字符串，则必须是个以逗号区隔的值，<c:forEach>会自动以逗号来切割字符串
<c:forEach var="token" items="Java,C++,C,JavaScript">
	${token} <br>
</c:forEach>

//自行指定切割依据，使用<c:forTokens>
<c:forTokens var="tolen" delims=":" items="Java:C++:C:JavaScript">
	${token} <br>
</c:forTokens>
```

### 错误处理标签

+ 在目前网页捕捉异常，并显示相关信息。Java的try-catch / `<c:catch>`

```JSP
<c:catch var="error">
	${param.a} + ${param.b} = ${param.a + param.b}
</c:catch>
<c:if test="${error != null}">
	<br><span style="color: red;">${error.message}</span>
	<br>${error}
</c:if>
```

### 网页导入，重定向，URL处理标签

+ `<c:import>`标签，可以视作是`<jsp:include>`的加强版，可以在运行时动态导入另一个网页，也可以搭配`<c:param>`在导入另一网页时带有参数。

	```JSP
	<c:import url="add.jsp">
		<c:param name="a" value="1" />
		<c:param name="b" value="2" />
	</c:import>

	// <c:import>标签还好可以导入非目前Web应用程序中的网页
	<c:import url="http://openhome.cc" charEncoding="BIG5" />
	```

+ `<c:redirect>`标签，重定向需要参数，也可以通过<c:param>来设置

+ url重写`<c:url>`

	```JSP
	<c:url value='count.jsp' />
	```

### 属性处理与输出标签

+ `<c:set>`

+ `<c:remove>`

+ `<c:out>`，属性escapeXml(自动将角括号，单引号，双引号等字符用替代字符取代。)默认为true。

+ EL运算结果为null时，并不会显示任何值。希望在EL为null时，显示一个默认值。

	```JSP
	<c:choose>
		<c:when test="${param.a != null}">
			${param.a}
		</c:when>
		<c:otherwise>
			0
		</c:otherwise>
	</c:choose>

	//或:
	<c:out value="${param.a}" default="0" />
	```

## I18N兼容格式标签库

+ 如果一个应用程序在设计时，可以在不修改应用程序的情况下，根据不同的用户直接采用不同的语言，数字格式，日期格式等，这样的设计考量称为国际化。(I18N，因为internationalization有18个字母)

### I18N基础

+ Java的字符串是Unicode，`java -encoding UTF-8 Main.java`

+ java.util.ResourceBundle消息绑定

	```Java
	// messages.properties// 放在Classpath的路径设置下
	cc.openhome.welcome=Hello
	cc.openhome.name=World

	// Hello.java
	public class Hello {
		public static void main(String[] args) {
			ResourceBundle res = ResourceBundle.getBundle("messagea");// 自动找对应的.properties
			System.out.print(res.getString("cc.openhome.welcome") + "!");
			System.out.println(res.getString("cc.openhome.name") + "!");
		}
	}
	```

+ 关于国际化

+ 地区(Locale)信息，资源包(Resource bundle)与基础名称(Base name)

+ 语言编码由两个小写字母代表，地区编码由两个大写字母代表

	```Java
	Locale locale = new Locale("zh", "CN");
	ResourceBundle res = ResourceBundle.getBundle("messages", locale);
	```

### 信息标签

```JSP
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:bundle basename="messages1">
<fmt:message key="cc.openhome.title" />

//<fmt:setBundle>标签设置basename属性，设置的作用域是整个页面都有作用。如果额外有<fmt:bundle>设置，则会以<fmt:bundle>的设置为主。
```

+ 占位符

	```JSP
	// messages3.properties
	cc.openhome.forUser=Hi! {0}! It is {1, date, long} and {2, time, full}

	fmt3.jsp
	<jsp:useBean id="now" class="java.util.Date"/>
	<fmt:setBundle basename="messages3"/>

		<fmt:message key="cc.openhome.forUser">
			<fmt:param value="${param.username}"/>
			<fmt:param value="${now}"/>
			<fmt:param value="${now}"/>
		</fmt:message>
	```

### 地区标签

	```JSP
	<fmt:setLocale value="zh-TW"/> // 调用HttpServletResponse的setLocale()
	<fmt:setBundle basename="hello"/>

	<fmt:message key="cc.openhome.hello"/>

	// 如果使用了setCharacterEncoding()或setContentType()时指定了charset,则setLocale()就会被忽略。
	// <fmt:requestEncoding>设置编码，就会调用HttpServletRequest的setCharacterEncoding()，必须在取得任何请求参数之前使用

	<%
		ResourceBundle zh_TW = ResourceBundle.getBundle("hello", new Locale("zh", "TW"));
		pageConetext.setAttribute("zh_TW", new LocalozationContext(zh_TW));
	%>
	<fmt:message bundle="${zh_TW}" key="cc.openhome.hello"/>

	// <fmt:message>标签有个bundle属性，可用以指定LocalizationContext对象，可以在创建LocalizationContext对象时指定ResourceBundle与Locale对象。
	//共享Locale信息，可以使用<fmt:setLocale>标签，value属性上指定地区信息。
	```

+ JSTL规格书

### 格式标签

+ 针对数字，日期与时间，搭配地区设置或指定的格式来进行格式化，也可以进行数组，日期与时间的解析。

	```JSP
	<jsp:useBean id="now" class="java.util.Date"/>

	<fmt:formatDate value="${now}" dateStyle="full" type="time" timeStyle="full" pattern="dd.MM.yy"/>
	// dateStyle，日期的详细程度，可设置的值有"default","short","medium","long","full"
	// type，如果显示时间，则要在type属性指定"time"或"both",默认是"date"
	// timeStyle，时间的详细程度，可设置的值有"default","short","medium","long","full"
	// pattern，自定义格式

	<fmt:timeZone value="GMT+1:00">
		<fmt:formatDate value="${now}" type="both" dateStyle="full" timeStyle="full"/>
	</fmt:timeZone>
	// <fmt:timeZone>可指定时区
	//需要全局指定时区，<fmt:setTImeZone>
	// 没有指定地区会根据浏览器的Accept-Language标头来决定地区

	<fmt:formatNumber value="12345.678" type="currency" currencySymbol="新台币" pattern="#,#00.0#">
	//type，可设置值"number"(默认), "currency"(数字按照货币格式进行格式化), "percent"(百分比)
	//currencySymbol，可指定货币符号
	```

+ 解析`<fmt:parseDate>`,`<fmt:parseNumber>`

+ 格式化标签寻找地区信息的顺序是：
	1. 使用<fmt:bundle>指定的地区信息
	2. 寻找LocalizationContext中的地区信息，也就是属性范围中有无javax.servlet.jsp.jstl.fmt.localizationContext属性
	3. 使用浏览器Accept-Language标头指定的偏好地区
	4. 使用后备地区信息

## XML标签库

## 函数标签库

```JSP
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/function"%>
${fn:length(param.text)}
```

+ 字符串处理相关好函数
	+ 改变字符串大小写：toLowerCase, toUpperCase
	+ 取得子字符串：substring, substringAfter, substringBefore
	+ 裁剪字符串前后空白：trim
	+ 字符串取代： replace
	+ 检查是否包括子字符串：startsWith, endsWith, contains, containsIgnoreCase
	+ 检查子字符串位置：indexOf
	+ 切割字符串为字符串数组：split
	+ 连接字符串数组为字符串：join
	+ 替换XML字符：escapeXML

# 自定义标签

# 整合数据库

## JDBC入门

### JDBC简介

+ 编写的应用程序是利用网络通信协议与数据库进行命令交换，以进行数据的增删改查。通常应用程序会利用一组专门与数据库进行通行协议的程序库，以简化与数据库沟通是的程序编写。

+ JDBC(Java DataBase Connectivity)Java数据库连接的标准规范。定义了一组标准类与接口，应用程序需要连接数据库时就调用这组标准API，而标准API中的接口会由数据库厂商实现，通常称为JDBC驱动程序(Driver)。

+ JDBC标准主要分为两个部分：JDBC应用程序开发者接口以及驱动程序开发者接口。
	+ 应用程序开发者接口相关API主要在java.sql与javax.sql两个包中
	+ JDBC驱动程序开发者接口则是数据库厂商要实现驱动程序时的规范。

+ 要取得数据库连接，几个操作
	1. 注册Driver实现对象
		+ 使用JDBC时，要求加载.class文件的方式有四种：
			+ 使用Class.forName()

				```Java
				//动态加载驱动程序类
				try {
					Class.forName("com.mysql.jdbc.Driver");
				}catch(ClassNotFoundException e) {
					throw new RuntimeException("找不到指定的类")；
				}

				// MySQL的Driver类实现源代码
				public class Driver extends NonRegisteringDriver implements java.sql.Driver {
					static {
						try {
							// 注册Driver实例的操作
							java.sql.DriverManager.registerDriver(new Driver());
						}catch(SQLException E) {
							throw new RuntimeException("Can't register driver!");
						}
					}
				}
				public Driver() throws SQLException {}
				```

			+ 自行创建Driver接口实现类的实例

				```Java
				java.sql.Driver driver = new com.mysql.jdbc.Driver();
				```

			+ 启动JVM时指定jdbc.drivers属性

				```shell
				java -Djdbc.drivers=com.mysql.jdbc.Driver;ooo.XXXDriver YourProgram
				```

			+ 设置JAR中 /services/java.sql.Driver文件
				+ Java SE 6之后JDBC 4.0的新特性，只要在驱动程序实现的JAR文件/services文件夹中，放置一个java.sqlDriver文件，当中编写Driver接口的实现类名称全名，DriverManager会自动读取这个文件并找到指定类进行注册。
	2. 取得Connection实现对象

		```Java
		// Connection接口的实现对象，是数据库连接代表对象。
		Connection conn = DriverManager.getConnection(jdbcUrl, username, password);
		// JDBC URL 定义了连接数据库时的协议，子协议，数据源标识：
		// 协议：子协议：数据源标识
		// 数据源标识标出数据库的地址，端口，名称，用户，密码等信息
		// mysql
		jdbc:mysql://主机名称:连接端口/数据库名称？参数=值&参数=值

		// 主机名称可以是本机(localhost)或其他连接主机名称，地址。Mysql连接端口默认为3306。
		jdbc:mysql://localhost:3306/demo?usere=root&password=123456

		// 如果要使用中文访问(假设数据库表格编码使用UTF-8)
		jdbc:mysql://localhost:3306/demo?user=root&password=123&useUnicode=true&characterEncoding=UTF8

		// 有时会将JDBC URL编写在XML配置文档中，此时不能直接在XML中写&符号，而必须改写为&amp;代替字符
		jdbc:mysql://localhost:3306/demo?user=root&password=123&userUnicode=true&amp;
		characterEncoding=UTF8
		```

		+ 直接通过DriverManager的getConnection()连接数据库

			```Java
			Connection conn = null;
			SQLException ex = null;
			try {
				String url = "jdbc:mysql://localhost:3306/demo";
				String user = "root";
				String password = "123456";
				conn = DriverManager.getConnection(url, user, password);
				...
			}
			catch(SQLException e) {
				ex = e
			}
			finally {
				if(conn != null) {
					try {
						conn.close();
					}
					catch(SQLException e) {
						if(ex == null) {
							ex = e;
						}
					}
				}
				if(ex != null) {
					throw new RuntimeException(ex);
				}
			}

			// SQLException 是受检异常(Checked Exception)必须使用try... catch明确处理，在异常发生时尝试关闭相关资源

			// SQLException有个子类SQLWarning(警示信息)
			```

	3. 关闭Connection实现对象
		+ 取得Connection对象之后，可以使用isClosed()方法测试与数据库的连接是否关闭。
		+ 在操作完数据库之后，若确定不再需要连接，则必须使用close()关闭与数据库的连接，以释放连接时相关的必要资源，如：连接相关对象，授权资源。

		+ DriverManager中相关源码

### 使用Statement，ResultSet

+ Statement是SQL语句的代表对象

	```Java
	Statement stmt = conn.createStatement();

	// executeUpdate() 主要用来执行会改变数据库内容的SQL，返回int结果，表示数据表动的笔数
	stmt.executeUpdate("INSERT INTO t_message VALUES(1, 'justin', " +
			"'justin@mail.com', 'message...')");

	// executeQuery() 查询，返回java.sql.ResultSet对象代表查询的结果，查询的结果会是一笔一笔的数据，可以使用ResultSet的next()来移动至下一笔数据，它会返回true或false表示是否有下一笔数据，接着可以使用getXXX()来取得数据。依据字段名称，或是依据字段顺序取得数据
	//getString(),getInt(),getFloat(),getDouble()

	ResultSet result = stmt.executeQuery("SELECT * FROM t_message");
	while(result.next()) {
		int id = result.getInt("id");
		String name = result.getString("name");
		String email = result.getString("email");
		String msg = result.getString("msg");
	}

	// 使用查询结果的字段顺序来显示结果的方式(索引是从1开始)
	ResultSet result = stmt.executeQuery("SELECT * FROM t_message");
	while(result.next()) {
		int id = result.getInt(1);
		String name = result.getString(2);
		String email = result.getString(3);
		String msg = result.getString(4);
	}

	// 如果事先无法知道是查询还是更新，可以使用execute()
	if(stmt.execute(sql)) {// 返回true，表示查询
		ResultSet rs = stmt.getResultSet();// 取得查询结果 ResultSet
	}else {// 这个是更新操作
		int updated = stmt.getUpdateCount();// 取得更新笔数
	}

	// statement或ResultSet在不使用时，可以使用close()将之关闭，以释放相关资源，Statement关闭时，所关联的ResultSet也会自动关闭。
	```

+ 留言板

	```Java
	// JDBCDemo GuestBookBeam.java
	import java.sql.*;
	import java.util.*;
	import java.io.*;

	public class GuestBookBean implements Serializable {
		private String jdbcUrl = "jdbc:mysql://localhost:3306/demo";
		private String username = "root";
		private String password = "123456";
		public GuestBookBean() {
			try {
				Class.forName("com.mysql.jdbc.Driver");
			}catch(ClassNotFoundException ex) {
				throw new RuntimeException(ex);
			}
		}
		public void setMessage(Message message) {
			Connection conn = null;
			Statement statement = null;
			SQLException ex = null;
			try {
				conn = DriverManager.getConnection(jdbcUrl, userName, password);
				statement = conn.createStateMent();
				statement.executeUpdate("INSET INTO t_message(name, email, msg) VALUES ('"
										+ message.getName() + "', '"
										+ message.getEmail() + "', '"
										+ message.getMsg() + "')");
			}catch(SQLException e) {
				if(statement != null) {
					try {
					statement.close();
					}catch(SQLException e) {
						if(ex == null) {
							ex = e;
						}
					}
				}
				if(conn != null) {
					try {
						conn.close();
					}catch(SQLException e) {
						if(ex == null) {
							ex = e;
						}
					}
				}
				if(ex != null) {
					throw new RuntimeException(ex);
				}
			}
		}
		public List<Message> getMessage() {
			Connection conn = null;
			Statement statement = null;
			ResultSet result =null;
			SQLException ex = null;
			List<Message> messages = null;
			try {
				conn = DriverManager.getConnection(jdbcUrl, username, password);
				statement = conn.createStatement();
				result.statement.executeQuery("SELECT * FROM t_message");
				messages = new ArrayList<Message>();
				while(result.next()) {
					Message message = new Message();
					message.setId(result.getLong(1));
					message.setName(result.getName(2));
					message.setEmail(result.getEmail(3));
					message.setMsg(result.getString(4));
					message.add(message);
				}catch(SQLException e) {
					ex = e;
				} finally {
					if(statement != null) {
						try {
							statement.close();
						}catch(SQLException e) {
							if(ex == null) {
								ex = e;
							}
						}
					}
					if(conn != null) {
						try {
							conn.close();
						}catch(SQLException e) {
							if(ex == null) {
								ex = e;
							}
						}
					}
					if(ex != null) {
						throw new RuntimeException(ex);
					}
				}
				return messages;
			}
		}
	}
	```

+ JDBC规范提到关闭Connection时，一并关闭关联的Statement，但最好留意是否真的关闭了资源，自行关闭Statement是比较保险的。

	```JSP
	<%@page contentType="text/html" pageEncoding="UTF-8"%>
	<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<c:set target="${pageContext.request}" property="characterEncoding" value="UTF-8"/>
	<jsp:useBean id="guestbook" class="cc.openhome.GuestBookBean" scope="application"/>// application 这样只有在第一次请求时会创建GuestBook Bean，之后GuestBookBean实例就存在应用程序范围中。
	<c:if test="${param.msg != null}">
		<jsp:useBean id="newMessage" class="cc.openhome.Message"/>
		<jsp:setProperty name="newMessage" property="*"/>
		<c:set target="${guestbook}" property="message" value="${newMessage}"/>
	</c:if>
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			<title>访客留言板</title>
		</head>
		<body>
			<table style="text-align: left; width: 100%;" border="0" cellpadding="2" cellspacing="2">
				<tbody>
					<c:forEach var="message" items="${guestbook.messages}">
						<tr>
							<td>${message.name}</td>
							<td>${message.email}</td>
							<td>${message.msg}</td>
						</tr>
					</c:forEach>
				</tbody>
			<table>
		</body>
	</html>
	```
	
### 使用PreparedStatement,CallableStatement

+ 有部分是动态的数据，必须使用+运算符串接字符串以组成完整的SQL语句。
+ 如果有些操作只是SQL语句中某些参数会有不同，其余的SQL子句皆相同。
  + java.sql.PreparedStatedStatement

    ```Java
    // 创建一个预编译(precompile)的SQL语句,当中参数会变动的部分，先指定“？”这个占位字符。
    PreparedStatement stmt = conn.prepareStatement("INSERT INTO t_message VALUES(?, ?, ?, ?)");
    stmt.setInt(1, 2);
    stmt.setString(2, "momor");
    stmt.setString(3, "momor@mail.com");
    stmt.setString(4, "message2...");
    stmt.executeUpdate(); // 要让SQL执行生效，需执行executeUpdate()或executeQuery()方法。
    stmt.clearParameters(); // 清除所设置的参数，之后就可以再使用这个PreparedStatement实例。
    ```

    + 在驱动程序支持的情况下，使用PreparedStatement，可以将SQL语句预编译为数据库的运行命令。
    + 使用PreparedStatement在安全也可以有点贡献。以串接的方式组合SQL语句基本上就会有SQL Injection的隐患。
+ 如果编写数据库的存储过程(Store Procedure)，并想使用JDBC调用，则可以使用java.sql.CallableStatement

  ```Java
  // 基本语法
  {?= call <程序名称>[<自定义量1>, <自定义量2>, ...]}
  {call <程序名称>[<自定义量1>, <自定义量2>, ...]}
  // 必须调用prepareCall()创建CallableStatement时异常
  // 可以使用registerOutParameter()注册输出参数。
  ```

+ 在使用PreparedStatement或CallableStatement时，必须注意SQL类型与Java数据类型的对应。
+ 在JDBC中,日期是java.sql.Date,时间是java.sql.Time

## JDBC进阶

### 使用DataSource取得连接

+ 重复利用取得的Connection实例，是改善数据库连接性能的一个方式。
+ 在Java应用程序中可以通过JNDI(Java Naming Directory Interface)来取得所需的资源对象。

  ```Java
  try {
    Context initContext = new InitialContext();
    Context envContext = (Context) initContext.lookup("java:/comp/env");
    dataSource = (DataSource) envContext.lookup("jdbc/demo"); // 查找jdbc/demo对应的DataSour
  }catch (NamingException ex) {
    ...
  }

  // JDBCDemo web.xml
  <web-app>
    <resource-ref>
      <resource-ref>
        <res-ref-name>jdbc/demo</res-ref-name>
        <res-type>javax.sql.DataSource</res-type>
        <res-auth>Container</res-auth>
        <res-sharing-scope>Shareable</res-sharing-scope>
      </resource-ref>
    </resource-ref>
  </web-app>

  // JDBCDemo context.xml //必须在META-INF中 
  <?xml version="1.0" encoding="UFT-8"?>
  <Context antiJARLocking="true" path="/JDBCDemo">
    <Resource name="jdbc/demo"
      auth="Container" type="javax.sql.DataSource"
      maxActive="100" maxIdle="30" maxWait="10000" username="root"
      password="123456" driverClassName="com.mysql.jdbc.Driver"
      url="jdbc:mysql://localhost:3306/demo?useUnicode=true&amp;characterEncoding=UTF8"/>
      // XML中编写，&必须使用&amp;取代
  </Context>
  ```

+ 其他属性，则是与DBCP(Database Connection Pool),这是内置在Tomcat中的连接池机制

### 使用ResultSet卷动，跟新数据

+ 从JDBC2.0开始，ResultSet并不仅使用previous(),first(),last()等方法前后移动数据光标，还可以调用updateXXX(),updateRow()等方法进行数据修改。

+ 在使用Connection的createStatement()或prepareStatement()方法创建Statement或PrepareStatement实例时，可以指定结构集与并行方式：

  ```Java
  createStatement(int resultSetType, int resultSetConcurrency)
  prepareStatement(String sql, int resultSetType, int resultSetCoucurrency)

  // 结果集类型可以指定三种设置：
  ResultSet.TYPE_FORWARD_ONLY(默认) // ResultSet就只能前进数据光标
  ResultSet.TYPE_SCROLL_INSENSITIVE // ResultSet可以前后移动数据光标，不会反应数据库中的数据修改
  ResultSet.TYPE_SCRILL_SENSITIVE // ResultSet可以前后移动数据光标，会反应数据库中的数据库修改。

  // 更新设置可以有两种指定：
  ResultSet.CONCUR_READ_ONLY(默认) // 只能用ResultSet进行属于读取，无法进行更新。
  ResultSet.CONCUR_UPDATABLE // 可以使用ResultSet进行数据更新

  PreparedStatement stmt = conn.prepareStatement("SELECT * FROM t_message"，
                          ResultSet.TYPE_SCROLL_INSENSITIVE,
                          ResultSet.CONCUR_UPDATABLE);
  ```

+ 在数据光标移动的API上，可以使用absolute(),afterLast(),beforeFirst(),first(),last()进行绝对位置移动，使用relative(),previous(),next()进行相对位置移动，成功返回true。isAfterLast(),isBeforeFirst(),isFirst(),isLast()判断目前位置。

  ```Java
  Statement stmt = conn.createStatement("SELECT * FROM t_message",
                    ResultSet.TYPE_SCROLL_INSENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
  ResultSet rs = stmt.executeQuery();
  rs.absolute(2); // 移至第二行
  rs.next(); // 移至下一行
  rs.first(); // 移至第一行
  boolean b1 = rs.isFirst(); // b1是true
  ```

+ 如果使用ResultSet进行数据修改，则有些条件限制：
  + 必须选择单一表格
  + 必须选择主键
  + 必须选择所有NOT NULL的值

  ```Java
  // 取得ResultSet之后要进行数据更新，必须移动至要更新的行(Row)，调用UpdateXxx()方法，而后调用updateRow()方法完成更新。
  // 如果调用cancelRowUpdates()可取消更新，但必须在调用updateRow()前进行更新的取消
  Statement stmt = conn.prepareStatement("SELECT * FROM t_message",
                    ResultSet_TYPE_SCROLL_INSENSITIVE,
                    ResultSet_CONCUR_READ_ONLY);
  ResultSet rs = stmt.executeQuery();
  rs.absolute(3);
  rs.updateString(3, "caterpillar@openhome.cc");
  rs.updateRow();

  // 取得ResultSet后想直接进行数据的新增，则要先调用moveToInsertRow()，之后调用updateXxx()设置要新增的数据各个字段，然后调用insertRow()新增数据。
  Statement stmt = conn.prepareStatement("SELECT * FROM t_message",
                    ResultSet.TYPE_SCROLL_INSENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
  ResultSet rs = stmt.executeQuery();
  rs.moveToInsertRow();
  rs.updateString(2, "momor");
  rs.updateString(3, "momor@openhome.cc");
  rs.updateString(4, "blah..blah");
  rs.insertRow();
  rs.moveToCurrentRow();

  // 如果取得ResultSet后想直接进行数据的删除，则要移动光标至想删除的列，调用deleteRow()删除数据列
  Statement stmt = conn.prepareStatement("SELECT * From t_message",
                    ResultSet.Type_SCROLL_INSENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);
  ResultSet rs = stmt.executeQuery();
  rs.absolute(3);
  rs.deleteRow();
  ```

### 批次更新

+ 如果必须对数据库进行大量数据更新，while循环，每一次执行executeUpdate()，其实都会向数据库发送于此SQL。网络传送信息实际上必须启动I/O，进行路由等动作，这样进行大量更新，性能上其实不好。
  + 使用addBatch()方法收集SQL，并使用executeBatch()方法将所有收集的SQL传送出去。

    ```Java
    Statement stmt = conn.createStatement();
    while(someCondition) {
      stmt.addBatch(
        "INSERT INTO t_message(name, email, msg) VALUES('...', '...', '...')"
      );
    }
    stmt.executeBatch();

    // MySQL驱动程序的Statement实现为例，addBatch()使用了ArrayList来收集SQL。
    public synchronized void addBatch(String sql) throws SQLException {
      if (this.batchedArgs == null) {
        this.batchedArgs = new ArrayList();
      }
      if (sql != null) {
        this.batchedArgs.add(sql);
      }
    }
    // 所有收集的SQL，最后会串为一句SQL，然后传送给数据库。
    ```

+ 批量更新仅用在更新操作。所以批量更新的限制是，SQL不能SELECT，否则会抛出异常。
+ 使用executeBatch时，SQL的执行顺序就是addBatch()时的顺序，executeBatch()会返回int[]，代表每笔SQL造成的数据异动列数。
  + 执行executeBatch()时，先前已打开ResultSet会被关闭，执行过后收集SQL用的List会被清空，任何的SQL错误会抛出BatchUpdateException，可以使用这个对象的getUpdateCounts()取得int[]。

  ```Java
  PreparedStatement stmt = conn.prepareStatement(
    "INSERT INTO t_message(name, email, msg) VALUES(?, ?, ?)"
  );
  while(someCondition) {
    stmt.setString(1, "..");
    stmt.setString(2, "..");
    stmt.setString(3, "..");
    stmt.addBatch(); // 收集参数
  }
  stmt.executeBatch(); // 送出所有参数

  // PreparedStatement的addBatch()会收集占位字符真正的数值。
  // 以MySQL的PreparedStatement实现类
  public void addBatch() throws SQLException {
    if (this.batchedArgs == null) {
      this.batchedArgs == new ArrayList();
    }
    this.batchedArgs.add(new BatchParams(this.parameterValues, this.parameterStreams, this.isStream, this.streamLengths, this.isNull));
  }
  ```

### Blob与Clob

+ 如果要将文件写入数据库，可以在数据库表格字段上使用下面的数据类型。
  + BLOB全名(Binary Large Object)，用于储存大量的二进制数据，如图片，影音文件等。
  + CLOB全名(Character Large Object)，用于储存大量的文字数据。

  ```Java
  // 存储
  InputStream in = readFileAsInputStream("...");
  PreparedStatement stmt = conn.prepareStatement(
    "INSERT INTO IMAGES(src, img) VALUE(?, ?)"
  );
  stmt.setString(1, "...");
  stmt.setBinaryStream(2, in);
  stmt.executeUpdate();

  // 取得
  PreparedStatement stmt = conn.prepareStatement (
    "SELECT img FORM IMAGES"
  );
  ResultSet rs = stmt.executeQuery();
  while(rs.next()) {
    InputStream in = rs.getBinaryStream(1);
    ..
  }
  ```

+ 例子，用户上传文件储存到数据库，下载或删除数据库中的文件。

### 事务简介

+ 事务基本要求是原子性(Atomicity)，一致性(Consistency)，隔离行为(Isolation behavior)与持续性(Durability)，简称ACID。
  + 原子性：一个事务是一个单元工作，当中可以包括数个步骤(数个SQL)。要开始一个事务边界(通常是以一个BEGIN的命令开始)所有SQL语句下达之后，COMMIT确认所有操作变更，事务成功。若某个SQL错误，ROLLBACK进行撤销动作，事务失败。
  + 一致性：事务作用的数据集合在事务前后必须一致。若事务成功，整个数据集合都必须是事务操作后的状态；若事务失败，整个数据必须与开始事务前一样没有变更，不能发生整个数据集合部分变更，部分没变更。
  + 隔离行为：事务与事务之间，必须互不干扰。
  + 持续性：事务一旦成功，所有变更必须保存下来，即使系统故障，事务的结果也不能遗失。着通常需要系统软，硬件架构支持。

  ```Java
  Connection conn = null;
  try {
    conn.dataSource.getConnection();
    conn.setAutoCommit(false); // 取消自动提交，提示数据库启始事务
    Statement stmt = conn.createStatement();
    stmt.executeUpdate("INSERT INTO ...");
    stmt.executeUpdate("INSERT INTO ...");
    conn.commit(); // 提交
  }
  catch(SQLException e) {
    e.printStackTrace();
    if(conn != null) {
      try {
        conn.rollback(); // 回滚
      }
      catch(SQLException ex) {
        ex.printStackTrace();
      }
    }
  }
  finally {
    ...
    if(conn != null) {
      try {
        conn.setAutoCommit(true); // 恢复自动提交
        conn.close();
      }
      catch(SQLException ex) {
        ex.printStackTrace();
      }
    }
  }

  // 仅想要撤回某个SQL执行点，则可以设置储存点(Save Point)
  Savepoint point = null;
  try {
    conn.setAutoCommit(false);
    Statement stmt = conn.createStatement();
    stmt.executeUpdate("INSERT INTO ...");
    ...
    point = conn.setSavepoint(); // 设置存储点
    stmt.executeUpdate("INSERT INTO ...");
    ...
    conn.commit();
  }
  catch(SQLException e) {
    e.printStackTrace();
    if(conn != null) {
      try {
        if(point == null) {
          conn.rollback();
        }else {
          conn.rollback(point); // 撤回储存点
          conn.releaseSavepoint(point); // 释放储存点
        }
      }
      catch(SQLException ex) {
        ex.printStackTrace();
      }
    }
  }
  finally {
    ...
    if(conn != null) {
      try {
        conn.setAutoCommit(true);
        conn.close();
      }
      catch(SQLException ex) {
        ex.printStackTrace();
      }
    }
  }

  // 批量更新，不用每一笔都确认，也可以搭配事务管理
  try {
    conn.setAutoCommit(false);
    stmt.conn.createStatement();
    while(someCondition) {
      stmt.addBatch("INSERT INTO ...");
    }
    stmt.executeBatch();
    conn.commit();
  }
  ...
  ```

+ 数据表格必须支持事务，才可以执行以上所提到的功能。
+ 隔离行为，JDBC可以通过Connection的getTransactionIsolation()取得数据库目前的隔离行为设置，通过setTransactionIsolation()可提示数据库设置指定的隔离行为。可设置的常数是定义在Connection：
    + TRANSACTION_NONE // 表示对事务不隔离行为，仅适用于没有事务功能，以只读功能为主，不会发生同时修改字段的数据库。有事务功能的数据库，可能不理会TRANSACTION_NONE的设置提示
    + TRANSACTION_UNCOMMITTED
    + TRANSACTION_COMMITTED
    + TRANSACTION_REPEATABLE_READ
    + TRANSACTION_SERIALIZABLE

+ 多个事务并行时，可能引发的数据不一致问题
    + 更新遗失(Lost update)
        + 基本上就是指某个事务对字段进行更新的消息，因另一个事务的介入而遗失更新效力
        + 设置隔离层级为“可读取未确认”，A事务未确认的数据，B数据仅可作读取动作。
        + JDBC通过Connection的setTransactionIsolation()设置为TRANSACTION_UNCOMMITTED
        + A事务在更新但未确认，延后B事务的更新需求至A事务确认之后。

    + 脏读(Dirty read)
        + 两个事务同时进行，其中一个事务更新数据但未确认，另一个事务就读取数据，就有可能发生脏读，也就是读到的数据，不干净，不正确。
        + 设置“可读取确认”-TRANSACTION_COMMITTED
        + 读取的事务不会阻止其他事务，未确认的更新事务会阻止其他事务
        + 这个做法对性能影响比较大，另一个做法是事务正在更新但尚未确认前先操作暂存表格，其他事务就不至于读取不正确的数据。

    + 无法重复的读取(Unrepeatable read)
        + 某个事物两次读取同一个字段的数据并不一致。
        + 设置“可重复读取”-TRANSTION_REPEATAVBLE
        + 读取事务在确认前不阻止其他读取事务，但会阻止其他更新事务
        + 这个做法影响性能较大，另一个组做法是事务正在读取但尚未确认前，另一个事务会在暂存表格上更新。

    + 幻读(Phantom read)
        + 同一个事务期间，读取到的数据笔数不一致。
        + 设置“可循环序”-TRANSTON_SERIALIZABLE
        + 事务若真的一个一个循环进行，对数据库卡的影响性能过于巨大，实际也未必直接阻止其他事务或真的循序进行，例如采用暂存表格方式。

+ 各个隔离行与可预防的问题
	+ 可读取未确认：预防更新遗失
	+ 可读取确认：预防更新遗失，脏读
	+ 可重复读取：预防更新遗失，脏读，无法重复的读取
	+ 可循序：预防更新遗失，脏读，无法重复的读取，幻读

+ JDBC得知数据库是否支持某个隔离行为设置

	```Java
	Databasemetadata meta = conn.getMetaData();
	boolean isSupported = meta.supportsTransactionIsolationLevel(Connection.TRANSACTION_READ_COMMITTED);
	```

### metadata简介

+ Metadata即“关于数据的数据”(Data about data)
+ DatabaseMetaData Connection.getMetadata() // 数据库整体信息
+ ResultSEtMetaData ResultSet.getMetaData() // 字段名称，字段类型

	```Java
	// JDBCDemo TFileInfo.java
	public class TFilesInfo implements serializable {
		private DataSource dataSource;
		public TFiliesInfo() {
			try {
				Context initContexte = new InitialContext();
				Context envContext = (Context) initContext.lookup("jdbc/demo");
				dataSource = (DataSource) envContext.lookup("jdbc/demo");
			}
			catch(NamingException ex) {
				throw new RuntimeException(ex);
			}
		}
		public List<ColumnInfo> getAllColumnInfo() {
			Connection conn = null;
			ResultSet crs = null;
			SQLException ex = null;
			List<ColumnInfo> infos = null;
			try {
				conn.dataSource.getConnection();
				DatabaseMetaData meta = conn.getMEtaData();
				crs = meta.getAllColumns("demo", null, "t_files", null);
				infos = new ArrayList<ColumnInfo>(); // 收集字段信息
				while(crs.next()) {
					ColumnInfo info = new ColumnInfo();
					info.setName(crs.getString("COLUMN_NAME"));
					info.setType(crs.getString("TYPE_NAME"));
					info.setSize(crs.getInt("COLUMN_SIZE"));
					info.setNullable(crs.getBoolean("IS_NULLABLE"));
					infos.add(info);
				}
				catch(SQLException e) {
					ex = e;
				}
				finally {
					if(conn != null) {
						try {
							conn.close();
						}catch (SQLException e) {
							if(ex == null) {
								if(ex == null) {
									ex = e;
								}
							}
						}
					}
				}
				if(ex != null) {
					throw new RuntimeException(ex);
				}
				return infos;
			}
		}
	}
	```

### RowSet简介

+ javax.sql.RowSet接口，用以代表数据的的行集合。这里的数据并不一定是数据库中的数据，可以是试算表数据，XML数据或任何具有行集合概念的数据源。
+ Row定义了行集合基本行为
	+ JdbcRowSet
	+ CachedRowSet
	+ FilteredRowSet
	+ JoinRowSet
	+ WebRowSet

## 使用SQL标签库

### 数据源，查询标签

```JSP
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql%>
<sql:setDataSource dataSource="java:/comp/env/jdbc/demo"/>
<sql:setDataSource driver="com.musql.jdbc.Driver" user="root" password="123456" url="jdbc:mysql:3306/demo"/>

<sql:query sql="SELECT * FROM t_message" var="messages"/>
```

### 更新，参数，事务标签

```JSP
<sql:update>
	INSERT INTO t_message(name, email, msg)
		VALUES('Justin', 'caterpillar@openhome.cc', 'This is a test!')
</sql:update>

<sql:update>
	INSERT INTO t_message(name, email, msg) VALUES(?,?,?)
	<sql:param values="${param.name}"/>
	<sql:param values="${param.email}"/>
	<sql:param values="${param.email}"/>
</sql:update>

// 日期时间格式<sql:paramDate>
// 事务隔离<sql:tramsaction>
```

# Web容器安全管理

# JavaMail入门

# 从模式到框架

## 认识设计模式

### Template Method模式(Gof设计模式)

+ 父类会在某方法中定义服务流程。

### Intercepting Filter模式(Java EE 设计模式)

+ 过滤器

### Model-View-Controller模式(架构模式)

## 重构，模式与框架

### Business Delegate(委托)模式

+ BusinessDelegate角色接受客户端请求，委托BusinessService执行后传回结果给客户端。Business Delegate模式可以有效地隐藏后台程序的复杂度，降低前台界面组件与后台业务组件的耦合度。

### Service Locator(定位器)模式

+ 隐藏了创建服务相关对象，查找服务对象的操作等细节，降低了远程服务对象的实体位置，取得方式对目前应用程序的影响。

### Transfer(转移) Object模式

+ Transfer Object 本身通常实现时会符合JavaBean规格，以方便需要的组件进行存取。
+ Transfer Object 可以携带的信息并不一定只是状态，还可以携带指令以简化指定通信协定的需求(可以搭配Gof模式的Command模式来实现)

### Front Controller模式

+ 在MVC设计模式中，控制器担任了处理用户请求参数，调用模式对象并转发视图对象的职责。
+ 在处理用户请求参数方面的操作：
	+ 取得请求参数
	+ 验证请求参数
	+ 转换请求参数类型
	+ 其他请求参数(或许还需要将请求参数封装为窗体对象)

+ 在控制器中，如果绝大多数的代码都是在进行这些请求参数的处理动作，应该将这些处理请求的职责集中管理，创建一个前台控制器来专门进行这些共同的请求处理。

+ Java EE 模式之一。FrontController负责了集中管理所有请求的操作，处理完毕后再委托给Dispatcher对象，由Dispatcher决定调用哪个Action对象或View对象。
	+ Action对象是实际决定如何根据请求来调用后台业务逻辑的对象及决定转发对象。
	+ 以MVC来区隔职责的话，FrontController,Dispatcher与Action对象都归属于控制器的角色。

+ FrontController
	+ Struts1.2 - ActionServlet
	+ JSF - FaceServlet
	+ Spring MVC - DispatcherServlet
	+ struts2 - FilterDispatcher过滤器(FrontController角色未必一定是Servlet)

### 库与框架

+ 框架是半成品
