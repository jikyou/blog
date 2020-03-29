---
layout: post
title: 读 Go 调度系列的笔记
tags: Notes Prorgramming Golang
date: 2020-03-18 01:31 +0800
---
## 程序性能差的原因

1. 线程处于 Waiting 状态。由于等待硬件（disk, network）操作系统（system calls）同步调用（atomic, mutexes）导致线程处于 Waiting 状态。
2. Context Switching。大量的线程处在 Runnable 状态争抢时间片导致的 Context Switching。
3. Cache-Coherency problem。由于每个核心都有 Cache Lines 的副本（3～40个时钟周期），并行运行的多个线程读写相同或相邻的 Cache Lines 数据时，会导致脏页的产生，进而导致其他线程读写时需要去主存储器访问（100〜300个时钟周期）才能获取缓存行的新副本。

## 调度名词

**P(Processor)** logical processors

**M(Machine)** OS Thread

**G(Goroutine)** application-level threads

**GRQ** Global Run Queue

**LRQ** Local Run Queue

## 允许调度器做出调度决策的事件

1. go 关键字
2. Garbage collection
3. System calls
4. Synchronization and Orchestration

## 如何调度来保证程序性能

协作式调度（Cooperating Scheduler）

### 一, 通过轮询器进行异步系统调用

1. 通过使用网络轮询器（network poller）进行网络系统调用，调度程序可以防止 Goroutine 在进行这些系统调用时阻止 M。 这有助于使 M 保持可用以执行 P 的 LRQ 中的其他 Goroutine，而无需创建新的 M。这有助于减少 OS 上的调度负载。
2. 其次把该 Goroutine 移回 该 P 的 LRQ 中。

### 二, 通过分离 M 和 P 进行同步系统调用

1. 调度程序能够识别 Goroutine-1 导致 M 阻塞。 此时，调度程序将 M1 与 P 分离，而阻塞 Goroutine-1 仍然处于连接状态。 然后，调度程序引入一个新的 M2 来为 P 服务。此时，可以从 LRQ 中选择 Goroutine-2，并在 M2 上进行上下文切换。
2. Goroutine-1 完成了阻塞系统调用。此时，Goroutine-1 可以移回 LRQ 并再次由 P 提供服务。将 M1 放在一边以备将来使用。

### 三, 窃取工作（Work Stealing）

1. P1 没有更多的 Goroutines 要执行，P1 需要检查 P2 在其 LRQ 中是否有 Goroutines，并取它找到的一半。
2. P2 完成了所有工作。首先，它将查看 P1 的 LRQ，但找不到任何 Goroutine。 接下来，将查看 GRQ。

## 编写并发程序需要考虑的问题

1. 确定工作负载是否适合并发
2. 确定必须使用正确语义的工作负载类型（CPU-Bound / IO-Bound）非常重要。

## Reference

[Scheduling In Go : Part I - OS Scheduler](https://www.ardanlabs.com/blog/2018/08/scheduling-in-go-part1.html) ｜ [Archive](http://archive.vn/DcOZk)

[Scheduling In Go : Part II - Go Scheduler](https://www.ardanlabs.com/blog/2018/08/scheduling-in-go-part2.html) ｜ [Archive](http://archive.vn/EftZ1)

[Scheduling In Go : Part III - Concurrency](https://www.ardanlabs.com/blog/2018/12/scheduling-in-go-part3.html) ｜ [Archive](http://archive.vn/2P9oG)
