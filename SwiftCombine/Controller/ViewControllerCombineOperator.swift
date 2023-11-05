//
//  ViewControllerCombineOperator.swift
//  SwiftCombine
//
//  Created by mac on 2023/10/19.
//

//5. Combining Operators

import Foundation
import Combine
import UIKit

/*
 可以使用“prepend”和“append”操作符族，在不同发布者之前或之后添加来自一个发布者的排放量。
 虽然switchtollatest相对复杂，但它非常有用。它接受一个发送发布者的发布者，切换到最新的发布者并取消对前一个发布者的订阅
 Merge (with:)允许您将来自多个发布者的值交织在一起。
 一旦所有合并的发布者发出至少一个值，“combinellatest”就会发出所有合并的发布者的最新值。
 Zip对来自不同发布者的释放，在所有发布者释放一个值之后释放一个对元组
 */


extension ViewController {
    
    //添加到数组头部
    //prepend有一种变体 其区别在于它接受任何Sequence符合对象作为输入。例如，它可以取一个数Array或一个Set
    func demoPrepend() {
        let number = [3, 4].publisher
        number
            .prepend(5, 6)
            .prepend(Set(1...2))
            .prepend([89, 99])
            .prepend(stride(from: 6, to: 11, by: 2))
            .sink(receiveValue: { print($0)})
            .store(in: &subscriptions)
    }
    
    func demoPrepend2() {
        let number1 = [3, 4].publisher
        let number2 = [5, 6].publisher
        
        number1
            .prepend(number2)
            .sink(receiveValue: { print($0)} )
            .store(in: &subscriptions)
        
    }
    
    func prependPublisher() {
        let number1 = [3, 4].publisher
        let number2 = PassthroughSubject<Int, Never>()
        
        number1
            .prepend(number2)
            .sink(receiveValue: { print($0)} )
            .store(in: &subscriptions)
        
        number2.send(99)
        number2.send(100)
        number2.send(completion: .finished)
    }
    
    //运算符处理出版商与其他值连接事件
    //但在这种情况下，将处理附加而不是预置，使用append(Output...)append(Sequence)和append(Publisher)
    //每个append都等待上游完成，然后再向其添加自己的工作。
    //这意味着上游必须完成，否则永远不会发生附加，因为Combine无法知道之前的发布者已经完成了其所有值。
    //output
    func demoPrependOutput() {
        let number = [1].publisher
        
        number
            .append(2, 3)
            .append(4)
            .sink(receiveValue: { print($0)})
            .store(in: &subscriptions)
    }
    
    //output
    func demoPrependOutputP() {
        let number = PassthroughSubject<Int, Never>()
        number
            .append(3, 4)
            .append(5)
            .sink(receiveValue: { print($0)})
            .store(in: &subscriptions)
        
        number.send(1)
        number.send(2)
        number.send(completion: .finished)
    }
    
    //sequence
    //append的执行是连续的，因为上一个发布者必须在下一个append执行之前完成
    func demoSequence() {
        let number = [1, 2, 3].publisher
        number
            .append([4, 5])
            .append(Set([6, 7]))
            .append(stride(from: 8, to: 13, by: 2))
            .sink(receiveValue: { print($0)})
            .store(in: &subscriptions)
    }
    
    func appendPublisher() {
        let number1 = [1, 2].publisher
        let number2 = [3, 4].publisher
        
        number1
            .append(number2)
            .sink(receiveValue: { print($0)} )
            .store(in: &subscriptions)
    }
    
    
    /*
     请考虑以下情况：用户点击触发网络请求的按钮。紧接着，用户再次点击按钮，这会触发第二个网络请求。
     但是，如何摆脱挂起的请求，而只使用最新的请求？switchToLatest救援！
     */
    func demoSwitchToLatest() {
        let number1 = PassthroughSubject<Int, Never>()
        let number2 = PassthroughSubject<Int, Never>()
        let number3 = PassthroughSubject<Int, Never>()
        
        let publishers = PassthroughSubject<PassthroughSubject<Int, Never>, Never>()
        
        //switchToLatest
        //现在每次通过publishers主题发送不同的发布者时，都会切换到新的发布者并取消之前的订阅。
        publishers
            .switchToLatest()
            .sink(receiveCompletion: { print($0)}, receiveValue: { print($0)})
            .store(in: &subscriptions)
        
        publishers.send(number1)
        number1.send(1)
        number1.send(2)
        
        publishers.send(number2)
        number2.send(3)
        number2.send(4)
        number2.send(5)
        
        publishers.send(number3)
        number3.send(6)
        number3.send(7)
        number3.send(8)
        number3.send(9)
        
        number3.send(completion: .finished)
        publishers.send(completion: .finished)
        
        
    }

    
    func demoRequestImage() -> AnyPublisher<UIImage?, Never> {
        let url = URL(string: "https://source.unsplash.com/collection/\(UUID().uuidString)")!
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map { data, _ in
                UIImage(data: data)
            }
            .print("image")
            .replaceError(with: nil)
            .eraseToAnyPublisher()
        
    }
    
    //合并两个Publisher
    func demoMerge() {
        let publisher1 = PassthroughSubject<Int, Never>()
        let publisher2 = PassthroughSubject<Int, Never>()
        
        publisher1
            .merge(with: publisher2)
            .sink(receiveCompletion: { print($0) }, receiveValue: { print($0) })
            .store(in: &subscriptions)
        
        publisher1.send(1)
        publisher1.send(2)
        
        publisher2.send(3)
        
        publisher1.send(4)
        
        publisher2.send(5)
        
        publisher1.send(completion: .finished)
        publisher2.send(completion: .finished)
    }
    
    //combinellatest是另一个操作符，它允许您组合不同的发布者。它还允许您组合不同值类型的发布者，这非常有用
    //但是，它并没有将所有发布者的释放交叉起来，而是在所有发布者释放一个值时释放一个包含所有发布者最新值的元组。
    func demoCombineLatest() {
        let publisher1 = PassthroughSubject<Int, Never>()
        let publisher2 = PassthroughSubject<String, Never>()
        
        publisher1
            .combineLatest(publisher2)
            .sink(receiveCompletion: {print($0)}, receiveValue: { print("publisher1 \($0)", "publisher2 \($1)")})
            .store(in: &subscriptions)
        
        
        publisher1.send(1)
        publisher1.send(2)
        
        publisher2.send("chen")
        
        publisher1.send(3)
        
        publisher2.send("combine")
        publisher2.send("asyn")
        
        publisher1.send(completion: .finished)
        publisher2.send(completion: .finished)
        
        //从publisher1发出的1从未通过combinellatest推送。这是因为只有当每个发布者至少发出一个值时，combinellatest才开始发出组合
    }
    
    //此操作符的工作原理类似，在相同的索引中发出成对值的元组。它等待每个发布者发出一个项目，然后在所有发布者在当前索引处发出一个值后发出一个项目元组。
    func demoZip() {
        let publisher1 = PassthroughSubject<Int, Never>()
        let publisher2 = PassthroughSubject<String, Never>()
        
        publisher1
            .zip(publisher2)
            .sink(receiveCompletion: { print($0) }, receiveValue: { print($0) })
            .store(in: &subscriptions)
        
        publisher1.send(1)
        publisher1.send(2)
        
        publisher2.send("a")
        publisher2.send("b")
        
        publisher1.send(3)
        
        publisher2.send("c")
        publisher2.send("d")
        
        publisher1.send(completion: .finished)
        publisher2.send(completion: .finished)
    }
    
    
}
