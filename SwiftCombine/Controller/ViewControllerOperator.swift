//
//  ViewControllerOperator.swift
//  SwiftCombine
//
//  Created by mac on 2023/9/22.
//

import Foundation
import Combine

extension ViewController {
    
    ///collect运算符提供了一种方便的方法，将单个值流从发布者转换为单个数组
    ///collect(2)之前填写了其规定的缓冲区
    func exampleCollect() {
        ["A", "B", "C", "D", "E"].publisher
            .collect(2)
            .sink { event in
                print(event)
            } receiveValue: { value in
                print(value)
            }
            .store(in: &subscriptions)

    }
    
    
    //Combine为此目的提供了几个映射运算符
    func exampleMap() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        
//        map<T>(_:)
//        map<T0, T1>(_:_:)
//        map<T0, T1, T2>(_:_:_:)
        
        [123, 4, 56].publisher
            .map {
                formatter.string(for: NSNumber(integerLiteral: $0)) ?? ""
            }
            .sink(receiveValue: { print($0)})
            .store(in: &subscriptions)
        
    }
    
    ///通过关键路径映射到两个属性
    func mapKeyPath() {
        let publisher = PassthroughSubject<Coordinate, Never>()
        
        publisher
            .map(\.x, \.y) //创建对象特定属性的键路径 指向x y的密钥路径
            .sink { x, y in
                print("\(x), \(y)在: ", quadrantOf(x: x, y: y))
            }
            .store(in: &subscriptions)
        
        publisher.send(Coordinate(x: 10, y: -8))
        publisher.send(Coordinate(x: 0, y: 5))
    }
    
    ///需要抛出闭包
    func tryMap() {
//        创建一个表示不存在的目录名称的字符串的发布者
        Just("不存在的目录名称")
            .tryMap { element in
                try FileManager.default.contentsOfDirectory(atPath: element)
            }
            .sink(receiveCompletion: { print($0) }, receiveValue: { print($0) } )
            .store(in: &subscriptions)
    }
    
    ///Combine中flatMap的一个常见用例是，将一个发布者发出的元素传递给一个本身返回发布者的方法，并最终订阅该第二个发布者发出的元素。
    ///定义一个函数，该函数接受一个整数数组，每个数组代表ASCII代码，并返回一个类型擦除的字符串发布者，该字符串永远不会发出错误。
    func decodeDemo(code: [Int] ) -> AnyPublisher<String, Never> {
        Just(
            code
                .compactMap({ code in
                    guard (32...255).contains(code) else { return nil }
                    return String(UnicodeScalar(code) ?? " ")
                })
                .joined()
        )
        .eraseToAnyPublisher()
        
    }
    
    func demoCode() {
        [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
            .publisher
            .collect()
            .flatMap(decodeDemo)
            .sink(receiveValue: { print($0)})
            .store(in: &subscriptions)
    }
    
    
    //replaceNil将收到可选值，并将nil替换为指定的值
    //始终提供值时，可以使用该运算符。
    func exampleReplaceNil() {
        ["A", nil, "C"].publisher
            .eraseToAnyPublisher()
            .replaceNil(with: "-")
            .sink(receiveValue: { print($0)} )
            .store(in: &subscriptions)
        
    }
    
    //发布者在没有发出值的情况下完成，可以使用 replaceEmpty(with:)运算符来替换——或者实际上插入——一个值。
    func exampleReplaceEmpty() {
        let empty = Empty<Int, Never>()
        empty
            .replaceEmpty(with: 1)
            .sink(receiveCompletion: { print($0) }, receiveValue: { print($0) })
            .store(in: &subscriptions)
    }
    
    func exampleScan() {
        var dailyGainLoss: Int { .random(in: -10...10) }
        let august2019 = (0..<20)
            .map { _ in
                dailyGainLoss
            }
            .publisher
        
        august2019
            .scan(50) { latest, current in
                max(0, latest + current)
            }
            .sink(receiveValue: { print($0) })
            .store(in: &subscriptions)
    }
    
}
