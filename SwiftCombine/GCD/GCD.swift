//
//  GCD.swift
//  SwiftCombine
//
//  Created by mac on 2023/12/25.
//

import Foundation

//Dispatch Queue
/*
 GCD让程序创建的线程进行排队，根据可用的处理资源，安排他们在任何可用的处理器核心上执行任务
 GCD中的FIFO队列称为dispatchqueue，它可以保证先进来的任务先得到执行
 :任务有两种执行方式：同步执行和异步执行。同步（sync）和异步（async）的主要区别在于会不会阻塞当前线程，直到任务执行完毕。
 :如果是同步（sync）操作，它会阻塞当前线程并等待Block中的任务执行完毕，然后当前线程才会继续往下运行
 :如果是异步（async）操作，当前线程会直接往下执行，它不会阻塞当前线程
 */

//qos:
//userlnteractive：用于处理和用户互动有关的任务，例如动画、事件处理
//userlnitiated：用于处理可能会妨碍用户使用App的任务
//default：默认的QoS
//utility：用于处理用户并不是非常关心的任务
//background：用于处理后台任务
//unspecified：未指定Qos

//Operation Queue:
//是对单个任务所相关的代码和数据的抽象表示。
//尽管它是抽 象类，但是它的默认实现包含了有关任务安全执行的重要逻辑，
//由于关 于任务被如何执行的逻辑已经被实现，所以使用者只需要关注如何来定
//制你的任务。当任务被定制之后，operation只能够执行一次

//NSInvocationOperation (OC风格)
//BlockOperation (swift) 会阻塞主线程
