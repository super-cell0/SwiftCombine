//
//  ViewControllerCombine.swift
//  SwiftCombine
//
//  Created by mac on 2023/9/8.
//

import Foundation
import Combine

/*
 publisher发出两种事件：
 1 elements
 2 completion event
 发布者可以发出零个或更多值，但只有一个完成事件，这可以是正常的完成事件，也可以是错误。一旦发布者发出完成事件，它就完成了，不能再发出任何事件
 */

extension ViewController {
    
    func exampleSubscriber() { 
        let myNotification = Notification.Name("beidixiaoxiong")
        let center = NotificationCenter.default
        let publisher = center.publisher(for: myNotification, object: nil)
        
        let subscription = publisher
            .sink { _ in
                print("从publisher那里收到的通知")
            }
        
        center.post(name: myNotification, object: nil)
        subscription.cancel()
    }
    
    
    func examplePublisher() {
        let myNotification = Notification.Name("beidixiaoxiong")
        let _ = NotificationCenter.default
            .publisher(for: myNotification, object: nil)
        
        let center = NotificationCenter.default
        
        let observer = center.addObserver(
            forName: myNotification,
            object: nil,
            queue: nil) { notification in
                print("收到通知")
            }
        
        center.post(name: myNotification, object: nil)
        
        center.removeObserver(observer)
        
    }
    
    ///sink操作员将继续收到出版商发出的尽可能多的值——这被称为无限需求。尽管您在上一个示例中忽略了它们，但sink运算符实际上提供了两个闭包：
    ///1 一个用于处理接收完成事件（成功或失败 receiveCompletion
    ///2一个用于处理接收值 receiveValue
    func exampleJust() {
        let just = Just("hello combine")
        _ = just
            .sink(receiveCompletion: {
                print("用于处理接收完成事件（成功或失败）", $0)
            }, receiveValue: {
                print("处理接收值", $0)
            })
    }
    
    ///除了sink外，内置的assign(to:on:)运算符允许您将接收值分配给对象的KVO兼容属性。
    func exampleAssign() {
        let object = SomeObject()
        
        let publisher = ["Hello", "world"].publisher
        
        _ = publisher
            .assign(to: \.value, on: object)
    }
    
    func exampleAssignTo() {
        
        let object =  SomeObject()
        
        object.$newValue
            .sink {
                print($0)
            }
            .store(in: &subscriptions)
        
        //创建一个数字发布者，并将其发出的每个值分配给object的value发布者。注意使用&来表示对属性的inout引用
        //assign(to:) 运算符不会返回AnyCancellable令牌，因为它内部管理生命周期，并在@Published属性初始化时取消订阅。
        (0..<10).publisher
            .assign(to: &object.$newValue)
    }
    
    func exampleIntSubscriber() {
        
        let publisher = (1...6).publisher
        let subscriber = IntSubscriber()
        
        publisher.subscribe(subscriber)
    }
    
    ///指定在三秒延迟后增加您传递的整数
    func futureIncrement(integer: Int, delay: TimeInterval) -> Future<Int, Never> {
        
        Future<Int, Never> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                promise(.success(integer + 1))
            }
        }
        
    }
    
    func futureDemo() {
        print("Original")
        let future = futureIncrement(integer: 1, delay: 3)
        future
            .sink { event in
                print(event)
            } receiveValue: { value in
                print("value: \(value)")
            }
            .store(in: &subscriptions)
        
        future
            .sink {
                print("second", $0)
            } receiveValue: {
                print("second",$0)
            }
            .store(in: &subscriptions)
        
    }
    
    ///PassthroughSubject 的特点是没有任何缓冲，它会立即将接收到的任何值发送给所有当前的订阅者
    func examplePassthroughSubject() {
        //        let publisher = ["A", "B", "C", "D", "E", "F"].publisher
        let subscriber = StringSubscriber()
        let subject = PassthroughSubject<String, MyError>()
        
        subject.subscribe(subscriber)
        
        let subscription = subject
            .sink { completion in
                print("Received completion (sink)", completion)
            } receiveValue: { value in
                print("Received value (sink) ", value)
            }
        
        
        subject.send("hello")
        subject.send("word")
        
        subscription.cancel()
        subject.send("Still there?")
        
        subject.send(completion: .failure(.tese))
        
        subject.send(completion: .finished)
        subject.send("how about another one")
        
    }
    
    ///CurrentValueSubject 的特点是它会保留最新的值，并将其发送给新的订阅者
    func exampleCurrentValueSubject() {
        let subject = CurrentValueSubject<Int, Never>(0)
        
        subject
            .sink { value in
                print(value)
            }
            .store(in: &subscriptions)
        
        subject.send(1)
        subject.send(2)
        
        print(subject.value)
        
        subject.value = 3
        print(subject.value)
        
        subject
            .sink(receiveValue: { print("Second subscription:", $0) })
            .store(in: &subscriptions)
        
        subject.send(completion: .finished)
        
        
    }
    
    func intPassthroughSubject() {
        let subscriber = IntSubscriber()
        let subject = PassthroughSubject<Int, Never>()
        
        subject.subscribe(subscriber)
        
        subject.send(1)
        subject.send(2)
        subject.send(3)
        subject.send(4)
        subject.send(5)
        subject.send(6)
        
    }
    
    func typeErasure() {
        let subject = PassthroughSubject<Int, Never>()
        //将subject转换为AnyPublisher类型
        let publisher = subject.eraseToAnyPublisher()
        
        publisher
            .sink(receiveValue: { print($0)})
            .store(in: &subscriptions)
        
        subject.send(0)
        
    }
    
    func demoAsync() {
        let subject = CurrentValueSubject<Int, Never>(0)

        // 2
        Task {
          for await element in subject.values {
            print("Element: \(element)")
          }
          print("Completed.")
        }

        // 3
        subject.send(1)
        subject.send(2)
        subject.send(3)

        subject.send(completion: .finished)

    }
    
    func demoAsync01() {
        let subject = CurrentValueSubject<Int, Never>(0)
        
//        await Task.sleep(1)
//        for await element in subject.values {
//            print("element: \(element)")
//        }
        subject
            .sink(receiveValue: { print($0)})
            .store(in: &subscriptions)
        
        print("completion.")
        
        subject.send(1)
        subject.send(2)
        subject.send(3)
        
        subject.send(completion: .finished)
        
        // 等待任务完成
    }
    
    //challenge
    func dealBlackjack() {
//        let dealtHand = PassthroughSubject<Hand, HandError>()
//        
//        var deck = cards
    }

    
    
}

