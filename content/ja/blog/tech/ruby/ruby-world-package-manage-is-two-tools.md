---
title: Rubyの世界でパッケージ管理は二つツールになる原因
tags:
- Ruby
date: 2024-07-31T23:57:09+09:00
---

パッケージ管理について、Node.jsとかGolangとか、Rustとか、一つツールで管理できる。

でもRubyはパッケージのインストール（gem）とパッケージの依存関係管理（bundle）、二つツールになりました。

初めてRubyを学びのとき、疑問がありました、どしてRubyは二つツールでパッケージ管理するか、一ついいじゃないか。

それで、最近もっと気になりました、調べました、ようやくわかりました。簡単に言うと、歴史の原因です、Rubyも古い言語になりました、Javaと同じ時代だ。

## 原因

２００３年RubyGemsは一つパッケージのインストール上手くできるために作られました。プロジェクトのパッケージの依存関係管理の要望がないでした。

その後、gemを使いどんどん増えると、gemバージョンコンフリクト(version conflict)の問題が厳しになりました。

２００９年Bundlerはパッケージの依存関係管理のために作られました。

その原因で、Rubyはパッケージ管理で二つツールになりました。

## 現状

今は、RubyGemsとBundlerは同じ[プロジェクト](https://github.com/rubygems/rubygems)にマージになりましたけど、まだ別々のコマンドの状態です。

## 参考

[ RubyConf 2015 - How does Bundler work, anyway? by Andre Arko ](https://www.youtube.com/watch?v=4DqzaqeeMgY)
