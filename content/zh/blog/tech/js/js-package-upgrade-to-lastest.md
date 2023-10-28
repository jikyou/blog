---
title: 如何快速升级 JavaScript 项目中的所有依赖到最新版本
tags:
- JavaScript
date: 2023-03-17T20:57:43+09:00
---

有些场景下我们会需要升级项目的所有依赖到最新版本，比如开发新项目、例行升级。

## npm 自带的命令

默认 npm 自带的 `update` 命令会按照 [semver](https://semver.org/) 配置来升级版本，但是不可以直接升级到最新版本。

```sh
npm update --save
```

`outdated` 命令可以输出最新版本，但是不能升级。

```sh
npm outdated
```

## [npm-check-updates](https://www.npmjs.com/package/npm-check-updates)

市面上现成的包比较多，我们选择使用量比较高的 `npm-check-updates`。

```sh
npm install -g npm-check-updates

# 更新所有依赖包到最新版
ncu -u

# 更新生产包
ncu -u --dep=prod

# 更新开发包
ncu -u --dep=dev
```
