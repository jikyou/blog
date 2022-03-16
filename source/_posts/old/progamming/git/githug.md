---
title: Githug
date: 2016-09-5 0:23:00
tags: Git
---

# Git的一个小游戏。

参考：[闯过这 54 关，点亮你的 Git 技能树中国软件匠艺小组](https://codingstyle.cn/topics/181)

+ play - 默认命令，检查是否过关
+ hint - 显示过关提示
+ reset - 重启本关，或者重启到指定的某关
+ levels - 显示关卡列表 `1
+ git - 初始化git仓库

## 第一关

```git
git init 
```

## 第二关

```git
git config --global user.name  "czqlan"
git config --global user.email "ziqiang.chen@outlook.com"
```

## 第三关

```git
git add README
```

## 第四关

```git
git commit -m "AddREADME"
```

## 第五关

```git
git clone https://github.com/Gazler/cloneme
```

## 第六关

```git
git clone https://github.com/Gazler/cloneme my_cloned_repo
```

## 第七关

```git
vim .gitignore
//*.swp
```

## 第八关

```
//.gitignore
*.a
!lib.a
```

## 第九关

```git
git status
//很常用建议取别名gst
```

## 第十关

```git
git status
```

+ untracked - 新增的文件，Git 根本不知道它的存在
+ not staged - 被索引过又被修改了的文件
+ staged - 通过 git add 后被即将被提交的文件

## 第十一关

```git
gst
git rm deleteme.rb
```

## 第十二关

```git
gst
git rm deleteme.rb --cached
//有时候执行 add 操作的时候不小心把多余的文件 add 进去了，这时我们需要把它从 staging area 移除出来，但不能删除文件。
```

## 第十三关

```git
git stash
//它就把当前未提交的改动「复制」到另一个地方暂存起来，待要恢复的时候执行 git stash pop 即可。
```

## 第十四关

```git
git mv oldfile.txt newfile.txt
//rename
```

## 第十五关

```git
mkdir src
git mv *.html src/
```

## 第十六关

```git
git log
//git lg
```

## 第十七关

```git
git tag new_tag
```

## 第十八关

```git
git push --tags
//git push 命令默认是不会 push Tags 的，需要加参数。
```

## 第十九关

```git
git add forgotten_file.rb
git comment --amend
//有时候提交之后发现漏掉了某些文件，怎么办？
往往很多人就会选择再单独提交一次，这样做其实是不合理的，之前的 commit 就不完整了，有可能上了 CI 就会挂掉。
好的做法是 amend
```

## 第二十关

```git
git commit -m "I work so hard" --date "2016-09-05 23:59:59"
//覆盖提交日期。
```

## 第二十一关

```git
git reset to_commit_second.rb
//git reset 可以用来改变 HEAD 的位置或把文件从 staging area 移除出来，但并不会丢失任何的修改
```

## 第二十二关

```git
git reset HEAD~1 --soft
//提交太快，多提交了一个文件怎么办？
git reset 可以帮我们把当前的 HEAD 重置到指定的位置，这里是倒数第二个，所以是：HEAD~1。
但我们希望变更还保持在 staging area，不然还得 add 一次挺麻烦，那可以加上 --soft 参数。
```

+ rm 是删除一个文件，reset 是从 commit 中移出或 staging area 中移出。

## 第二十三关

```git
git checkout config.rb
//有时候改了一些代码，结果发现这个需求取消了，快速扔掉所有的变更.
```

## 第二十四关

```git
git remote
//验证remote
//需要把 Git 仓库 push 到远端仓库上去，远端仓库对应就是 remote。
```

## 第二十五关

```git
git remote -v
//远程库的url
```
## 第二十六关

```git
git pull origin master
//别人提交了代码，我们就要拉到本地来。
```

## 第二十七关

```git
git remote add origin https://github.com/githug/githug
```

## 第二十八关

```git
git rebase
git push
```

## 第二十九关

```git
git diff
```

## 第三十关

```git
git blame config.rb
//居然有人把明文密码写到了代码里，快速找到某行代码最后的修改者
```

## 第三十一关

```git
git branch test_code
//当准备做的事情有可能会破坏其它东西时，为了不影响其他同事的开发工作，我们通常会拉一个分支出来，在分支上去做修改。
```

## 第三十二关

```git
git checkout -b my_branch
//创建并 checkout 到新的分支。
//如果使用 oh-my-zsh 的 git 插件的话，可以用 gbc，意思是：git branch create。
```

## 第三十三关

```git
git co v1.2
//版本 1.2 存在 bug，这里我们需要切换到 1.2 的代码以定位问题。Checkout tag 和分支没有什么区别。
```

## 第三十四关

```git
git co tags/v1.2
//但当存在同名的 tag 和分支时，git 不知道我们究竟是要 checkout 到 tag 还是到分支，它认为分支的优先级更高。
这时就要显式地告诉 git 我们是要切换到 tag。
```

## 第三十五关

```git
git branch test_branch HEAD~1
//有时忘记开新的分支，就修改并提交了代码。开分支的时候默认是基于最新的一次提交的，但我们也可以指定参数使其基于任一次提交。
```

## 第三十六关

```git
git branch -d delete_me
//有时忘记开新的分支，就修改并提交了代码。开分支的时候默认是基于最新的一次提交的，但我们也可以指定参数使其基于任一次提交。
```

## 第三十七关

```git
git push origin test_branch
//有时候在特性分支上提交了代码，但还不能并入主干，却又希望和别的同事分享（比如需要他们帮做 Code Review），那就需要把分支 push 到远程仓库中去。
```

## 第三十八关

```git
git merge feature
//将另一个分支并入当前工作分支。
```

## 第三十九关

```git
git fetch origin
//当远程仓库有更新，但我们并不想合并到本地仓库，只想把代码拿下来看看，我们会用到 fetch 命令。
```

## 第四十关

```git
git rebase mater feature
```

## 第四十一关

```git
git repack -d
//项目时间长了，git 仓库会慢慢变大，如何优化~
```

## 第四十二关

```git
git branch
git log new-feature -p README.md
git cherry-pick ca32a6dac7b6f97975edbe19a4296c2ee7682f68
//有一次，我正在一个特性分支上开发一个功能，提交了几次代码，就在准备结束合并代码的时候，然后产品经理说这个需求不用做了。
我强压下心里奔腾的一万只草泥马，准备删除这个分支，但在删除之前想到有一个 commit 是对一个工具类的修改，还是有用的。
这是我就需要从特性分支上把这个 commit 摘出来，合到 master 分支上，再删除特性分支。
这个题目就是类似的场景，先来看看特性分支叫什么，然后找到需要「摘」出来的那个 commit：
```

## 第四十三关

```git
git grep "TODO"
//我们在开发的过程中，为了不影响当前正在做的事情，会把一些不那么紧急的任务使用 TODO 注释在代码里，现代的 IDE 都能帮我们识别这些注释并在一个单独的窗口中罗列出来。
当然，不借助 IDE，光凭系统命令或 git 命令也是可以做到的。
```

## 第四十四关

```git
git log --oneline
git rebase -i HEAD~2
//在打开的 Vim 窗口中将第一行的 pick 改为 r，表示：使用 commit，并且修改 commit message。
```

## 第四十五关

```git
git log --oneline
git rebase -i HEAD~4
//当我使用 TDD 方式进行开发，会进行非常频繁小步的提交，这样在其他同事看来就缺乏完整性，也会增加后续维护成本。
所以 git 让我可以在 push 到远程仓库之前，对 commit 历史进行修改合并，把多个 commit 合并成一个。
//第一个 commit 为 pick，后三个改为 s，意思是使用这个 commit，但将它合并到前一个 commit 中去。
保存退出，会提示我们编辑 commit message，再次保存退出后，查看一下提交记录
```

## 第四十六关

```git
git log --oneline
git log long-feature-branch --oneline
git merge long-feature-branch --squash
git commit -m 'merge long-feature-branch --squash'
git log --oneline
//只用一个 commit，包含了 long-feature-branch 所有的修改
```

## 第四十七关

```git
git log --oneline
git rebase -i HEAD~2
//执行 git rebase -i HEAD~2，将两行 pick xxx 代码交换位置即可。
//ddp:交换上下行
```

## 第四十八关

```git
git log --oneline
git bisect start HEAD f608824 --
git bisect run make test
//我们知道 HEAD 的代码是有问题的，而第一个 commit 的代码是没问题的。
通过 git log 获得第一个 commit 的 Hash，就可以执行 bisect 命令
```

## 第四十九关

```git
//有时开发了一个特性没提交，接着又开发了另一个特性。
作为一个自律的程序员，应该是要分两次提交的，如果修改的是不同的文件，那可以轻松地通过 add 不同的文件进行两次提交。
但这次好巧不巧的是居然修改了同一个文件
//原来 git add 的最小粒度不是「文件」，而是 hunk（代码块）。
git add feature.rb -p
//Git 会让我们有机会选择对每一个 hunk 做什么样的操作。这里修改同一个位置，在一个 hunk 里，根据提示我们还要输入 e 手工编辑 hunk。
//将第 5 行删除，保存退出
git diff --cached
git diff
```

## 第五十关

```git
//正在特性分支上开发一个功能，被头儿叫去修了一个紧急的 bug，修完后发现：妈蛋，那个特性分支叫啥？忘记了！
当然，作为一个自律的程序员，一般是不是出现这样的场景的。
这种情况说明分支命名太没有规律，或者分支太多，不然可以通过 git branch 看一下，也能很快找到特性分支。
git reflog
git checkout solve_world_hunger
```

## 第五十一关

```git
//有时代码 push 到远程仓库后发现某一块代码有问题，我们可以通过 revert 命令将特定 commit 完全恢复。
首先我们要找到需要 revert 的 commit 的 hash
git log --oneline
git revert 377f1fe
```

## 第五十二关

```git
//刚刚把最新的一次提交给毫无保留的扔掉，马上就改了主意，怎么办？世界上有后悔药吗？
git reflog
git cherry-pick 2f1f300
```

## 第五十三关

```git
//冲突合并是使用版本控制非常常见的
git merge mybranch
vim poem.txt
//编辑冲突的文件 poem.txt，删除 Git 添加的标识冲突的行。
git add poem.txt
git ci
```

## 第五十四关

```git
//submodule 是 Git 组织大型项目的一种方式，通常可把第三方依赖作为 submodule 包含进来，这个 submodule 本身也是一个独立的 Git 项目。
git submodule add https://github.com/jackmaney/githug-include-me
```

## 第五十五关

```git
开源精神
```

