---
title: 使用 chezmoi 来做 dotfiles 管理
tags: 
- dotfiles
date: 2023-03-18 17:45:00 +0900
---

管理 dotfiles 是个比较麻烦的事情，特别是在多系统下，现在还有在容器中（ devcontainer ，GitHub Codespaces ）开发，如何快速一键的配置自己的环境。之前使用过好几个工具 homeshick mackup 等等，去年开始也把包管理工具切换到 Nix 上，不过 Nix 在 MacOS 的体验有些差，MacOS 上还是好好用 Brew 吧。

最近又搜索相关管理工具，看到 [chezmoi](https://www.chezmoi.io/) 这个工具，是个不错的选择，支持多系统上非常好。

我今天在 MacOS 上做了一个初始的[配置](https://github.com/jikyou/dotfiles)，也可以在 GitHub Codespaces 中使用。

Arch Linux 的 [Wiki](https://wiki.archlinux.org/title/Dotfiles#Tools) 总结了一些常用的 dotfiles 管理工具。
