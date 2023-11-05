//
//  MainModel.swift
//  SwiftCombine
//
//  Created by mac on 2023/9/20.
//

import Foundation
import Combine

enum MyError: Error {
    case tese
}

class SomeObject {
    
    var value: String = "" {
        didSet {
            print(value)
        }
    }
    
    @Published var newValue = 0
    
    
}

///创建自定义订阅者
final class IntSubscriber: Subscriber {
    
    typealias Input = Int
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.max(2))
    }
    
    func receive(_ input: Int) -> Subscribers.Demand {
        print("receive value", input)
        
        switch input {
        case 1:
          return .max(2) // 1
        case 3:
          return .max(1) // 2
        default:
          return .none // 3
        }
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("completion value", completion)
    }

    
}

final class StringSubscriber: Subscriber {
    
    typealias Input = String
    typealias Failure = MyError
    
    func receive(subscription: Subscription) {
        subscription.request(.max(2))
    }
    
    func receive(_ input: String) -> Subscribers.Demand {
        print("receive value", input)
        return input == "word" ? .max(1) : .none
    }
    
    func receive(completion: Subscribers.Completion<MyError>) {
        print("completion value", completion)
    }

    
}

