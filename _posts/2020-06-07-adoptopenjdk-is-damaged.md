---
layout: post
title: adoptopenjdk is damaged
tags: 
date: 2020-06-07 10:19 +0800
---
# Problem

In macOS run java command.

```
“adoptopenjdk-14.0.1.jdk” is damaged and can’t be opened.
```

# Solution

Close macOS Gatekeeper.

```
brew cask reinstall --no-quarantine adoptopenjdk
```
