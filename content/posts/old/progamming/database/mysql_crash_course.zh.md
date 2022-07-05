---
title: MySQL 必知必会
date: 2017-05-15 11:59:00 +0800
tags:
- MySQL
---

# 了解 SQL

+ 应该总是定义主键
+ 表中的任何列都可以作为主键

    + 任意两行都不具备相同的主键值；
    + 每个行都必须具有一个主键值（主键列不允许 NULL 值）

+ 主键好习惯

    + 不更新主键列中的值
    + 不重用主键列的值
    + 不在主键列中使用可能会更改的值

# 使用 MySQL

```SQL
USE crashcourse;
SHOW DATABASES;
SHOW TABLES;
SHOW COLUMNS 
FROM customers; // 显示表列
    DESCRIBE customers; // 上面这句的快捷方式
SHOW STATUS; // 用于显示广泛的服务器状态信息
SHOW CREATE DATABASE／ SHOW CREATE TABLE 分别用来创建特定数据库或表的 MySQL 语句
SHOW GRANTS; // 用来显示授予用户（所有用户或特定用户）的安全权限
SHOW ERRORS ／ SHOW WARNINGS // 用来显示服务器错误或警告消息

HELP SHOW // 显示允许的 SHOW 语句
```

# 检索数据

+ 虽然 SQL 是不区分大小写的，但有些标识符（如数据库名，表名，列名）可能不同。最佳方式是按照大小写的惯例，且使用时保持一致。
+ 一般，除非你确实需要表中的每个列，否则最好别使用 * 通配符。（检索不需要的列通常会降低检索和应用程序的性能）

## DISTINCT

    ```SQL
    SELECT DISTINCT vend_id 
    FROM products; //指示 MySQL 只返回不同的值。
    // 不能部分使用 DISTINCT 。DISTINCT 关键字应用于所有的列而不仅是前置它的列。
    SELECT DISTINCT vend_id, prod_price; // 除非指定的两个列都不同，否则所有行都将被检索出来。
    ```

## LIMIT

    ```SQL
    SELECT pro_name 
    FROM products LIMIT 5; // 指示 MySQL 返回不多于 5 行。
    
    SELECT pro_name 
    FROM products LIMIT 5,5; // 指示 MySQL 返回从行 5 开始的 5 行。第一个数为开始位置，第二个数为要检索的行数。
    
    // 检索出来的第一行为行 0 而不是行 1 。
    LIMIT 1,1; // 将检索出第二行而不是第一行。
    // 如果没有足够的行，MySQL 将只返回它能返回的那么多行。
    
    // MySQL 5 的 LIMIT 语法
    LIMIT 4 OFFSET 3 // 从行 3 开始取 4 行，就像 LIMIT 3,4 一样
    ```

## 完全限定的表名

```SQL
SELECT products.pro_name 
FROM crashcourse.products;
```

# 排序检索数据

```SQL
SELECT prod_name 
FROM products;

// 通过非选择列进行排序。

SELECT prod_id, prod_price, prod_name 
FROM products 
ORDER BY prod_price, prod_name; // 首先按照价格，然后再按名称排序

SELECT prod_id, prod_price, prod_name 
FROM products 
ORDER BY prod_price DESC; // 降序

SELECT prod_id, prod_price, prod_name 
FROM products 
ORDER BY prod_price DESC, prod_name; // DESC 关键字只应用到直接位于其前面的列名。

// 如果在多个列降序排序。必须对每个列指定 DESC 关键字

ASC 升序（默认）

// 在字典（dirtionary）排序顺序中，A 被视为与 a 相同，这是 MySQL 的默认行为。

SELECT prod_price 
FROM products 
ORDER BY prod_price DESC 
LIMIT 1; // 找出列中最高的值
```

# 过滤数据

```SQL
SELECT prod_name, prod_price 
FROM products 
WHERE prod_price = 2.50;

// SQL过滤，应用过滤

// 操作符
=, <>, !=, <, <=, >, >=, BETWEEN

// MySQL 在执行匹配时默认不区分大小写

// 将值与串类型的列进行比较，则需要限定引号。

SELECT prod_name, prod_price 
FROM products 
WHERE prod_price BETWEEN 5 AND 10;

// 在创建表时，表设计人员可以指定其中的列是否可以不包括值。在一个列不包含值时，称其为包含空值 NULL
// NULL 无值，它与字段包含 0 ，空字符或仅仅包含空格不同。
SELECT prod_name 
FROM products 
WHERE prod_price IS NULL;
```

# 数据过滤

## AND 操作符
## OR 操作符

    ```SQL
    SELECT prod_name, prod_price 
    FROM products 
    WHERE (vend_id = 1002 OR vend_id = 1003) AND prod_price >= 10;
    ```

## IN 操作符

```SQL
SELECT prod_name, prod_price
FROM products
WHERE vend_id
IN (1002, 1003)
ORDER BY prod_name;
    
// IN 操作符后跟由逗号分隔的合法值清单，整个清单必须括在圆括号中。
```

+ 优点

    + 在使用长的合法选项清单时，IN 操作符的语法更清楚且更直观。
    + 在使用 IN 时，计算的次序更容易管理。
    + IN 操作符一般比 OR 操作符清单执行更快。
    + IN 的最大优点是可以包含其他 SELECT 语句，使得能够更动态地建立 WHERE 子句。

## NOT 操作符

```SQL
// NOT 用来否定后跟条件的关键字
SELECT prod_name, prod_price
FROM products
WHERE vend_id NOT IN (1002, 1003)
ORDER BY prod_name;
```

+ MySQL 支持使用 NOT 对 IN，BETWEEN 和 EXISTS 子句取反，这与多数其他 DBMS 允许使用 NOT 对各种条件取反很大的差别。

# 用通配符进行过滤

## LIKE 操作符

+ 通配符（wildcard） 用来匹配值的一部分的特殊字符。
+ 搜索模式（search pattern） 由字面值，通配符或两者组合构成的搜索条件。
+ 操作符何时不是操作符？答案是在它作为谓词时。从技术上说，LIKE是谓语而不是操作符。

### 百分号（%）通配符

```SQL
// % 表示任何字符出现任意次数
SELECT prod_id, prod_name
FROM products
WHERE prod_name
LIKE 'jet%'; // 不区分大小写

// 根据 MySQL 的配置方式，搜索可以是区分大小写的。
// 通配符可在搜索模式中任意位置使用，并且可以使用多个通配符。
SELECT prod_id, prod_name
FROM products
WHERE prod_name LIKE '%anvil%';

SELECT prod_name
FROM products
WHERE prod_name LIKE 's%e';

//% 代表搜索模式中给定位置的 0 个，1 个或多个字符。

WHERE prod_name LIKE '%'; // 不能匹配用值 NULL 作为产品名的行
```

### 下划线（_）通配符

```SQL
// _ 总是匹配一个字符
SELECT prod_id, prod_name
FROM products
WHERE prod_name LIKE '_ ton anvil';
```

## 使用通配符的技巧

+ 通配符搜索的处理一般要比前面讨论的其他搜索所花时间更长。
+ 技巧

    + 不要过度使用通配符。如果其他操作符能达到相同的目的，应该使用其他操作符。
    + 在确实需要使用通配符时，除非绝对有必要，否则不要把它们用来在搜索模式的开始处。把通配符置于搜索模式的开始处，搜索起来是最慢的。
    + 仔细注意通配符的位置。

# 用正则表达式进行搜索

+ MySQL 仅支持多数正则表达式实现的一个很小的子集。

## 基本字符匹配

```SQL
SELECT prod_name
FROM products
WHERE prod_name REGEXP '10000'
ORDER BY prod_name; // 检索列 prod_name 包含文本 1000 的所有行。

SELECT prod_name
FROM products
WHERE prod_name REGEXP '.000'
ORDER BY prod_name; // . 表示匹配任意一个字符。

// MySQL中的正则表达式匹配（自版本 3.23.4 后），不区分大小写。
// 为区分大小写，可使用 BINARY 关键字。
WHERE prod_name REGEXP BINARY 'JetPack .000';
```

## 进行 OR 匹配

```SQL
// 为搜索两个串之一，使用 | 
SELECT prod_name
FROM products
WHERE prod_name REGEXP '1000|2000'
ORDER BY prod_name;
```

## 匹配几个字符之一

```SQL
// 匹配任何单一字符，指定一组用[和]括起来的字符完成
SELECT prod_name
FROM products
WHERE prod_name REGEXP '[123] Ton'
ORDER BY prod_name;

// [] 是另一种形式的 OR 语句。
[123]Ton 是 [1|2|3]Ton 缩写。
// 但是需要 [] 来定义 OR 语句查找什么。
// 反例：
SELECT prod_name
FROM products
WHERE prod_name REGEXP '1|2|3 Ton'
ORDER BY prod_name; // '1' 或 '2' 或 '3 ton'

// 字符集合也可以被否定。在集合的开始处放置一个 ^ 即可。
[^123]
```

## 匹配范围

```SQL
// 集合可用来定义要匹配的一个或多个字符。
// 匹配数字 0 到 9
[0123456789] 等价于 [0-9]
[a-z] // 匹配任意字母字符
SELECT prod_name
FROM products
WHERE prod_name REGEXP '[1-5] Ton'
ORDER BY prod_name;
```

## 匹配特殊字符

```SQL
// 为了匹配特殊字符，必须用 \\ 为前导。
SELECT vend_name
FROM vendors
WHERE vend_name REGEXP '\\.'
ORDER BY vend_name; // 转译（escaping）

// '\\' 也用来引用元字符（具有特殊含义的字符）
'\\f' // 换页
'\\n' // 换行
'\\r' // 回车
'\\t' // 制表
'\\v' // 纵向制表

'\\\' // 匹配反斜杠（\）字符本身
```

+ 多数正则表达式实现使用单个反斜杠转义特殊字符，以便能使用这些字符本身。但 MySQL 要求两个反斜杠（ MySQL 自己解释一个，正则表达式库解释另一个）

## 匹配字符类

+ 使用预定义的字符集，称为字符类（ character class ）

```SQL
[:alnum:] // 任意字母和数字（同 [a-zA-Z0-9] ）
[:alpha:] // 任意字符（同 [a-zA-Z] ）
[:blank:] // 空格和制表 （同 [\\t] ）
[:cntrl:] // ASCII 控制字符（ ASCII 0 到 31 和 127）
[:digit:] // 任意数字（同 [0-9] ）
[:graph:] // 与 [:print:] 相同，但不包括空格
[:lower:] // 任意小写字母（同 [a-z] ）
[:print:] // 任意可打印字符
[:punct:] // 即不在 [:alnum:] 又不在 [:cntrl:] 中的任意字符
[:space:] // 包括空格在内的任意空白字符（同 [\\f\\n\\r\\t\\v] ）
[:upper:] // 任意大写字母（同 [A-Z] ）
[:xdigit:] // 任意十六进制数字（同 [a-fA-F0-9] ）
```

## 匹配多个实例

```SQL
* // 0 个或多个匹配
+ // 1 个或多个匹配 （等于 {1,} ）
? // 0 个或 1个匹配 （等于 {0,1} ）
{n} // 指定数目的匹配
{n,} // 不少于指定数目的匹配
{n,m} // 匹配数目的范围（ m 不超过 255 ）

SELECT prod_name
FROM products
WHERE prod_name REGEXP '\\([0-9] stick?\\)'
ORDER BY prod_name; // ? 匹配它前面的任何字符的 0 次或 1 次出现

SELECT prod_name
FROM products
WHERE prod_name REGEXP '[[:digit:]]{4}'
```

## 定位符

```SQL
// 为了匹配特定位置的文本
^ // 文本的开始
$ // 文本的结尾
[[:<:]] // 词的开始
[[:>:]] // 词的结尾

SELECT prod_name
FROM products
WHERE prod_name REGEXP '^[0-9\\.]'
```

+ ^ 有两种用法。在集合中（ 用 [ 和 ] 定义 ），用它来否定该集合，否则，用来指串的开始处。
+ LIKE 匹配整个串而 REGEXP 匹配子串。利用定位符，通过用 ^ 开始每个表达式，用 $ 结束每个表达式，可以使 REGEXP 的作用与 LIKE 一样。

```SQL
// 可以在不使用数据库表的情况下用 SELECT 来测试正则表达式
// REGEXP 检查总是返回 0 (没有匹配) 或 1 （匹配）
SELECT 'hello' REGEXP '[0-9]';
```

# 创建计算字段

+ 字段（ field ） 基本上与列（ column ）的意思相同。不过数据库列一般称为列，而术语字段通常用在计算字段连接上。

## 拼接字段

+ 拼接（concatenate） 将值联结到一起构成单个值。

```SQL
// 多数 DBMS 使用 + 或 || 来实现拼接，MySQL 则使用 Concat() 函数来实现。

SELECT Concat(vend_name, ' （', vend_country, '）')
FROM vendors
ORDER BY vend_name;

SELECT Concat(RTrim(vend_name), ' （', RTrim(vend_country), '）'); // RTrim() 函数去掉值右边的所有空格
// LTrim() 去掉串左边的空格 Trim() 去掉串左右两边的空格

// 别名（ alias ）
SELECT Concat(vend_name, ' （', vend_country, '）') AS vend_title
FROM vendors
ORDER BY vend_name;

// 别名有时也称为 导出列 （derived column）
```

## 执行算术计算

```SQL
SELECT prod_id, 
       quantity, 
       item_price, 
       quantity * item_price AS expanded_price
FROM orderitems
WHERE order_num = 20005;

// 测试 省略 FROM 子句
SELECT 3 * 2
SELECT Trim('abc')
SELECT Now() // Now 函数返回当前日期和时间
```

# 使用数据处理函数

+ 函数没有 SQL 的可移植性强（几乎每种主要的 DBMS 的实现都支持其他实现不支持的函数）

## 使用函数

+ 用于处理文本串的文本函数
+ 用于在数值上进行算术操作的数值函数
+ 用于处理日期和时间值并从这些值中提取特定成分的日期和时间函数
+ 返回 DBMS 正使用的特殊信息的系统函数

### 文本处理函数

```SQL
SELECT vend_name, Upper(vend_name) AS vend_name_upcase
FROM vendors
ORDER BY vend_name; // Upper() 将文本转换为大写

Left() // 返回串左边的字符
Length() // 返回串的长度
Locate() // 找出串的一个子串
Lower() // 将串转换为小写
LTrim() // 去掉串左边的空格
Right() // 返回串右边的字符
RTrim() // 去掉串右边的空格
Soundex() // 返回串的 SOUNDEX 值
SubString() // 返回子串的字符
Upper() // 将串转换为大写
```

+ SOUNDEX 是一个将任何文本串转换为描述其语音表示的字母数字模式的算法。SOUNDEX 考虑了类似的发音字符和音节，使得能对串进行发音比较而不是字母比较。

```SQL
SELECT cust_name, cust_contact
FROM customers
WHERE Soundex(cust_contact) = Soundex('Y Lie');
// 匹配所有发音类似于 Y. Lie 的联系名
```

### 日期和时间处理函数

```SQL
addDate() // 增加一个日期（天，周等）
addTime() // 增加一个时间（时，分等）
CurDate() // 返回当前日期
CurTime() // 返回当前时间
Date() // 返回日期时间的日期部分
DateDiff() // 计算两个日期之差
Date_Add() // 高度灵活的日期运算函数
Date_Format() // 返回一个格式化的日期或时间串
Day() // 返回一个日期的天数部分
DayOfWeek() // 对于一个日期，返回对应的星期几
Hour() // 返回一个时间的小时部分
Minute() // 返回一个时间的分钟部分
Month() // 返回一个日期的月份部分
Now() // 返回当前日期和时间
Second() // 返回一个时间的秒部分
Time() // 返回一个日期时间的时间部分
Year() // 返回一个日期的年份部分
```

+ MySQL 日期的格式，无论什么时候指定一个日期，日期必须为格式 yyyy-mm-dd ，这是首选的日期格式，它排除了多义性。
+ 应该总是使用 4 位数字的年份

```SQL
SELECT cust_id, order_num
FROM orders
WHERE order_date = '2005-09-01';

// 指示 MySQL 仅给出的日期与列中的日期部分进行比较，而不是将给出的日期与整个列值进行比较。
SELECT cust_id, order_num
FROM orders
WHERE Date(order_date) = '2005-09-01';

// 如果要的是日期，请使用 Date() ，即使你知道相应的列只包含日期也是如此。
// Date() 和 Time() 都是在 MySQL 4.1.1 中第一次引入的。

// 匹配月份
SELECT cust_id, order_num
FROM orders
WHERE Date(order_date) BETWEEN '2005-09-01' AND '2005-09-30';

// 或者
SELECT cust_id, order_num
FROM orders
WHERE Year(order_date) = 2005 AND Month(Order_date) = 9;
```

### 数值处理函数

```SQL
Abs() // 返回一个数的绝对值
Cos() // 返回一个角度的余弦
Exp() // 返回一个数的指数值
Mod() // 返回除操作的余数
Pi() // 返回圆周率
Rand() // 返回一个随机数
Sin() // 返回一个角度的正弦
Sqrt() // 返回一个数的平方根
Tan() // 返回一个角度的正切
```

# 汇总数据

## 聚集函数

+ 确定表中行数
+ 获得表中行组的和
+ 找出表列（或所有行或某些特定的行）的最大值，最小值和平均值

```SQL
// 聚集函数 运行在行组上，计算和返回单个值的函数。

AVG() // 返回某列的平均值
COUNT() // 返回某列的行数
MAX() // 返回某列的最大值
MIN() // 返回某列的最小值
SUM() // 返回某列之和

// MySQL 还支持一系列的标准偏差聚集函数，但本书并未涉及这些内容。
```

### AVG() 函数

```SQL
SELECT AVG(products) AS avg_price
FROM products;

// AVG() 只用于单个列
// 忽略列值为 NULL 的行
```

### COUNT() 函数

+ 两种使用方式

    + 使用 COUNT(*) 对表中行的数目进行计数，不管表列中包含的是空值（ NULL ）还是非空值
    + 使用 COUNT(column) 对特定列中具有值的行进行计数，忽略 NULL 值

```SQL
SELECT COUNT(*) AS num_cust
FROM customers;

// 只对具有电子邮件地址的客户计数，忽略指定列为空的行
SELECT COUNT(cust_email) AS num_cust
FROM customers;
```

### MAX() MIN() 函数

```SQL
// 返回指定列中的最大值。要求指定列名。
SELECT MAX(prod_price) AS max_price
FROM products;

SELECT MIN(prod_price) AS min_price
FROM products;

// MySQL 允许将它用来返回任意列中的最大值，包括返回文本列中的最大值。
// MAX()，MIN() 函数忽略列值为 NULL 的行
```

### SUM() 函数

```SQL
// 返回指定列值的和
SELECT SUM(quantity) AS items_ordered
FROM orderitems
WHERE order_num = 20005;

SELECT SUM(item_price * quantity) AS total_price
FROM orderitems
WHERE order_num = 20005;

// 利用标准的算术操作符，所有聚集函数都可用来执行多个列的计算
// SUM() 函数忽略列值为 NULL 的行
```

## 聚集不同值

+ MySQL 5及后期版本 聚集函数的 DISTINCT 的使用

+ 以上 5 个聚集函数：

    + 对所有的行执行计算，指定 ALL 参数或不给参数（ ALL 是默认行为 ）
    + 只包含不同的值，指定 DISTINCT 参数

```SQL
SELECT AVG(DISTINCT prod_price) AS avg_price
FROM products
WHERE vend_id = 1003;
```

+ DISTINCT 不能用于 COUNT(*)。DISTINCT 必须使用列名，不能用于计算或表达式

## 组合聚合函数

```SQL
SELECT COUNT(*) AS num_items,
       MIN(prod_price) AS price_min,
       MAX(prod_price) AS price_max,
       AVG(prod_price) AS price_avg
FROM products;

// 在指定别名以包含某个聚集函数的结果时，不应该使用表中实际的列名。
```

# 分组数据

## GROUP BY

```SQL
SELECT vend_id, COUNT(*) AS num_prods
FROM products
GROUP BY vend_id;
```

+ 规定

    + GROUP BY 子句可以包含任意数目的列。
    + 如果在 GROUP BY 子句中嵌套了分组，数据将在最后规定的分组上进行汇总。
    + GROUP BY 子句中列出的每个列都必须是检索列或有效的表达式。（但不能是聚集函数）。如果在 SELECT 中使用表达式，则必须在 GOURP BY 子句中指定相同的表达式。不能使用别名。
    + 除聚集计算语句外，SELECT 语句中的每个列都必须在 GOURP BY 子句中给出。
    + 如果分组列中具有 NULL 值，则 NULL 将作为一个分组返回。如果列中有多行 NULL 值，它们将分为一组。
    + GOURP BY 子句必须出现在 WHERE 子句之后，ORDER BY 子句之前。

```SQL
// WITH ROLLUP 关键字，可以得到每个分组以及每个分组汇总级别（针对每个分组）的值
SELECT vend_id, COUNT(*) AS num_prods
FROM products
GROUP BY vend_id WITH ROLLUP;
```

## 过滤分组

+ HAVING 非常类似于 WHERE。事实上，目前为止所有学过的所有类型的 WHERE 子句都可以用 HAVING 来替代。唯一的差别是 WHERE 过滤行，而 HAVING 过滤分组。
+ HAVING 支持所有 WHERE 操作符。

```SQL
SELECT cust_id, COUNT(*) AS orders
FROM orders
GROUP BY cust_id
HAVING COUNT(*) >= 2;
```

+ HAVING 和 WHERE 的差别：WHERE 在数据分组前进行过滤，HAVING 在数据分组后进行过滤。

```SQL
SELECT vend_id, COUNT(*) AS num_prods
FROM products
WHERE prod_price >= 10
GROUP BY vend_id
HAVING COUNT(*) >= 2;
```

## 分组和排序

+ ORDER BY

    + 排序产生的输出
    + 任意列都可以使用（甚至非选择的列也可以使用）
    + 不一定需要

+ GROUP BY

    + 分组行。但输出可能不是分组的顺序
    + 只可能使用选择列或表达式列，而且必须使用每个选择列表达式
    + 如果与聚合函数一起使用列（或表达式），则必须使用

+ 一般在使用 GROUP BY 子句时，应该也给出 ORDER BY子句。这是保证数据正确排序的唯一方法。千万不要仅依赖 GROUP BY 排序数据。

```SQL
SELECT order_num, SUM(quantity * item_price) AS ordertotal
FROM orderitems
GROUP BY order_num
HAVING SUM(quantity * item_price) >= 50
ORDER BY ordertotal;
```

## SELECT 子句顺序

```SQL
SELECT // 要返回的列或表达式 // 是
FROM // 从中检索数据的表 // 仅在从表选择数据时使用
WHERE // 行级过滤 // 否
GROUP BY // 分组说明 // 仅在按组计算聚集时使用
HAVING // 组级过滤 // 否
ORDER BY // 输出排序顺序 // 否
LIMIT // 要检索的行数 // 否
```

# 使用子查询

+ MySQL 4.1 引入对子查询的支持。

## 利用子查询进行过滤

+ 在 SELECT 子句中，子查询总是从内向外处理。
+ 格式化 SQL

```SQL
SELECT cust_name, cust_contact
FROM customers
WHERE cust_id IN (SELECT cust_id
                  FROM orders
                  WHERE order_num IN (SELECT order_num
                                     FROM orderitems
                                     WHERE prod_id = 'TNT2'));
// 由于性能限制，不能嵌套太多的子查询。
```

## 作为计算字段使用子查询

```SQL
SELECT cust_name,
       cust_state,
       (SELECT COUNT(*)
        FROM orders
        WHERE orders.cust_id = customers.cust_id) AS orders
FROM customers
ORDER BY cust_name;
```

# 联结表

## 关系表

+ 外键（ foreign key ） 为某个表中的一列，它包含另一个表的主键值，定义了两个表的关系。

## 创建联结

```SQL
SELECT vend_name, prod_name, prod_price
FROM vendors, products
WHERE vendors.vend_id = products.vend_id
ORDER BY vend_name, prod_name;
```

+ 笛卡尔积（ cartesian product）由没有联结条件的表关系返回的结果。第一个表的行数乘以第二个表中的行数。

## 内部联结

```SQL
// 等值联结（ equijoin ），它基于两个表之间的相等测试。这种表称为内部联结
SELECT vend_name, prod_name, prod_price
FROM vendors INNER JOIN products
ON vendors.vend_id = products.vend_id; // 和前面 SELECT 语句相同

// ANSI SQL 规范首选 INNER JOIN 语法。
```

## 联结多个表

```SQL
SELECT prod_name, vend_name, prod_price, quantity
FROM orderitems, products, vendors
WHERE products.vend_id = vendors.vend_id
  AND orderitems.prod_id = products.prod_id
  AND order_num = 20005;

// MySQL 在运行时关联指定的每个表以处理联结。这种处理可能是非常耗费资源的。不要联结不必要的表。
// 联结的表越多，性能下降的越厉害。

SELECT cust_name, cust_contact
FROM customers
WHERE cust_id IN (SELECT cust_id
                  FROM orders
                  WHERE order_num IN (SELECT order_num
                                     FROM orderitems
                                     WHERE prod_id = 'TNT2'));
// 子查询并不总是执行复杂 SELECT 操作的最有效的方法。
SELECT cust_name, cust_contact
FROM customers, orders, orderitems
ON customers.cust_id = orders.cust_id
  AND orders.order_num = orderitems.order_num
  AND prod_id = 'TNT2';
```

# 创建高级联结

## 使用表别名

```SQL
SELECT cust_name, cust_contact
FROM customers AS c, orders AS o, orderitems AS oi
WHERE c.cust_id = o.cust_id
  AND oi.order_num = o.order_num
  AND prod_id = 'TNT2';

// 表别名只在查询执行中使用。与列别名不一样，表别名不返回到客户机
```

## 使用不同类型的联结

### 自联结

```SQL
SELECT prod_id, prod_name
FROM products
WHERE vend_id = (SELECT vend_id
                 FROM products
                 WHERE prod_id = 'DTNTR');
// 联结查询
SELECT p1.prod_id, p1.prod_name
FROM products AS p1, products AS p2
WHERE p1.vend_id = p2.vend_id
  AND p2.prod_id = 'DTNTR';

// 自联结通常作为外部语句用来替代从相同表中检索数据时使用的子查询语句。
// 有时候处理联结远比处理子查询快得多，应该尝试两种方法，确定哪一种性能更好。
```

### 自然联结

```SQL
// 自然联结 排除多次出现，使每个列只返回一次。
// 一般通过对表中使用通配符（SELECT * ），对所有其他表的列使用明确的子集完成的。
SELECT c.*, o.order_num, o.order_date, oi.prod_id, oi.quantity, oi.item_price
FROM customers AS c, orders AS o, orderitems AS oi
WHERE c.cust_id = o.cust_id
  AND oi.order_num = o.order_num
  AND prod_id = 'FB';
```

### 外部联结

```SQL
// 联结包含了那些在相关表中没有关联的行。

// 内联结
SELECT customers.cust_id, orders.order_num
FROM customers INNER JOIN orders
  ON customer.cust_id = orders.cust_id;

// 外部联结
SELECT customers.cust_id, orders.order_num
FROM customers LEFT OUTER JOIN orders
  ON customer.cust_id = orders.cust_id;
```

+ MySQL 不支持简化字符 `*=` 和 `=*` 的使用，这两个操作符在其他 DBMS 中很流行

## 使用带聚集函数的联结

```SQL
SELECT customers.cust_name,
       customers.cust_id,
       COUNT(orders.order_num) AS num_ord
FROM customers INNER JOIN orders
  ON customers.cust_id = orders.cust_id
GROUP BY customers.cust_id;

SELECT customers.cust_name,
       customers.cust_id,
       COUNT(orders.order_num) AS num_ord
FROM customers LEFT OUTER JOIN orders
  ON customers.cust_id = orders.cust_id
GROUP BY customers.cust_id;
```

## 使用联结和联结条件

+ 要点

    + 注意所使用的联结类型
    + 保证使用正确的联结条件，否则将返回不正确的数据
    + 应该总是提供联结条件，否则会得出笛卡尔积
    + 在一个联结中可以包含多个表，甚至对于每个联结可以采用不同的联结类型。记得分别测试每个联结

# 组合查询

+ MySQL 也允许执行多个查询（多条 SELECT 语句），并将结果作为单个查询结果集返回。这些组合查询通常称为并（ union ）或复合查询（ compound query ）
+ 需要使用组合查询

    + 在单个查询中从不同的表返回类似结构的数据
    + 对单个表执行多个查询，按单个查询返回数据

+ 组合查询和多个 WHERE 条件，任何具有多个 WHERE 子句的 SELECT 语句都可以作为一个组合查询给出。这两种技术在不同的查询中性能也不同，因此，应该试一下，以确定对特定的查询哪一种性能更好。

+ 可用 UNION 操作符来组合数条 SQL 查询。

```SQL
SELECT vend_id, prod_id, prod_price
FROM products
WHERE prod_price <= 5;
UNION
SELECT vend_id, prod_id, prod_price
FROM products
WHERE vend_id IN (1001, 1002);
```

## UNION 规则

+ UNION 必须由两条或两条以上的 SELECT 语句组成，语句之间关键字 UNION 分隔。
+ UNION 的每个查询必须包含相同的列，表达式或聚集函数。（各个列不需要以相同的次序列出）
+ 列数据类型必须兼容：类型不必完全相同，但必须是 DBMS 可以隐含地转换的类型

## 包含或取消重复的行

+ UNION 从查询集中自动去除了重复的行。
+ UNION ALL 返回所有匹配行。

## 对组合查询结果排序

```SQL
SELECT vend_id, prod_id, prod_price
FROM products
WHERE prod_price <= 5
UNION
SELECT vend_id, prod_id, prod_price
FROM products
WHERE vend_id IN (1001, 1002)
ORDER BY vend_id, prod_price;

// 不允许使用多条 ORDER BY 子句
// 上面这个 SQL ，MySQL 将用它来排序所有 SELECT 语句返回的所有结果。
```

+ 使用 UNION 的组合查询也可以应用不同的表

# 全文本搜索

+ 并非所有引擎都支持全文搜索。
+ MySQL 支持集中基本的数据库引擎。最常使用的引擎为 MyISAM 和 InnoDB 前者支持全文搜索，而后者不支持。

+ Like 关键字和正则搜索机制非常有用，但存在几个重要的限制

    + 性能，通配符和正则表达式匹配通常要求 MySQL 尝试匹配表中所有行（而且这些搜索极少使用表索引）。因此，由于被搜索行数不断增加，这些搜索可能非常耗时。
    + 明确控制，使用通配符和正则表达式匹配，很难明确地控制匹配什么和不匹配什么。
    + 智能化的结果，虽然基于通配符和正则表达式的搜索提供了非常灵活的搜索。但它们都不能提供一种智能化的选择结果的方法。

## 使用全文本搜索

+ 为了进行全文本搜索，必须索引被搜索到列，而且要随着数据的改变不断地重复索引。
+ 在索引之后，SELECT 可与 Match() 和 Against() 一起使用以实际执行搜索。

### 启用全文本搜索支持

```SQL
// CREATE TABLE 语句接受 FULLTEXT 子句，它给出被索引列的一个逗号分隔的列表。
CREATE TABLE productnotes
(
    note_id int NOT NULL AUTO_INCREMENT,
    prod_id char(10) NOT NULL,
    note_date datetime NOT NULL,
    note_text text NULL,
    PRIMARY KEY(note_id),
    FULLTEXT(note_text)
) ENGINE=MyISM;
```

+ 在定义之后，MySQL 自动维护该索引。在增加，更新或删除行时，索引随之自动更新。
+ 可以创建表时指定 FULLTEXT，或者在稍后指定（在这种情况下已有数据必须立即索引）
+ 不要在导入数据时使用 FULLTEXT 。更新索引要花时间，虽然不是很多，但毕竟要花时间。如果正在导入数据到一个新表，应该首先导入所有数据，然后再修改表，定义 FULLTEXT。

### 进行全文本搜索

```SQL
// 在索引之后，使用两个函数 Match() 和 Against() 执行全文本搜索
// Match() 指定被搜索的列，Against() 指定要使用的搜索表达式。
SELECT note_text
FROM productnotes
WHERE Match(note_text) Against('rabbit');
```

+ 传递给 Match() 的值必须与 FULLTEXT() 定义中的相同。如果指定多个列，则必须列出它们（而且次序正确）

+ 除非使用 BINARY 方式，否则全文本搜索不区分大小写。

+ 不包含 ORDER BY 子句。使用 LIKE 以不特别有用的顺序返回数据。全文搜索返回以文本匹配的良好程度排序的数据。
+ 全文搜索的一个重要部分就是对结果排序。具有较高等级的行先返回（因为这些是你真正想要的行）

```SQL
SELECT note_text,
       Match(note_text) Against('rabbit') AS rank
FROM productnotes;
// 返回所有行，rank 包含全文本搜索计算出的等级值。
// 等级由 MySQL 根据行中词的数目，唯一词的数目，整个索引中词的总数以及包含该词的行的数目计算出来。
// 文本中词靠前的行的等级值比词靠后的行的等级值高。
```

+ 如果指定多个搜索项，则包含多数匹配词的那些行将具有比包含较少词的那些行高的等级值。
+ 由于数据是索引的，全文搜索还相当快。

### 使用查询扩展

+ 查询扩展用来设法放宽所返回的全文本搜索结果的范围。

+ MySQL 对数据和索引进行两遍扫描来完成搜索：

    + 首先，进行一个基本的全文本搜索，找出与搜索条件匹配的所有行
    + 其次，MySQL 检查这些匹配行并选择所有有用的词
    + 再其次，MySQL 再次进行全文本搜索，这次不仅使用原来的条件，而且还使用所有有用的词。

+ 利用查询扩展，能找出可能相关的结果，即使它们并不精确包含所查找的词。
+ 查询扩展功能是在 MySQL 4.1.1 引入的。

```SQL
// 没有查询扩展
SELECT note_text
FROM productnotes
WHERE Match(note_text) Against('anvils');

// 查询扩展
SELECT note_text
FROM productnotes
WHERE Match(note_text) Against('anvils', WITH QUERY EXPANSION);
// 查询扩展极大地增加了返回的行数，但这样做也增加了你实际上并不想要的行的数目
```

+ 表中的行越多，使用查询扩展返回的结果越好

### 布尔文本搜索

+ 布尔方式（boolean mode）

    + 要匹配的词
    + 要排斥的词（如果某行包含这个词，则不返回该行，即使它包含其他指定的词也是如此）
    + 排列提示（指定某些词比其他词更重要，更重要的词等级更高）
    + 表达式分组
    + 另外一些内容

+ 即使没有定义 FULLTEXT 索引，也可以使用布尔方式，但这是一种非常缓慢的操作（其性能随着数据量的增加而降低）

```SQL
// 使用 IN BOOLEAN MODE 但实际上没有指定布尔操作符
SELECT note_text
FROM productnotes
WHERE Match(note_text) Against('heavy' IN BOOLEAN MODE);

SELECT note_text
FROM productnotes
WHERE Match(note_text) Against('heaby -rope*' IN BOOLEAN MODE);
// -rope* 明确地指示 MySQL 排除任何以 rope 开始的词，包括 ropes 的行

// MySQL 4.x 中使用上面的例子不返回任何行，这是 * 操作符处理中的一个错误。修改 -rope* 为 -ropes。
```

+ 全文本布尔操作符

    ```text
    +   包含，词必须存在
    -   排除，词必须不存在
    >   包含，而且增加等级值
    <   包含，且减少等级值
    ()  把词组成子表达式（允许这些子表达式作为一个组被包含，排除，排列等）
    ~   取消一个词的排序值
    *   词尾的通配符
    ""  定义一个短语（与单个词的列表不一样，它匹配整个短语以便包含或排出这个短语）
    ```

```SQL
SELECT note_text
FROM productnotes
WHERE Match(note_text) Against('+rabbit +bait' IN BOOLEAN MODE);

SELECT note_text
FROM productnotes
WHERE Match(note_text) Against('rabbit bait' IN BOOLEAN MODE);
// 搜索匹配至少包含一个词的行

SELECT note_text
FROM productnotes
WHERE Match(note_text) Against('"rabbit bait"' IN BOOLEAN MODE);
// 搜索匹配短语 rabbit bait

SELECT note_text
FROM productnotes
WHERE Match(note_text) Against('>rabbit <carrot' IN BOOLEAN MODE);

SELECT note_text
FROM productnotes
WHERE Match(note_text) Against('+safe +(<combination)' IN BOOLEAN MODE);
```

+ 在布尔方式中，不按等级值降序排序返回的行。

### 全文本搜索的使用说明

+ 在索引全文本数据时，短词被忽略且从索引中排除。短词定义为那些具有 3 个或 3 个以下字符的词（如果需要，这个数目可以更改）
+ MySQL 带有一个内建的非用词（stopword）列表，这些词在索引全文本数据时总是被忽略。（如果需要可以覆盖这个列表）
+ 许多词出现的频率很高，搜索他们没有用处（返回太多的结果）。因此，MySQL 规定了一条 50% 规则，如果一个词出现在 50% 以上的行中，则将它作为一个非用词忽略。 50% 的规则不用于 IN BOOLEAN MODE
+ 如果表中的行数少于 3 行，则全文本搜索的不返回结果（因为每个词或者不出现，或者至少出现在 50% 的行中）
+ 忽略词中的单引号。
+ 不具有词分隔符的语言不能恰当地返回全文本搜索结果。
+ 如前所述，仅在 MyISAM 数据库引擎中支持全文本搜索。

+ MySQL 全文本搜索现在还不支持邻近操作符。（搜索相邻的词）

# 插入数据

## 数据插入

+ 插入的几种方式

    + 插入完整的行
    + 插入行的一部分
    + 插入多行
    + 插入某些查询的结果

+ 可针对每个表或每个用户，利用  MySQL 的安全机制禁止使用 INSERT 语句

## 插入完整的行

```SQL
INSERT INTO Customers 
VALUES(NULL,
       'Pep E. LaPew',
       'Los Angeles',
       'CA',
       '90046',
       'USA',
       NULL,
       NULL);

// 必须给出每个列，各个列必须以它们在表定义中出现的次序填充。
// 某个列没有值，应该使用 NULL 值。
// 主键也为 NULL ，由 MySQL 自动增量。不能省略此列
// 不安全，尽量避免使用，上面的 SQL 高度依赖于表中列的定义次序，并且还依赖于其次序容易获得的消息。
```

+ INSERT 语句一般不会产生输出。

```SQL
INSERT INTO customers(cust_name,
    cust_address,
    cust_city,
    cust_state,
    cust_zip,
    cust_country,
    cust_contact,
    cust_email)
VALUES('Pep E, LaPew',
    '100 Main Street',
    'Los Angeles',
    'CA',
    '90046',
    'USA',
    NULL,
    NULL);

// VALUES 必须以指定次序匹配指定的列名。
// 不需要设置主键的 NULL 值。
```

+ 一般不要使用没有明确给出列的列表的 INSERT 语句。使用列的列表能使 SQL 代码继续发挥作用，即使表结构发生了变化。
+ 不管使用哪种 INSERT 语法，都必须给出 VALUES 的正确数目。

+ 如果表的定义允许，则可以在 ISNERT 操作中省略某些列。

    + 该列定义为允许 NULL 值（无值或空值）
    + 在表定义中给出默认值。这表示如果不给出值，将使用默认值。

+ 数据库经常被多个客户访问，对处理什么请求以及用什么次序处理进行管理时 MySQL 的任务。INSERT 操作可能很耗时（特别是有很多索引需要更新时），而且它可能降低等待处理的 SELECT 语句的性能。
+ 如果数据检索是最重要的，则你可以通过在 INSERT 和 INTO 之间添加关键字 LOW_PRIORITY ，指示 MySQL 降低 INSERT 语句的优先级 `INSERT  LOW_PRIORITY INTO` 也适用于 UPDATE 和 DELETE 语句。

## 插入多个行

```SQL
// 使用多条 INSERT 语句
// 或者
INSERT INTO customers(cust_name,
    cust_address,
    cust_city,
    cust_state,
    cust_zip,
    cust_country)
VALUES(
    'Pep E. LaPew',
    '100 Main Street',
    'Los Angeles',
    'CA',
    '90046',
    'USA'
), (
    'M. Martian',
    '42 Galaxy Way',
    'New Yorw',
    'NY',
    '11213',
    'USA'
);
// 单条 INSERT 语句有多组值，每组值用一对圆括号括起来，用逗号分隔。
// 次技术可以提高数据库处理的性能，因为 MySQL 用单条 INSERT 语句处理多个插入比使用多条 INSERT 语句快。
```

## 插入检索出的数据

+ 假如你想从另一个表中合并客户列表到你的 customers 表。不需要每次读取一行，然后再将它用 `INSERT` 插入。
+ 合并表时，不应该使用当前表中使用过的主键值或仅省略这列值让 MySQL 在导入数据的过程中产生新值。

```SQL
INSERT INTO customers(cust_id,
    cust_contact,
    cust_email,
    cust_name,
    cust_address,
    cust_city,
    cust_state,
    cust_zip,
    cust_country)
SELECT cust_id,
    cust_contact,
    cust_email,
    cust_name,
    cust_address,
    cust_city,
    cuts_state,
    cust_zip,
    cust_country)
FROM custnew;
// 这里假设 cust_id 的值不重复，也可以省略
// INSERT 和 SELECT 语句中使用了相同的列名，但是不一定要求列名匹配
// 事实上，MySQL 甚至不关心 SELECT 返回的列名，它使用的是列的位置，SELECT 中的第一列（不管其列名）将用来填充表列中指定的第一个列
// 这对于从使用不同列名的表中导入数据是非常有用的。
// INSERT SELECT 中的 SELECT 语句可包含 WHERE 子句以过滤插入的数据。
```

# 更新和删除数据

## 更新数据

+ 采用两种方式使用 UPDATE：

    + 更新表中特定行
    + 更新表中所有行

+ 在使用 UPDATE 时一定要注意细心，因为稍不注意，就会更新表中所有行，不要省略 WHERE 子句。
+ 可以限制和控制 UPDARTE 语句的使用
+ UPDATE 组成部分

    + 要更新的表
    + 列名和它们的新值
    + 确定要更新行的过滤条件

```SQL
UPDATE customers
SET cust_email = 'elmer@fudd.com'
WHERE cust_id = 10005;

UPDATE customers
SET cust_name = 'THE Fudds'
    cust_email = 'elmer@fudd.com'
WHERE cust_id = 10005;
```

+ UPDATE 语句中可以使用子查询，使得能用 SELECT 语句检索出的数据更新列数据。
+ 如果 UPDATE 语句更新多行，更新这些行中的一行或多行出一个错误，则整个 UPDATE 操作被取消。为即使是发生错误，也继续更新可以使用 IGNORE 关键字 `UPDATE IGNORE customers...`

```SQL
// 为了删除某个列的值，可设置它为 NULL（假定表定义允许 NULL 值）
UPDATE customers
SET cust_email = NULL,
WHERE cust_id = 10005;
```

## 删除数据

+ 使用方式

    + 从表中删除特定的行
    + 从表中删除所有行

+ 不要省略 WHERE 子句
+ 可以限制和控制 DELETE 语句的使用

```SQL
DELETE FROM customers
WHERE cust_id = 10006;
//  DELETE 删除整行而不是删除列，为了删除指定的列，使用 UPDATE 语句
```

+ 如果要删除所有行，不要使用 `DELETE`。使用更快的 `TRUNCATE TABLE`  语句（TRUNCATE 实际上是删除原来的表并重新创建一个表，而不是逐行删除表中的数据）

## 更新和删除的指导原则

+ 遵循的习惯

    + 除非确实打算更新和删除每一行，否则绝对不要使用不带 WHERE 子句的 UPDATE 或 DELETE语句
    + 保证每个表都有主键，尽可能像 WHERE 子句那样使用它（可以指定各主键，多个值或值的范围）
    + 在对 UPDATE 或 DELETE 语句使用 WHERE子句前，应该先用 SELECT 进行测试，保证它过滤的是正确的记录，以防编写的 WHERE 子句不正确。
    + 使用强制实施引用完整性的数据库，这样 MySQL 将不允许删除具有与其他表相关联的数据的行。
    + MySQl 没有撤销（undo）按钮。应该非常小心地使用 UPDATE 和 DELTE。


# 创建和操纵表

## 创建表

+ 创建表的方法

    + 使用具有交互式的创建和管理表的工具
    + 表也可以直接 MySQL 语句操纵

### 表创建基础

+ 利用 CREATE TABLE 创建表，必须给出信息：

    + 新表的名字，在关键字 CREATE TABLE 之后给出
    + 表列的名字和定义，用逗号分隔

```SQL
CREATE TABLE customers
(
    cust_id      int        NOT NULL AUTO_INCRMENT,
    cust_name    char(50)   NOT NULL,
    cust_address char(50)   NULL,
    cust_city    char(50)   NULL,
    cust_state   char(5)    NULL,
    cust_zip     char(10)   NULL,
    cust_country char(50)   NULL,
    cust_contact char(50)   NULL,
    cust_email   char(255)  NULL,
    PRIMARY KEY (cust_id)  
) ENGINE=InnoDB;
// 语句格式化  MySQL 语句中忽略空格
// 创建表时，指定的表名必须不存在。在表名后给出 `IF NOT EXISTS`
```

### 使用 NULL 值

+ `NULL` 值就是没有值或缺值。允许 NULL 值的列也允许在插入行时不给出该列的值。不允许 NULL 值的列不接受该列没有值的行，在插入或更新行时，该列必须有值。

```SQL
CREATE TABLE orders
(
    order_num   int         NOT NULL AUTO_INCREMENT,
    order_date  datetime    NOT NULL,
    cuts_id     int         NOT NULL,
    PRIMARY KEY(order_num)
) ENGINE=InnoDB;
// NULL 为默认设置，如果不指定 NOT NULL，则认为指定的是 NULL
```

+ 不要把 NULL 值与空串相混淆。空串是一个有效的值

## 主键再介绍

+ 主键值必须唯一。

```SQL
CREATE TABLE orderitems
(
    order_num   int         NOT NULL，
    order_item  int         NOT NULL,
    prod_id     char(10)    NOT NULL,
    quantity    int         NOT NULL,
    item_price  decimal(8,2)NOT NULL,
    PRIMARY KEY(order_num, order_item)
) ENGINE=InnoDB;
```

+ 主键可以在创建表时定义，或者在创建表之后定义
+ 主键中只能使用不允许 NULL 值的列。允许 NULL 值的列不能作为唯一标识。

### 使用 AUTO_INCREMENT

+ 每个表允许一个 AUTO_INCREMENT 列，而且它必须被索引（如，通过使它成为主键）
+ 覆盖 AUTO_INCREMENT 。可以简单地在 INSERT 语句中指定一个值，只要它是唯一的即可，该值将被用来替代自动生成的值。后续的增量将开始使用该手工插入的值。
+ 让 MySQL 生成（通过自动增量）主键的一个缺点时你不知道这些值都是谁。

```SQL
// 使用
last_insert_id() // 函数获得这个值
SELECT last_insert_id()
// 此语句返回最后一个 AUTO_INCREMENT 值，然后可以将它用于后续的 MySQL 语句
```

### 指定默认值

```SQL
// 插入行没有给出值，MySQL 允许指定此时使用的默认值
CREATE TABLE orderitems
(
    order_num   int     NOT NULL,
    order_item  int     NOT NULL,
    quantity    char(10)NOT NULL DEFAULT 1,
    item_price  decimal(8, 2)NOT NULL,
    PRIMARY KEY (order_num, order_item)
) ENGINE=InnDB;
```

+ 与大多数 DBMS 不一样，MySQL 不允许使用函数作为默认值，它只支持常量。
+ 使用默认值而不是 NULL 值，特别是对用于计算或数据分组的列更是如此。

### 引擎类型

+ MySQL 有一个具体管理和处理数据的内部引擎。在使用 CREATE TABLE 语句时，该引擎具体创建表，而在你使用 SELECT 语句或进行其他数据库处理时，该引擎在内部处理你的请求。
+ 但 MySQL 与其他 DBMS 不一样，它具有多种引擎。它打包多个引擎，这些引擎都隐藏在 MySQL 服务器内，全都能执行 CREATE TABLE 和 SELECT 等命令。
+ 如果省略 `ENGINE=` 语句，则使用默认引擎（很可能是 MyISAM），多数 SQL 语句都会默认使用它。但并不是所有语句都默认使用它，这就是为什么 `ENGINE=` 语句。
+ 需要知道的引擎

    + InnoDB 是一个可靠的事务处理引擎，它不支持全文本搜索。
    + MEMORY 在功能上等同于 MyISAM，但由于数据存储在内存（不是磁盘）中，速度很快（特别适合临时表）
    + MyISAM 是一个性能极高的引擎，它支持全文本搜索，但不支持事务处理。

+ 引擎类型可以混用。
+ 混用引擎类型有一个大缺陷。外键（用于强制实施引用完整性）不能跨引擎，即使用一个引擎的表不能引用具有使用不同引擎的表的外键

## 更新表

+ 更新表定义，可使用 ALTER TABLE 语句。但是，理想状态下，当表中存储数据以后，该表就不应该再被更新。
+ 更改表结构，必须给出下面的消息：

    + 在 ALTER TABLE 之后给出要更改的表名
    + 所做更改的列表

```SQL
// 增加一个列
ALTER TABLE vendors
ADD vend_phone CHAR(20);

// 删除添加的列
ALTER TABLE vendors
DROP COLUMN vend_phone;
```

+ ALTER TABLE 的一种常见用途是定义外键。

```SQL
ALTER TABLE orderitems
ADD CONSTRAINT fk_orderitems_orders
FOREIGN KEY (order_num) 
REFERENCES orders (order_num);

ALTER TABLE orderitems
ADD CONSTRAINT fk_orderitems_products
FOREIGN KEY (prod_id) 
REFERENCES products(prod_id);

ALTER TABLE orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (cust_id)
REFERENCES customers (cust_id);

ALTER TABLE products
ADD CONSTRAINT fk_products_vendors
FOREIGN KEY (vend_id)
REFERENCES vendors (vend_id);
```

+ 对单个表进行多个更改，可以使用单条 ALTER TABLE 语句，每个更改用逗号分隔。
+ 复杂的表结构更改一般需要手动删除过程，涉及步骤

    + 用新的列布局创建一个新表
    + 使用 INSERT SELECT 语句从旧表复制数据到新表。如果有必要，可使用转换函数和计算字段
    + 检验包含所需数据到新表
    + 重命名旧表
    + 用旧表原来的名字重命名新表
    + 根据需要，重新创建触发器，存储过程，索引和外键

+ 使用 ALTER TABLE 要极为小心，应该在进行改动前做一个完整的备份（模型和数据的备份）数据库表的更改不能撤销。

## 删除表

```SQL
DROP TABLE customers2;
// 删除表没有确认，也不能撤销，执行这条语句将永久删除该表
```

## 重命名表

```SQL
// 重命名一个表
RENAME TABLE customers2 TO customers;

// 重命名多个表
RENAME TABLE backup_customer TO customers,
             backup_vendors TO vendors,
             backup_products TO products;
```

# 使用视图

## 视图

+ MySQL 5 添加了对视图的支持。
+ 视图是虚拟的表。与包含数据的表不一样，视图只包含使用时动态检索数据的查询 。

```SQL
SELECT cust_name, cust_contact
FROM cusstomers, orders, orderitems
WHERE customers.cust_id = orders.cust_id
  AND orderitems.order_num = orders.order_num
  AND prod_id = 'TNT2';

SELECT cust_name, cust_contact
FROM productcustomers
WHERE prod_id = 'TNT2';
```

### 为什么使用视图

+ 常见应用

    + 重用 SQL 语句
    + 简化复杂的 SQL 操作。在编写查询后，可以方便地重用它而不必知道它的基本查询细节
    + 使用表的组成部分而不是整个表
    + 保护数据。可以给用户授予表的特定部分的访问权限而不是整个表的访问权限。
    + 更改数据格式和表示。视图可返回与底层表的表示和格式不同的数据

+ 视图本身不包含数据，因此它们返回的数据是从其他表中检索出来的。在添加或更改这些表中的数据时，视图将返回改变过的数据。
+ 因为视图不包含数据。所以每次使用视图时，都必须处理查询执行时所需的任一检索。如果你用多个联结和过滤创建了复杂的视图或者嵌套了视图，可能会发现性能下降得很厉害。因此，在部署使用了大量视图的应用前，应该进行测试。

### 视图的规则和限制

+ 最常见的规则和限制

    + 与表一样，视图必须唯一命名。
    + 对于可以创建的视图数目没有限制。
    + 为了创建视图，必须具有足够的访问权限。这些限制通常由数据库管理人员授予。
    + 视图可以嵌套，即可以利用从其他视图中检索数据的查询来构造一个视图。
    + ORDER BY 可以用在视图中，但如果从该视图检索数据 SELECT 中也含有 ORDER BY ，那么该视图中的 ORDER BY 将被覆盖。
    + 视图不能索引，也不能有关联的触发器或默认值。
    + 视图可以和表一起使用。

## 视图

+ 视图的创建

   + 视图用 CREATE VIEW 语句来创建
   + 使用 SHOW CREATE VIEW viewname; 来查看创建视图的语句。
   + 用 DROP 删除视图，其语法为 DROP VIEW viewname;
   + 更新视图时，可以先用 DROP 再用 CREATE ，也可以直接用 CREATE OR REPLACE VIEW.

### 利用视图简化复杂的联结

```SQL
CREATE VIEW productcustomers AS
SELECT cust_name, cust_contact, prod_id
FROM customers, orders, orderitems
WHERE customers.cust_id = orders.cust_id
  AND orderitems.order_num = orders.order_num;

SELECT cust_name, cust_contact
FROM productcustomers
WHERE prod_id = 'TNT2';

// 它将指定的 WHERE 子句添加到视图查询中的已有 WHERE 子句中，以便正确过滤数据。
```

+ 创建不受特定数据限制的视图时一种好办法。

### 用视图重新格式化检索出的数据

+ 视图另一个常见用途是重新格式化检索出的数据。

```SQL
SELECT Concat(RTrim(vend_name), '(', RTrim(vend_country), ')') AS vend_title
FROM vendors
ORDER BY vend_name;

CREATE VIEW vendorlocations AS
SELECT Concat(RTrim(vend_name), '(', RTrim(vend_country), ')') AS vend_title
FROM vendors
ORDER BY vend_name;

SELECT *
FROM vendorlocations;
```

### 用视图过滤不想要的数据

```SQL
CREATE VIEW customeremaillist AS
SELECT cust_id, cust_name, cust_email
FROM customers
WHERE cust_email IS NOT NULL;
```

### 使用视图与计算字段

```SQL
CREATE VIEW orderitemsexpanded AS
SELECT order_num,
       prod_id,
       quantity,
       item_price,
       quantity*item_price AS expanded_price
FROM orderitems;

SELECT *
FROM orderitemsexpanded
WHERE order_num = 20005;
```

### 更新视图

+ 更新一个视图将更新其基表。
+ 如果 MySQL 不能正确地确定被更新的基数据，则不允许更新（插入，删除）。
+ 如果视图定义中有以下操作，则不能进行视图的更新：

    + 分组（使用 GROUP BY 和 HAVING）
    + 联结
    + 子查询
    + 并
    + 聚集函数（Min(),Count(),Sum()）
    + DISTINCT
    + 导出

+ 上面的限制自 MySQL 5以来是正确的。不过，未来的 MySQL 很可能会取消某下限制。

+ 一般，应该将视图用于检索（SELECT 语句）而不用于更新（INSERT,UPDATE,DELETE）

+ 视图提供了一种哦 MySQL 的 SELECT 语句层次的封装，可用来简化数据处理以及重新格式化基础数据或保护基础数据。

# 使用存储过程

## 存储过程

+ MySQL 5 添加了对存储过程的支持。

## 为什么要使用存储过程

+ 主要的理由

    + 通过把处理封装在容易使用的单元中，简化复杂的操组。
    + 由于不要求反复建立一系列处理步骤，这保证了数据的完整性。防止错误，需要执行的步骤越多，出错的可能性就越大。防止错误保证了数据的一致性。
    + 简化对变动的管理。如果表名，列名或业务逻辑有变化，只需要更改存储过程的代码。使用它的人员甚至不需要知道这些变化。这一点是安全性。通过存储过程限制对基础数据的访问减少了数据讹误的机会。
    + 提高性能。使用存储过程比使用单独的 SQL 语句要快
    + 存在一些只能用在单个请求中的 MySQL 元素和特性，存储过程可以使用它们来编写功能更强更灵活的代码。

+ 简单，安全，高性能。缺陷

    + 一般来说，存储过程的编写比基本 SQL 语句复杂，编写存储过程需要更高的技能，更丰富的经验。
    + 没有创建存储过程的安全访问权限。

## 使用存储过程

### 执行存储过程

+ MySQL 称存储过程的执行为调用，因此 MySQL 执行存储过程的语句为 CALL。CALL 接受存储过程的名字以及需要传递给它的任意参数。

```SQL
CALL productpricing(
        @pricelow,
        @pricehigh,
        @priceaverage
);
```

### 创建存储过程

```SQL
CREATE PROCEDURE productpricing()
BEGIN
    SELECT Avg(prod_price) AS priceaverage
    FROM products;
END;
```

+ MySQL 命令行客户机的分隔符

```SQL
// MySQL 命令行也使用 ';' 字符，则它们最终不会成为存储过程的成分，这会使用存储过程中的 SQL 出现句法错误。
// 解决办法是临时更改命令行实用程序的语句分隔符。

DELIMITER //
CREATE PROCEDURE productpricing()
BEGIN
    SELECT Avg(prod_price) AS priceaverage
    FROM products;
END //

DELIMITER ;

// 除了  `\` 符号外，任何字符都可以用作语句分隔符。
// 使用
CALL productpricing();
// 执行刚创建的存储过程并显示返回的结果。因为存储过程是一种函数，所以存储过程名后需要有（）符号。
```

### 删除存储过程

```SQL
DROP PROCEDURE productpricing;
// 没有使用后面的()，只给出存储过程名。

DROP PROCEDURE IF EXISTS
```

### 使用参数

+ 一般，存储过程并不显示结果，而是把结果返回给你指定的变量。
+ 变量（variable）内存中一个特定的位置，用来临时存储数据。

```SQL
CREATE PROCEDURE productpricing(
    OUT pl DECIMAL(8, 2),
    OUT ph DECIMAL(8, 2),
    OUT pa DECIMAL(8, 2)
)
BEGIN
    SELECT Min(prod_price)
    INTO pl
    FROM products;
    SLECT Max(prod_price)
    INTO ph
    FROM products;
    SELECT Avg(prod_price)
    INTO pa
    FROM products;
END;
// 此存储过程接受 3 个参数。每个参数必须具有指定的类型，这里使用十进制值。
// 关键字 OUT 指出相应的参数用来从存储过程传出一个值（返回给调用者）。
// MySQL 支持 IN （传递给存储过程），OUT （从存储过程传出）和 INOUT （对存储过程传入和传出）类型的参数。
// 存储过程的代码位于 BEGIN 和 END 语句内。一系列 SELECT 语句，用来检索值，然后保存到相应的变量（通过指定 INTO 关键字）
```

+ 存储过程的参数允许的数据类型与表中使用的数据类型相同。
+ 记录集不是允许的类型，因此，不能通过一个参数返回多个行和列。

```SQL
CALL productpricing(
    @pricelow,
    @pricehigh,
    @priceaverage
);
// 所有 MySQl 变量都必须以 @ 开始。
// 在调用时，这条语句并不显示任何数据。它返回以后可以显示的变量。
SELECT @priceaverage;
SELECT @pricehigh, @pricelow, @priceaverage

CREATE PROCEDURE ordertotal(
    IN onumber INT,
    OUT ototal DECIMAL(8,2)
)
BEGIN
    SELECT Sum(item_price*quantity)
    FROM orderitems
    INTO ototal;
END;

CALL ordertotal(20005, @total);
SELECT @total;
```

### 建立智能存储过程

+ 只有在存储过程内包含业务规则和智能处理时，它们的威力才真正显现出来。

```SQL
-- Name: ordertotal
-- Parameters: onumber = order number
--             taxable = 0 if not taxable, 1 if taxable
--             ototal = order total variable

CREATE PROCEDURE ordertotal(
    IN onumber INT,
    IN taxable BOOLEAN,
    OUT ototal DECIMAL(8,2)
) COMMENT 'Obtain order total, optionally adding tax'

-- Declare variable for total
DECLARE total DECIMAL(8,2);
-- Declare tax percentage
DECLARE taxrate INT DEFAULT 6;

-- Get the order total
SELECT Sum(item_price*quantity)
FROM orderitems
WHERE order_num = onumber
INTO total;

-- Is this taxable?
IF taxable THEN
    -- Yes, so add taxrate to the total
    SELECT total+(total/100*taxtate) INTO total;
END IF;
    -- And finally, save to out variable
    SELECT total INTO ototal;
END;

// -- 注释
// DECLARE 语句定义了两个局部变量。DECLARE 要求指定变量名和数据类型
// COMMENT 值，它不必需的，但如果给出，将在 SHOW PROCEDURE STATUS 的结果中显示。

CALL ordertotal(20005, 0, @total);
SELECT @total;
CALL ordertotal(20005, 1, @total);
SELECT @total;
```

### 检查存储过程

```SQL
// 显示用来创建一个存储过程的 CREATE 语句，使用 SHOW CREATE PROCEDURE 语句
SHOW CREATE PROCEDURE ordertotal;

// 显示包括何时，由谁创建等详细信息的存储过程列表
SHOW PROCEDURE STATUS
// 限制过程状态的结果
SHOW PROCEDURE STATUS LIKE 'ordertotal';
```

# 使用游标

## 游标

+ MySQL 5 添加了对游标的支持。
+ MySQL 检索操作返回一组称为结果集的行。
+ 有时，需要在检索出来的行中前进或后退一行或多行。这就是游标。游标（cuursor）是一个存储在 MySQl 服务器上的数据库查询，它不是一条 SELECT 语句，而是被该语句检索检索出来的结果集。
+ 在存储了游标之后，应用程序可以根据需要滚动或浏览其中的数据。

+ 游标主要用于交互式应用，其中用户需要滚动屏幕上的数据，并对数据进行浏览或做出更改。
+ 不想多数 DBMS，MySQL 游标只能用于存储过程（和函数）。

## 使用游标

+ 涉及步骤

    + 在能够使用游标前，必须声明（定义）它。这个过程实际上没有检索数据，它只是定义要使用的 SELECT 语句。
    + 一旦声明后，必须打开游标以供使用。这个过程用前面定义的 SELECT 语句把数据实际检索出来。
    + 对于填有数据的游标，根据需要取出（检索）各行。
    + 在结束游标使用时，必须关闭游标。

+ 在声明游标后，可根据需要频繁地打开和关闭游标。在游标打开后，可根据需要频繁地执行取操作。

### 创建游标

```SQL
// 游标用 DECLARE 语句创建。DECLARE 命名游标，并定义相应的 SELECT 语句，根据需要带 WHERE 和其他子句。
CREATE PROCEDURE processorders()
BEGIN
    DECLARE ordernumbers CURSOR
    FOR
    SELECT order_num FROM orders;
END;
// 存储过程处理完成后，游标就消失（因为它局限于存储过程）
// 在定义游标之后，可以打开它。
```

### 打开和关闭游标

```SQL
// OPEN CURSOR 打开
OPEN ordernumbers;
// 在处理 OPEN 语句时执行查询，存储检索出的数据以供浏览和滚动。

// 游标处理完成后，应当使用如下语句关闭游标：
CLOSE ordernumbers;
// CLOSE 释放游标使用的所有内部内存和资源，因此在每个游标不再需要时都应该关闭。
// 如果你不明确关闭游标，MySQL 将会在到达 END 语句时自动关闭它。

CREATE PROCEDURE processorders()
BEGIN
    -- Declare the cursor
    DECLARE ordernumbers CURSOR
    FOR
    SELECT order_num FROM orders;
    
    -- Open the cursor
    OPEN ordernumbers;
    
    -- Close the cursor
    CLOSE ordernumbers;
END;
// 这个存储过程声明打开和关闭一个游标。对检索出的数据什么也没做。
```

### 使用游标数据

+ 在一个游标被打开后，可以使用 FETCH 语句分别访问它的每一行。 FETCH 指定检索什么数据（所需的列），检索出来的数据存储在什么地方。它还向前移动游标中的内部行指针，使下一条 FETCH 语句检索下一行（不重复读取同一行）。

```SQL
// 从游标中检索单个行（第一行）
CREATE PROCEDURE processorders()
BEGIN
    
    -- Declare local variables
    DECLARE o INT;
    
    -- Declare the cursor
    DECLARE ordernumbers CURSOR
    FOR
    SELECT order_num FROM orders;
    
    -- Open the cursor
    OPEN ordernumbers;
    
    -- Get order number
    FETCH numbers INTO o;
    
    -- Close the cursor
    CLOSE ordernumbers;
END
// FETCH 用来检索当前行的 order_num 列到一个名为 o 的局部变量中。对检索出的数据不做任何处理。
```

+ 循环检索数据

```SQL
CREATE PROCEDURE processorders()
BEGIN

    -- Declare local variables
    DECLARE done BOOLEAN DEFAULT 0;
    DECLARE o INT;
    
    -- Declare the cursor
    DECLARE ordernumbers CURSOR
    FOR
    SELECT order_num FROM orders;
    
    -- Declare the cursor
    DECLARE ordernumbers CURSOR
    FOR
    SELECT order_num FROM orders;
    
    -- Declare continue handler
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done =1; // CONTINUE HANDLER 是在条件出现时被执行的代码。
    // SQLSTATE '02000' 是一个未找到条件，当 REPEAT 由于没有更多的行供循环而不能继续时，出现这个条件。
    
    -- Open the cursor
    OPEN ordernumbers;
    
    -- Loop through all rows
    REPEAT
    
        -- Get order number
        FETCH ordernumbers INTO o;
    -- End of loop
    UNTIL done END REPEAT;
    
    --Close the cursor
    CLOSE ordernumbers;
END
// 反复执行知道 done 为真
```

+ DECLARE 语句的发布存在特定的次序。用 DECLARE 语句定义的局部变量必须在定义任意游标或句柄之前定义，而句柄必须在游标之后定义。

```SQL
CREATE PROCEDURE processorders()
BEGIN

    -- Declare local variables
    DECLARE done BOOLEAN DEFAUULT 0;
    DECLARE o INT;
    DECLARE t DECIMAL(8,2);

    -- Declare the cursor
    DECLARE ordernumbers FROM orders;
    FOR
    SELECT order_num FROM order;
    
    -- Declare continue handler
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
    -- Create a table to store the results
    CREATE TABLE IF NOT EXISTS ordertotals(order_num INT, total DECIMAL(8,2));
    
    -- Open the cursor
    OPEN ordernumbers;
    
    -- Loop through all rows
    REPEAT
    
        -- Get order number
        FETCH ordernumbers INTO o;
        
        -- Get the total for this order
        CALL ordertotal(o, 1, t);
        
        -- Insert order and total into ordertotals
        INSERT INTO ordertotal(order_num, total)
        VALUES(o, t);

   -- End of loop
   UNTIL done END REPEAT;
   
   -- Close the cursor
   CLOSE ordernumbers;

END;

// CALL 执行另一个存储来计算每个订单的待税的合计（结果存储到t）
```

# 触发器

## 触发器

+ MySQL 5 对触发器支持。
+ 触发器是 MySQL 响应以下任意语句而自动执行的一条 MySQL 语句（或者位于 BEGIN 和 END 语句之间的一组语句）

    + DELETE
    + INSERT
    + UPDATE
    + 其他 MySQL 语句不支持触发器

## 创建触发器

+ 创建，需要给出 4 条信息

    + 唯一的触发器名
    + 触发器关联的表
    + 触发器应该响应的活动（DELETE,INSERT或UPDATE）
    + 触发器何时执行（处理之前或之后）

+ 在 MySQL 5 中，触发器名必须在每个表中唯一，但不是在每个数据库中唯一。这在其他每个数据库触发器名必须唯一的 DBMS 中是不允许的，以后 MySQL 可能会使命名规则更为严格。因此，现在最好是在数据库范围内使用唯一的触发器名。

```SQL
CREATE TRIGGER newproduct AFTER INSERT ON products
FOR EACH ROW SELECT 'Product added';
// 使用 INSERT 语句添加一行或多行到 products 中，你将看到对每个成功的插入，显示 Product added 消息。
```

+ 只有表才支持触发器，视图不支持，临时表也不支持。
+ 触发器按每个表每个事件每次地定义，每个表每个事件每次只允许一个触发器。因此每个表最多支持 6 个触发器（每个 INSERT，UPDATE 和 DELETE 之前和之后）
+ 单一触发器不能与多个事件或多个表关联。
+ 如果 BEFORE 触发器失败，则 MySQL 将不执行请求的操作。此外，如果 BEFORE 触发器或语句本身失败，MySQL 将不执行 AFTER 触发器（如果有的话）

## 删除触发器

 ```SQL
 DROP TRIGGER newproduct;
 // 触发器不能更新或覆盖。为了修改一个触发器，必须先删除它，然后再重新创建。
 ```

## 使用触发器

### INSERT 触发器

+ 在 INSERT 触发器代码内，可引用一个名为 NEW 的虚拟表，访问被插入的行。
+ 在 BEFORE INSERT 触发器中，NEW 中的值也可以被更新（允许更改被插入的值）
+ 对于 AUTO_INCREMENT 列，NEW 在 INSERT 执行之前包含 0 ，在 INSERT 执行之后包含新的自动生成的值。

```SQL
// 更好的新生成值的方法。
CREATE TRIGGER neworder AFTER INSERT ON orders
FOR EACH ROW SELECT NEW.order_num;
// 在插入一个新订单到 orders 表时，MySQL 生成一个新订单号并保存到 order_num 中。触发器从 NEW.order_num 取得这个值并返回它。
// 对于 orders 的每次插入使用这个触发器将总是返回新的订单号。

// 测试触发器
INSERT INTO orders(order_date, cust_id)
VALUES(Now(), 10001);
// 返回 order_num
// order_num 由 MySQL 自动生成，而现在 order_num 还自动被返回。
```

+ 通常，将 BEFORE 用于数据验证和净化（目的是保证插入表中的数据确实是需要的数据），本提示也适用于 UPDATE 触发器。

### DELETE 触发器

+ 在 DELETE 触发器代码内，你可以引用一个名为 OLD 的虚拟表，访问被删除的行。
+ OLD 中的值全都是只读的，不能更新。

```SQL
CREATE TRIGGER deleteorder BEFORE DELETE ON orders
FOR EACH ROW
BEGIN
    INSERT INTO archive_orders(order_num, orderr_date, cust_id)
    VALUES(OLD.order_num, OLD.order_date, OLD.cust_id);
END;
// BEFORE DELETE 触发器的优点（相对于 AFTER DELETE 触发器来说），如果由于某种原因，订单不能存档，DELETE 本身将被抛弃。
```

+ 触发器 deleteorder 使用 BEGIN 和 END 语句标记触发器体。这不是必需的。使用 BEGIN END 块的好处是触发器能容纳多条 SQL 语句。（在 BEGIN END 块中一条挨着一条）

### UPDATE 触发器

+ 在 UPDATE 触发器代码中，你可以引用一个名为 OLD 的虚拟表访问以前（UPDATE 语句前）的值，引用一个名为 NEW 的虚拟表访问新更新的值。
+ 在 BEFORE UPDATE 触发器中，NEW 中的值可能也被更新（允许更改将要用于 UPDATE 语句中的值）
+ OLD 中的值全都是只读的，不能更新。

```SQL
CREATE TRIGGER uppdatevendor BEFORE UPDATE ON vendors
FOR EACH ROW SET NEW.vend_state = Upper(NEW.vend_state);
```

### 关于触发器的进一步介绍

+ 使用触发器时的重点

    + 与其他 DBMS 相比，MySQL 5中支持的触发器相当初级。未来的版本有改进和增强的计划
    + 创建触发器可能需要特殊的安全访问权限，但是，触发器的执行时自动的。如果 INSERT，UPDATE 或 DELETE 语句能够执行，则相关的触发器也能执行。
    + 应该用触发器来保证数据的一致性（大小写，格式等）。在触发器中执行这种类型的处理的优点是它总是进行这种处理，而且是透明地进行，与客户机应用无关。
    + 触发器的一种非常有意义的使用是创建审计跟踪。使用触发器，把更改（如果需要，甚至还有之前和之后的状态）记录到另一个表非常容易。
    + 遗憾的是，MySQL 触发器中不支持 CALL 语句。这表示不能从触发器内调用存储过程。所需的存储过程代码需要复制到触发器内。

# 管理事务处理

## 事务处理

+ MyISAM 和 InnDB 是两种最常使用的引擎。前者不支持明确的事务处理管理，后者支持。
+ 事务处理（transactin pricessing）可以用来维护数据库的完整性，它保证成批的 MySQL 操作要么完全执行，要么完全不执行。
+ 事务处理是一种机制，用来管理必须成批的 MySQL 操作，以保证数据库不包含不完整的操作结果。利用事务处理，可以保证一组操作不会中途停止。它们或者作为整体执行，或者完全不执行（除非明确指示）。
+ 如果错误发生，则进行回退以恢复数据库到某个已知且安全的状态。


+ 术语

    + 事务（transaction）：指一组 SQL 语句。
    + 回退（rollback）：指撤销指定 SQL 语句的过程。
    + 提交（commit）：指将未存储的 SQL 语句结果写入数据库表
    + 保留点（savepoint）：指事物处理中设置的临时占位符（place-holder），你可以对它发布回退（与回退整个事务处理不同）

## 控制事务

```SQL
// 标识事务的开始
START TRANSACTION
```

### 使用 ROLLBACK

+ MySQL 的 ROLLBACK 命令用来回退（撤销）MySQL 语句

```SQL
SELECT * FROM ordertotals;
START TRANSACTION;
DELETE FROM ordertotals;
SELECT * FROM ordertotals;
ROLLBACK;
SELECT * FROM ordertotals;
```

+ ROLLBACK 只能在一个事务处理使用（在执行一条 START TRANSACTION 命令之后）
+ 事务处理用来管理 INSERT，UPDATE 和 DELETE 语句。不能回退 SELECT 语句（无意义）。不能回退 CREATE 或 DROP 操作。事务处理中可以使用这两条语句，但如果你执行回退，它们不会被撤销。

### 使用 COMMIT

+ 一般的 MySQL 语句都是直接针对数据库执行和编写的。这就是所谓的隐含提交（implicit commit），即提交（写或保存）操作是自动进行的。
+ 但在事务处理快中，提交不会隐含地进行。明确提交使用 COMMIT 语句

```SQL
START TRANSACTION;
DELETE FROM orderitems WHERE order_num = 20010;
DELETE FROM orders WHERE order_num = 20010;
COMMIT;
// COMMIT 语句仅在不出错时写出更改。如果第一条 DELETE 起作用，但第二条失败，则 DELETE 不会提交。（实际上，它是被自动撤销的）
```

+ 当 COMMIT 或 ROLLBACK 语句执行后，事务会自动关闭（将来的更改会隐含提交）

### 使用保留点

+ 简单的 ROLLBACK 和 COMMIT 语句就可以写入或撤销整个事务处理。但是，只是对简单的事务处理才能这样做，更复杂的事务处理可能需要部分提交或回退。

```SQL
// 创建占位符
SAVEPOINT delete1;
```

+ 每个保留点都取标识它的唯一名字，以便在回退时，MySQL 知道要回退到何处。为了回退到本例给出的保留点。

```SQL
ROLLBACK TO delete1;
```

+ 可以在 MySQl 代码中设置任意多的保留点，越多越好，因为保留点越多，你就能按照自己的意愿灵活地进行回退。
+ 保留点在事务处理完成（执行一条 ROLLBACK 或 COMMIT）后自动释放。自 MySQL 5 以来，也可以用 RELEASE SAVEPOINT 明确地释放保留点。

### 更改默认的提交行为

```SQL
// 默认的 MySQL 行为是自动提交所有更改。为指示 MySQl 不自动提交更改，需要使用以下语句：
SET autocommit=0;
```

+ autocommit标志决定是否自动提交更改，不管有没有 COMMIT 语句。设置  autocommit 为 0（假）指示 MySQL 不自动提交更改（知道 autocommit被设置为真为止）
+ autocommit 标志是针对每个联结而不是服务器的。

# 全球化和本地化

## 字符集和校对顺序

+ 数据库被用来存储和检索数据。不同的语言和字符集需要以不同的方式存储和检索。
+ 术语

    + 字符集 为字母和符号的集合
    + 编码 为某个字符集成员的内部表示
    + 校对 为规定字符如何比较的指令

+ 使用何种字符集和校对的决定在服务器，数据库和表级进行。

## 使用字符集和校对顺序

```SQL
SHOW CHARACTER SET;
// 显示所有可用的字符集以及每个字符集的描述和默认校对

SHOW COLLATION;
// 显示所有可用校对，以及它们适合的字符集。
// 区分大小写（由 _cs 表示）一次不区分大小写（由 _ci 表示）

// 通常系统管理在安装时定义一个默认的字符集和校对。也可以在数据库时，创建默认的字符集和校对
// 确定所用的字符集和校对
SHOW VARIABLES LIKE 'character%';
SHOW VARIABLES LIKE 'collation%';
```

+ 字符集很少是服务器范围（甚至数据库范围）的设置。不同的表，甚至不同的列都可能需要不同的字符集，而且两者都可以在创建表时指定。

```SQL
CREATE TABLE mytable
(
    columnn1 INT,
    columnn2 VARCHAR(10)
) DEFAULT CHARACTER SET hebrew
  COLLATE hebrew_general_ci;
  
// MySQL 还允许对每个列设置它们
CREATE TABLE mytable
(
    columnn1 INT,
    columnn2 VARCHAR(10),
    column3  VARCHAR(10) CHARACTER SET latin1 COLLATE latin1_general_ci
) DEFAULT CHARACTER SET hebrew
  COLLATE hebrew_generral_ci;
// 对整个表和特定的列指定了 CHARACTER SET 和 COLLATE

// 如果创建表时不同的校对顺序排序特定的 SELECT 语句，可以在 SELECT 语句自身中进行
SELECT * FROM customers
ORDER BY lastname, firstname COLLATE latin1_general_cs;
// 使用 COLLATE 指定一个备用的校对顺序（为区分大小写的校对）
```

+ COLLATE 还可以用于 GROUP BY ，HAVING ，聚集函数，别名
+ 如果绝对需要，串可以在字符集之间进行转换。为此使用 Cast() 或 Convert()函数

# 安全管理

## 访问控制

+ MySQL 服务器的安全基础时：用户应该对他们需要的数据具有适当的访问权，即不能多也不能少。换句话说，用户不能对过多的数据具有过多的访问权。

+ 在现实的工作中，绝不能使用 root。应该创建一系列的账号，有的用于管理，有的用于供用户使用，有的供开发人员使用。

## 管理用户

+ MySQL 用户账户和信息存储在名为 mysql 的 MySQL 数据库中。一般不需哟啊直接访问 mysql 数据库和表，但有时需要直接访问。

```SQL
USER mysql;
SELECT user FROM user;
// user 表，user 列，存储用户登录名。
```

### 创建用户账号

```SQL
CREATE USER ben IDENTIFIED BY 'p@$$w0rd';
// 创建用户账号不一定需要口令
// IDENTIFIED BY 指定的口令为纯文本，MySQL 将在保存到 user 表之前对其进行加密。
```

+ 也可以通过直接插入行到 user 表来增加用户，不过为安全起见，一般不建议这样做。因此，相对于直接处理来说，最好是用标记和函数来处理这些表。

+ 重命名一个用户账号

```SQL
RENAME USER ben TO bforta;
// 仅 MySQL 5或之后的版本支持 RENAME USER。
// 之前的 MySQL ，使用 UPDATE 直接更新 user 表
```

### 删除用户账号

+ 删除一个用户账号（以及相关的权限）

```SQL
DROP USER bforta;
// MySQL 5 以来，DROP USER 删除用户的账号和所有相关的账号权限。
// 5 之前，只能删除用户账号，不能删除相关的权限。所以需要先使用 REVOKE 删除与账号相关的权限，然后再用 DROP USER 删除账号
```

### 设置访问权限

+ 在创建用户账号，必须接着分配访问权限。新创建的用户账号没有访问权限 。它们能登录 MySQL ，但不能看到数据，不能执行任何数据库操作。

```SQL
// 看到赋予用户账号的权限
SHOW GRANTS FOR bforta;
// 显示为用户 bforta 有一个权限 `USAGE ON *.*` USAGE 表示根本没有权限。
```

+ MySQl 的权限用用户名和主机名结合定义( user@host )。如果不指定主机名，则使用默认的主机名%
+ 设置权限，使用 GRANT 语句

    + 要授予的权限
    + 被授予访问权限的数据库或表
    + 用户名

```SQL
GRANT SELECT ON crashcourse.* TO bforta;
// 允许用户在 crashcourse 数据库的所有表上使用 SELECT。

// 撤销特定的权限
REVOKE SELECT ON crashcourse.* FROM bforta;
```

+ GRANT 和 REVOKE 可在几个层次上控制访问权限

    + 整个服务器，使用 GRANT ALL 和 REVOKE ALL
    + 整个数据库，使用 ON database.*
    + 特定的表，使用 ON databse.table
    + 特定的列
    + 特定的存储过程

+ 权限

```SQL
ALL     //
ALTER
ALTER ROUTINE
CREATE
CREATE ROUTINE
CREATE TEMPORARY TABLES
CREATE USER
CREATE VIEW
DELETE
DROP
EXECUTE     // 使用 CALL 和 存储过程
FILE
GRANT OPTION
INDEX
INSERT
LOCK TABLES
PROCESS
RELOAD
REPLICATION CLIENT // 服务器位置的访问
REPLICATION SLAVE // 由复制从属使用
SELECT
SHOW DATABASES
SHOW VIEW
SHUTDOWN
SUPER
UPDATE
USAGE // 无访问权限
```

+ 简化多次授权。

```SQL
GRANT SELECT, INERT ON crashcourse.* TO bforta;
```

### 更改口令

 ```SQL
 SET PASSWORD FOR beforta = Password('n3w p@$$w0rd');
 // SET PASSWORD 更新用户口令。新口令必须传递到 Password()函数进行加密。
 
 // 设置自己的口令，不指定用户名，更新当前登录的用户的口令
 SET PASSWORD = PASSword('n2w p@$$w0rd');
 ```

# 数据库维护

## 备份数据

+ 解决方案

    + 使用命令行实用程序 mysqldump 转储所有数据库内容到某个外部文件。
    + 可用命令行实用程序 mysqlhotcopy 从一个数据库复制所有数据（并非所有数据库引擎都支持这个实用程序）
    + 可用使用 MySQL 的 BACKUP TABLE 或 SELECT INTO OUTFILE 转储所有数据到某个外部文件。数据可以用 RESTONE TABLE 来复原

+ 为了保证所有数据被写到磁盘（包括索引数据），可能需要在进行备份前使用 FLUSH TABLES 语句

## 进行数据库维护

```SQL
// ANALYZE TABLE 用来检查表键是否正确
ANALYZE TABLE orders;

// CHECK TABLE 用来针对许多问题对表进行检查。在 MyISAM 表上还对索引进行检查。发现和修复问题
CHECK TABLE orders, orderitems;

// CHANGED 检查来自最后一次检查以来改动过的表
// EXTENDED 执行最彻底的检查
// FAST 只检查为正常关闭的表
// MEDIUM 检查所有被删除的链接并进行键检验
// QUICK 只进行快速扫描
```

+ 如果 MyISAM 表访问产生不正确和不一致的结果，可能需要用 REPAIR TABLE 来修复相应的表。
+ 如果从一个表中删除大量数据，应该使用 OPTIMIZE TABLE 来收回所用的空间，从而优化性能。

## 诊断启动问题

+ 在排除系统启动问题时，首先应该尽量用手动启动服务器。
+ MySQL 服务器自身通过在命令行上执行 mysqld 启动。
+ 几个 mysqld 命令行选项

    + --help // 显示帮助
    + --safe-mode // 装载减去某些最佳配置的服务器
    + --verbose // 显示全文本信息
    + --version // 显示版本信息然后推出

## 查看日志文件

+ 错误日志。

    + 它包含启动和关闭问题以及任意关键错误的细节。
    + 此日志通常名为 hostname.err，位于 data 目录中。此日志名可用 --log-error 命令行选项更改

+ 查询日志。

    + 它记录所有 MySQL 活动，在诊断问题时非常有用。
    + 此日志文件可能会很快地变得非常大，因此不应该长期使用它。
    + 此日志通常名为 hostname.log ，位于 data 目录中。此名字可以用 --log 命令行选项更改。

+ 二进制日志。（MySQL 5 以前版本使用是更新日志）

    + 它记录更新过数据（或者可能更新过数据）的所有语句。
    + 此日志通常名为 hostname-bin，位于 data 目录内。
    + 此名字可以用 --log-bin 命令行选项更改。

+ 缓慢查询日志

    + 此日志记录执行缓慢的任何查询
    + 这个日志在确定数据库何处需要优化很有用。
    + 此日志通常名为 hostname-slow.log ，位于 data 目录中。此名字可以用 --log-slow-queries 命令行选项更改


+ 可用 FLUSH LOGS 语句来刷新和重新开始所有日志文件。

# 改善性能

+ MySQL 具有特定的硬件建议（对于生产的服务器来说）
+ 一般来说，关键的生产 DBMS 应该运行在自己的专用服务器上。
+ MySQL 是用一系列的默认设置预先配置的，从这些设置开始通常是很好的。

    + 但过一段时间后你可能需要调整内存分配，缓冲区大小等。
    + 查看当前设置，使用 SHOW VARIABLES; 和 SHOW STATUS;
+ MySQL 一个多用户多线程的 DBMS 换言之，它经常同时执行多个任务。

    + 如果这些任务中的某一个执行缓慢，则所有请求都会执行缓慢。
    + 如果你遇到显著的性能不良，可使用 SHOW PROCESSLIST 显示所有活动进程（以及它们的线程 ID 和执行时间）
    + 可以用 KILL 命令终结某个特定的进程（这个命令需要作为管理员登录）

+ 总是有不止一种方法编写同一条 SELECT 语句。应该试验联结，并，子查询等。找出最佳的方法。
+ 使用 EXPLAIN 语句让 MySQL 解释它将如何执行一条 SELECT 语句。
+ 一般来说，存储过程执行得比一条一条 地执行其中的各条 MySQL 语句快。
+ 应该总是使用正确的数据类型。
+ 决不要检索比需求还要多的数据。换言之，不要用 SELECT * (除非你真正需要每个列)
+ 有的操作（包括 INSERT ）支持一个可选的 DELAYED 关键字，如果使用它，将把控制立即返回给调用程序，并且一旦有可能就实际执行该操作。
+ 在导入数据时，应该关闭自动提交。你可能还想删除索引（包括 FULLTEXT 索引），然后在导入完成后再重建它们。

+ 必须索引数据库以改善数据检索的性能。

    + 确定索引什么不适一件微不足道的任务，需要分析使用的 SELECT 语句以找出重复的 WHERE 和 ORDER BY 子句。
    + 如果一个简单的 WHERE 子句返回结果所花的时间太长，则可以断定其中使用的列（或几个列）就是需要索引的对象。

+ 你的 SELECT 语句中有一系列复杂的 OR 条件吗？通过使用多条 SELECT 语句和连接它们的 UNION 语句，你能看到极大的性能改进。
+ 索引改善数据检索的性能，但损害数据插入，删除和更新的性能。

    + 如果你有一些表，它们收集数据且不经常被搜索，则在有必要之前不要索引它们。（索引可根据需要添加和删除）

+ LIKE 很慢。一般来说，最好是使用 FULLTEXT 而不是 LIKE
+ 数据库是不断变化的实体。一组优化良好的表一会儿可能就面目全非了。由于表的使用和内容的更改，理想的优化和配置也会改变。
+ 最重要的规则就是，每条规则在某些条件下都会被打破。

+ [MySQl 文档](http://dev.mysql.com/doc/) 有许多提示和技巧。

# 附录A MySQL 入门

# 附录B 样例表

# 附录C MySQL 语句的语法

# 附录D MySQL 数据类型

# 附录E MySQL 保留字


