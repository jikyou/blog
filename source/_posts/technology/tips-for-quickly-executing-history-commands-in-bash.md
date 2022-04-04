---
title: 在 Bash 中快速执行历史命令的小技巧
tags: CommandLine
date: 2022-04-04 16:58:00 +0800
---

<link rel="stylesheet" type="text/css" href="/assets/css/asciinema-player.css" />
<script src="/assets/js/asciinema-player.min.js"></script>

在 Bash 可以通过 `Ctrl + R` 快速搜索已经执行过的历史命令，然后回车就可以快速执行命令了。

<!--more-->

## reverse-search-history

19 年的时候，我购买了 [Linuxtoy](https://twitter.com/linuxtoy) 出的一个关于命令行的使用指南[「像黑客一样使用命令行」](https://selfhostedserver.com/usingcli-book)。从中学到了一个小技巧就一直使用到了现在。

这个小技巧就是在 Shell 中通过 `Ctrl + R` 快速搜索已经执行过的历史命令，然后回车就可以快速执行命令了。

`Ctrl + R` 这个操作叫 [reverse-search-history](https://www.gnu.org/software/bash/manual/html_node/Commands-For-History.html)，可以追溯的文档是在 关于 Bash 的手册 [manual](https://www.gnu.org/software/bash/manual/html_node/Bash-History-Facilities.html) 。

目前 Bash 和 Zsh 都支持这个操作，但是 [Fish Shell](https://fishshell.com/) 不支持这个特性，参考 [Issues](https://github.com/fish-shell/fish-shell/issues/602) ，所以那时候我又用会 Zsh 了。

下面我使用 Zsh 来记录下效果。

<div id="reverse-search-history-cast"></div>
<script>
  AsciinemaPlayer.create('/assets/asciinema/reverse-search-history.cast', document.getElementById('reverse-search-history-cast'));
</script>

## fzf - fuzzy finder

`Ctrl + R` 快捷键搜索的好处是 Bash 自带的，适合在服务器上使用，不许安装如何插件，缺点是但是对搜索不够友好，不能够模糊搜索。

而 [fzf](https://github.com/junegunn/fzf) 可以做到模糊搜索，适合在本地开发机使用。安装和使用可以参考 Github 的文档。

下面我使用 Zsh 来记录下效果。

<div id="fzf-cast"></div>
<script>
  AsciinemaPlayer.create('/assets/asciinema/fzf.cast', document.getElementById('fzf-cast'));
</script>

## Reference

[Bash – Using History Efficiently](https://www.baeldung.com/linux/bash-using-history-efficiently)
