---
title: 在 Bash 中快速执行历史命令的小技巧
tags:
- CommandLine
date: 2022-04-04T16:58:00+08:00
---

最简单的方式是使用 `Ctrl + r` 快速搜索已经执行过的历史命令，然后回车就可以快速执行命令了。

<!--more-->

## reverse-search-history

19 年的时候，我购买了 [Linuxtoy](https://twitter.com/linuxtoy) 出的一个关于命令行的使用指南[「像黑客一样使用命令行」](https://selfhostedserver.com/usingcli-book)。从中学到了一个小技巧就一直使用到了现在。

这个小技巧就是 reverse-search-history 。通过在 Bash 中 `Ctrl + r` 快速搜索已经执行过的历史命令，然后回车就可以达到快速执行命令了。

[reverse-search-history](https://www.gnu.org/software/bash/manual/html_node/Commands-For-History.html)，可以追溯的文档是在 关于 Bash 的手册 [manual](https://www.gnu.org/software/bash/manual/html_node/Bash-History-Facilities.html) 。

目前 Bash 和 Zsh 都支持这个操作，但是 [Fish Shell](https://fishshell.com/) 不支持这个特性，参考 [Issues](https://github.com/fish-shell/fish-shell/issues/602) ，所以那时候我又用回 Zsh 了。

## fzf - fuzzy finder

`Ctrl + r` 快捷键搜索的好处是 Bash 自带的，适合在服务器上使用，不用安装任何插件，缺点是但是对搜索不够友好，不能够模糊搜索。

而 [fzf](https://github.com/junegunn/fzf) 可以做到模糊搜索，适合在本地开发机使用。安装和使用可以参考 Github 的文档。

## Auto suggestions

有些插件或者 shell 可以根据历史执行过的命令，自动建议命令，触发条件是需要先在命令行输入需要执行命令。插件会根据前缀匹配出最近的一条历史命令，通过 `Ctrl + e` 加回车执行命令。当然缺点也是只能根据输入的前缀来匹配命令，和之前的方案相比各有用途。

1. zsh 插件 [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) 。
2. fish shell 自带 Autosuggestions。

## Reference

[Bash – Using History Efficiently](https://www.baeldung.com/linux/bash-using-history-efficiently)
