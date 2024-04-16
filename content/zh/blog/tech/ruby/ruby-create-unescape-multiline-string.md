---
title: 在 Ruby 中如何创建不转义的多行字符串
tags:
- Ruby
date: 2024-04-16T16:47:18+09:00
---

今天遇到的字符串转义问题，开始的路走错了，总想把转义后的字符串解析成不转义的字符串。理论应该也可以做到，应该要看到字符串内部任何解析的了。

## 问题

在解决 [这个问题](https://adventofcode.com/2015/day/8) 的时候，我需要计算字符串在没有转义之前的长度。

因为我要解析的文本是一个多行的字符串，所以我打算在运行时把转义后的字符串解析成非转义的字符串。

但是似乎很难做到，即使替换反斜杠 \ 到 \\ 也没有作用。想想还是要在输入的就写成不转义的字符串。

我们知道在 Ruby 中，不转义字符串使用单引号来创建。

```rb
puts '\x27'
# \x27
```

但是多行如何创建呢。

## Heredoc 多行字符串

```rb
example = <<~'END'
    ""
    "abc"
    "aaa\"aaa"
    "\x27"
END
```

通过给 Heredoc 块的标识加上单引号即可以转变为不转义的字符串。

[参考文档](https://ruby-doc.org/core-2.5.0/doc/syntax/literals_rdoc.html#label-Here+Documents)

## 文件读取

```rb
File.binread("puzzle_input.txt")
```

通过使用 IO 类的 binread 二进制读取方法来获得不转义的字符串。
