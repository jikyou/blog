---
title: 区块链的无需许可 Permissionless 和终局性 Finality
tags:
- Blockchain
date: 2022-12-25 22:46:43 +0900
---

很久没关注区块链了，最近听了两期播客，学到了两个词无需许可和终局性，对区块链的理解也更加深刻了。

<!--more-->

## 无需许可 Permissionless

无需许可的意思是参与区块链出块是否需要别人许可。

在 POW 中只要你购买矿机和电力就可以参与共识。而在 POS 中参与共识是需要发起交易的，而现有的节点有作恶的可能性不广播你的交易，让你无法参与共识。

POW 比 POS 更加具有无需许可，更加去中心化，也更具抗审查能力。

但是 POS 也更加符合监管的需要，也许 CKB 在 Layer1 坚持 POW，在 Layer2 去选择 POS 是更好的一条路，兼顾了无需许可的参与性和监管的需要，让区块链真的变成基础设施。

## 终局性 Finality

终局性的意思是我的这笔交易是不是真的被确认了，不会被 Revert 了。

POW 没有终局性，因为在理论上只要有足够的算力是可以从自己认可的区块高度开始重新出块，而达到最长链，导致其他人的出的块被丢弃，但是这是理论上。所以我们会说超过 6 个区块后，可以认为 99.99% 不会被 Revert 了。

终局性是很多强一致性的应用需求，比如金融类的应用。

## References

[PoW vs. PoS](https://talk.nervos.org/t/pow-vs-pos/1732)

[文字稿｜Fork It #22: PoW vs. PoS](https://talk.nervos.org/t/fork-it-22-pow-vs-pos/6731)

[文字稿｜Fork It #23：PoS 是谎言么？](https://talk.nervos.org/t/fork-it-23-pos/6751)
