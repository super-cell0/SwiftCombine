//
//  VCSequenceOperators.swift
//  SwiftCombine
//
//  Created by mac on 2023/11/2.
//

//7.0
import Combine
import Foundation

/*
 可以使用min和max分别发出发行者发出的最小值或最大值。
 首先，当您希望查找在特定索引处发出的值时，last和output(at:)非常有用。使用output(in:)来查找在索引范围内发出的值。
 First (where:)和last(where:)都使用一个谓词来确定应该让哪些值通过。
 像count、contains和allSatisfy这样的操作符不会发出由发布者发出的值。相反，它们会根据发出的值发出不同的值。
 Contains (where:)接受一个谓词来确定发布者是否包含给定的值。
 使用reduce将发出的值累积为单个值。
 */

struct Person {
    let id: Int
    let name: String
  }

extension ViewController {
    
    //最小操作符允许查找发布者发出的最小值。它是贪婪的，这意味着它必须等待发布者发送.finished完成事件。一旦发布完成，操作符只会发出最小值:
    func demoMin() {
        let publisher = [1, 20, -50, 0, 432].publisher
        
        publisher
            .print("publisher")
            .min()
            .sink(receiveCompletion: { print($0)}, receiveValue: {print($0)})
            .store(in: &subscriptions)
    }
    
    func demoMinNon() {
        let publisher = ["12345", "ab", "hello world"]
            .map { Data($0.utf8) }
            .publisher
        
        publisher
            .print("publisher")
            .min(by: { $0.count < $1.count} )
            .sink { data in
                let stringData = String(data: data, encoding: .utf8)!
                print(stringData, stringData.count)
            }
            .store(in: &subscriptions)
    }
    
    func demoMax() {
        let publisher = ["A", "C", "G", "Z", "Y"].publisher
        
        publisher
            .print("publisher")
            .max()
            .sink(receiveValue: { print($0)} )
            .store(in: &subscriptions)
    }
    
    func demoMaxBy() {}
    
    func demoFirst() {
        let publisher = ["A", "C", "G", "Z", "Y"].publisher
        publisher
            .first()
            .sink(receiveValue: {print($0)})
            .store(in: &subscriptions)
    }

    /*
     publisher: receive value: (J)
     publisher: receive value: (O)
     publisher: receive value: (H)
     publisher: receive cancel
     First match is H
     */
    func demoFirstWhere() {
        let publisher = ["J", "O", "H", "N"].publisher
        publisher
            .print("publisher")
            .first(where: { "Hello world".contains($0)})
            .sink(receiveValue: {print($0)})
            .store(in: &subscriptions)
    }
    
    func demoLast() {
        let publisher =  ["a", "b", "c"].publisher
        publisher
            .last()
            .sink(receiveValue: {print($0)})
            .store(in: &subscriptions)
    }
    
    func demoLastWhere02() {
        let publisher = [1, 3, 4, 6, 9, 34, 35, 19].publisher
        publisher
            .last(where: { $0 % 2 == 0})
            .sink(receiveValue: {print($0)})
            .store(in: &subscriptions)
    }
    
    //output运算符将查找上游发布者在指定索引处发出的值。
    func demoOutputAt() {
        let publisher = ["a", "b", "r", "y"].publisher
        publisher
            .output(at: 2)
            .sink(receiveValue: {print($0)})
            .store(in: &subscriptions)
    }
    
    //虽然output(at:)会在指定索引处发出单个值，但output(in:)会发出索引在提供范围内的值:
    func demoOutputIn() {
        let publisher = ["A", "B", "C", "D", "E"].publisher
        publisher
            .output(in: 1...3)
            .sink(receiveValue: {print($0)})
            .store(in: &subscriptions)
    }
    
    //7.3
    func demoCount() {
        let publisher = ["A", "B", "C", "D", "E"].publisher
        publisher
            .count()
            .sink(receiveValue: {print($0)})
            .store(in: &subscriptions)
    }
    
    //contains
    //如果上游发布者发出指定值，则contains运算符将发出true并取消订阅，如果发出的值均不等于指定值，则为false：
    func demoContains() {
        let publisher = ["A", "B", "C", "D", "E"].publisher
        let letter = "G"
        publisher
            .contains(letter)
            .sink { model in
                print(model ? "出版商发出 \(letter)" : "发布者从未发出 \(letter)")
            }
            .store(in: &subscriptions)
    }
    
    func demoContainWhere() {
        let people = [
            (123, "Shai Mishali"),
            (777, "Marin Todorov"),
            (214, "Florent Pillet")]
            .map(Person.init)
            .publisher
        
        people
            .contains(where: { $0.id == 800 || $0.name == "Marin Todorov" })
            .sink { model in
                print(model ? "标准匹配" : "找不到符合条件的人")
            }
            .store(in: &subscriptions)
        
    }
    
    func allSatisfyDemo() {
        let number = stride(from: 0, to: 5, by: 2).publisher
        number
            .allSatisfy { $0 % 2 == 0}
            .sink { model in
                print(model ? "所有数字都是偶数" : "odd")
            }
            .store(in: &subscriptions)
    }
    
    /*
     //1
     .reduce("") { accumulator, value in
       // 3
       return accumulator + value
     }
     //2
     .reduce("", +)
     */
    func reduceDemo() {
        let publisher = ["Hel", "lo", " ", "Wor", "ld", "!"].publisher
        publisher
            .reduce("") { a, b in
                a + b
            }
            .sink(receiveValue: {print($0)})
            .store(in: &subscriptions)
    }
    
    
}
