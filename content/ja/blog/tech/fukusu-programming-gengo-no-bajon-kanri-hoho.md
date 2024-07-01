---
title: 複数プログラミング言語のバージョン管理方法
tags:
- programming language
date: 2024-07-01T23:04:12+09:00
---

各プログラミング言語はバージョン管理のツールがあります。例えば、Node.jsの場合は[nvm](https://github.com/nvm-sh/nvm)です、Rubyは[rvm](https://github.com/rvm/rvm)とか、[rbenv](https://github.com/rbenv/rbenv)とか、Pythonは[pyenv](https://github.com/pyenv/pyenv)とか、Javaは[jenv](https://github.com/jenv/jenv)とかです。

違い言語のバージョン管理で違いツールを使います、それで、ツールの使い方はそれぞれ違います、覚えることも面倒臭いです、もし一つツールで、複数言語のバージョンを管理できる、それで良いな。

色々探して、ある日ようやくこのようなツール見つけました、これはasdfです。

## [asdf](https://asdf-vm.com/)

このasdf使って、複数言語のバージョンを管理できる。使い方紹介します。

### １、まずはasdf[インストールして](https://asdf-vm.com/guide/getting-started.html)。

```sh
# MacOSならHomebrewからインストールできる。
brew install asdf
```

**asdfの家のパースはShellに追加すること忘れないで**

> 僕はzshとoh-my-zshを使いました、oh-my-zshのプラグインasdfを追加して、利用できます。

### ２、次は管理したい言語のプラグインを探して。

```sh
asdf plugin list all
# 多いプラグインプリントしました。

# 例えば、Node.js管理する。
asdf plugin list all | grep nodejs
```

> 一部プラグイン管理[リポジトリ](https://github.com/asdf-community/)

### ３、それで、プリントしたプラグインのリンクを追加して。

```sh
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
```

### ４、言語のバージョンを選んって、インストールして。

```sh
# 全てバージョンプリントする
asdf list all nodejs

# 選んでバージョンインストール
asdf install nodejs 21.6.2

# 最新バージョンインストール場合
asdf install nodejs latest
```

それで、使いことができます。

```sh
➜  ~ node -v
v21.6.2
➜  ~ which node
/Users/lanlyhs/.asdf/shims/node
➜  ~
```

## 特定リポジトリの特定バージョンを指定する

`asdf local nodejs latest`で.tool-versionsのファイルを生成しました、この中で、このリポジトリに対して特定言語の特定バージョン自動的に変後できる。

この[リンク](https://asdf-vm.com/guide/getting-started.html#local)参考してください。

## まとめ

asdfを使って、色々な言語バージョン管理ことができます。言語好きな人や複数言語を使う人はぜひ試してみてください。

最後、僕はこのasdf使って、管理した言語バージョンをプリントして、終わります。

```sh
➜  ~ asdf list
go
  1.20.4
  1.21.3
  1.22.1
 *1.22.3
java
  temurin-21.0.3+9.0.LTS
nodejs
  16.20.0
  18.16.0
  20.0.0
  21.1.0
 *21.6.2
  22.1.0
  22.3.0
python
  3.11.9
  3.12.0
 *3.12.3
ruby
  2.7.8
  3.2.2
 *3.3.0
rust
  1.73.0
 *1.78.0
```
