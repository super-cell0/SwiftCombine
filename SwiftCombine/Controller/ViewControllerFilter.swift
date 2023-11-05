//
//  ViewControllerFilter.swift
//  SwiftCombine
//
//  Created by mac on 2023/10/18.
//

import Foundation
import Combine


extension ViewController {
    
    //filter，它需要一个闭包，预计将返回一个Bool。它只会传递与提供的谓词匹配的值
    func demoFilter() {
        let number = (1...10).publisher
        number
            .filter { $0.isMultiple(of: 3)}
            .sink(receiveValue: { print($0) })
            .store(in: &subscriptions)
         
    }
    
    //过滤相同的值
    func demoRemoveDuplicate() {
        let words = "hey hey there! want to listen to mister mister ?"
            .components(separatedBy: " ")
            .publisher
        
        words
            .removeDuplicates()
            .sink(receiveValue: { print($0)} )
            .store(in: &subscriptions)
    
    }
    
    //值执行一些可能返回nil的操作
    func demoCompactMap() {
        let strings = ["a", "1.24", "3", "def", "45", "0.23"].publisher
        
        //使用compactMap尝试从每个单独的字符串初始化Float。
        //如果Float的初始化器不知道如何转换提供的字符串，它返回nil。这些nil值由compactMap运算符自动过滤掉。
        strings
            .compactMap({ Float($0)} )
            .sink(receiveValue: { print($0)} )
            .store(in: &subscriptions)
    }
    
    //添加ignoreOutput操作符，省略所有值，只向消费者发送完成事件。
    func ignoreOutput() {
        let numbers = (1...10000).publisher
        numbers
            .ignoreOutput()
            .sink(receiveCompletion: { print($0) }, receiveValue: { print($0)} )
            .store(in: &subscriptions)
    }
    
    //查找和发出与提供的谓词匹配的第一个或最后一个值
    func firstWhere() {
        let number = (1...9).publisher
        number
            .print("numbers")
            .first(where: { $0 % 2 == 0} )
            .sink(receiveCompletion: { print($0) }, receiveValue: { print($0)} )
            .store(in: &subscriptions)
    }
    
    func lastWhere() {
        let number = (1...9).publisher
        number
            .print("number")
            .last(where: { $0 % 2 == 0 })
            .sink(receiveCompletion: { print($0) }, receiveValue: { print($0)} )
            .store(in: &subscriptions)
    }
    
    //手动发送
    func demoLastWhere() {
        let numbers = PassthroughSubject<Int, Never>()
        numbers
            .last(where: { $0 % 2 == 0 } )
            .sink(receiveCompletion: { print($0) }, receiveValue: { print($0)} )
            .store(in: &subscriptions)
        
        numbers.send(1)
        numbers.send(2)
        numbers.send(3)
        numbers.send(4)
        numbers.send(5)
        
        numbers.send(completion: .finished)

    }
    
    //dropFirst运算符接受count参数——如果省略，则默认为1——并忽略发布者发出的第一个count。只有在跳过count后，发布者才会开始传递值。
    func demoDropFirst() {
        let number = (1...10).publisher
        number
            .dropFirst(8)
            .sink(receiveValue: { print($0)} )
            .store(in: &subscriptions)
    }
    
    //drop(while:)
    //在闭包中返回truefilter允许值通过，而drop(while:)只要您从闭包返回true就会跳过值
    //filter从未停止评估上游出版商发布的所有值的条件。即使在filter条件评估为true后，进一步的值仍然被“质疑”，您的闭包必须回答以下问题：“您想让这个值通过吗？”。
    func demoDropWhile() {
        let number = (1...20).publisher
        number
            .drop(while: { $0 % 3 != 0})
            .sink(receiveValue: { print($0)})
            .store(in: &subscriptions)
    }
    
    func demoDropUntilOutputFrom() {
        let isReady = PassthroughSubject<Void, Never>()
        let taps = PassthroughSubject<Int, Never>()
        
        taps
            .drop(untilOutputFrom: isReady)
            .sink(receiveValue: { print($0)} )
            .store(in: &subscriptions)
        
        (1...9).forEach { a in
            taps.send(a)
            
            if a == 4 {
                isReady.send()
            }
        }
        
    }
    
    
//    限制值
    //使用prefix(2)只允许发射前两个值。一旦发出两个值，出版商就完成了
    //相当于只截取要前面的值
    func demoPrefix() {
        let numbers = (1...9).publisher
        numbers
            .prefix(2)
            .sink(receiveCompletion: { print($0)}, receiveValue: { print($0)})
            .store(in: &subscriptions)
        
    }
    
    func demoPrefixWhile() {
        let numbers = (1...9).publisher
        numbers
            .prefix(while: { $0 % 2 != 0 })
            .sink(receiveCompletion: { print($0)}, receiveValue: { print($0)})
            .store(in: &subscriptions)
    }
    
    func demoPrefixUntil() {
        let isReady = PassthroughSubject<Void, Never>()
        let taps = PassthroughSubject<Int, Never>()
        
        taps
            .prefix(untilOutputFrom: isReady)
            .sink(receiveCompletion: { print($0)}, receiveValue: { print($0)})
            .store(in: &subscriptions)
        
        (1...5).forEach { e in
            taps.send(e)
            
            if e == 2 {
                isReady.send()
            }
        }
    }
    
    
}
