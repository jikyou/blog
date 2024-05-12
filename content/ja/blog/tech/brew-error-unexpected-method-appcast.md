---
title: "Brew, Error: Unexpected method 'appcast' called on Cask"
tags:
- Brew
date: 2024-05-12T21:24:38+09:00
---

`Error: Unexpected method 'appcast' called on Cask Paste. ` 昨日Brewを使ったの時、このエラーが出ました。

調べて見るっと、エラーの原因はこのCaskのソースのURLがなくなりました、もうダウンロードできませんでした、それで、[homebrew-cask](https://github.com/Homebrew/homebrew-cask)で削除しました、それで、前のエラーが出ました。

## 解決方法

1. もしこのCaskもう使わないでした、そのままアンインストールしていい。

```sh
brew uninstall <Cask Name>
# 例
brew uninstall Paste
```

2. まだ使いたいですなら、Brewの管理でリムーブしていい。

```sh
rm -rfi $(brew --caskroom)/<Cask Name>
# 例
rm -rfi $(brew --caskroom)/Paste
```

## レファレンス

[https://github.com/Homebrew/homebrew-cask/issues/173201#issuecomment-2101662209](https://github.com/Homebrew/homebrew-cask/issues/173201#issuecomment-2101662209)

