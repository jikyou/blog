---
title: adoptopenjdk is damaged
tags:
- Java
date: 2020-06-07 10:19:00 +0800
---

macOS Gatekeeper cause "is damaged and can’t be opened" error.

<!--more-->

## Problem

In macOS run java command.

```sh
“adoptopenjdk-14.0.1.jdk” is damaged and can’t be opened.
```

## Solution

Close macOS Gatekeeper.

```sh
brew cask reinstall --no-quarantine adoptopenjdk
```
