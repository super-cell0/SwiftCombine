//
//  ViewControllerCombine.swift
//  SwiftCombine
//
//  Created by mac on 2023/9/8.
//

import Foundation
import Combine

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
    
    func exampleJust() {
        let just = Just("hello combine")
        _ = just
            .sink(receiveCompletion: {
                print("用于处理接收完成事件（成功或失败）", $0)
            }, receiveValue: {
                print("处理接收值", $0)
            })
    }
    
    func exampleAssign() {
        let object = SomeObject()
        
        let publisher = ["a", "b"].publisher
        
        _ = publisher
            .assign(to: \.value, on: object)
    }
    
    func exampleAssignTo() {
        let objcet =  SomeObject()
        objcet.$newValue
            .sink {
                print($0)
            }
        //创建一个数字发布者，并将其发出的每个值分配给object的value发布者。注意使用&来表示对属性的inout引用
        (0..<10).publisher
            .assign(to: &objcet.$newValue)
    }
    
    
    
}

class SomeObject {
    
    var value: String = "" {
        didSet {
            print(value)
        }
    }
    
    @Published var newValue = 0
    
    
}
