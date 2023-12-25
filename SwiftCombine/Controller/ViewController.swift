//
//  ViewController.swift
//  SwiftCombine
//
//  Created by mac on 2023/9/8.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    var subscriptions = Set<AnyCancellable>()
    let taps = PassthroughSubject<Void, Never>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemPink
        
//        operationQueuesAdd()
    }
    

}

//MARK: - GCD
extension ViewController {
    
    func operationQueuesAdd() {
        
        //默认的行为是并发的，如果我们希望它具有串行队列的行为，可以通过设HElmaxConcurrentOperationCount=1
        let operationQueue = OperationQueue()
        let operation1 = BlockOperation()
        let operation2 = BlockOperation()
        
        operation1.completionBlock = {
            print("operation finished")
        }

        operation1.addExecutionBlock {
            for r in 1...100 {
                print("red: \(r)")
            }
        }
        operation1.addExecutionBlock {
            for b in 200...300 {
                print("blue: \(b)")
            }
        }
        
        operation2.addExecutionBlock {
            for g in 900...1000 {
                print("green: \(g)")
            }
        }
        
        operationQueue.maxConcurrentOperationCount = 2
        operation1.addDependency(operation2)
        operationQueue.addOperation(operation1)
        operationQueue.addOperation(operation2)
        //operation1.start()
    }
    
    func operationQueues() {
        let operation1 = BlockOperation {
            for a in 1...100 {
                print("a: \(a)")
            }
        }
        
        let operation2 = BlockOperation {
            for b in 200...300 {
                print("b: \(b)")
            }
        }
        
        operation1.start()
        operation2.start()
    }
    
    func simpleQueue() {
        let queue1 = DispatchQueue(label: "my DispatchQueue", qos: .background)
        let queue2 = DispatchQueue(label: "my DispatchQueue", qos: .userInteractive)
        let _ = DispatchQueue(label: "my queue", qos: .userInteractive, attributes: [.concurrent])
        queue1.async {
            for r in 1...100 {
                print("red: \(r)")
            }
        }
        
        queue2.async {
            for b in 200...300 {
                print("blue: \(b)")
            }
        }
    }
    
}

extension ViewController {
    
    func bindView() {
        taps
            .map { _ in
                self.demoRequestImage()
            }
            .switchToLatest()
            .sink(receiveValue: { _ in
                
            })
            .store(in: &subscriptions)
        
        taps.send()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.taps.send()
          }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
            self.taps.send()
          }
        
    }

    
}


// MARK: - 12
extension ViewController {
        
    //每次向队列添加新操作时，其operationCount都会增加，您的接收器会收到新计数。当队列消耗了操作时，计数会减少，然后再次，您的接收器会收到更新的计数
    func demoKVO() {
        let queue = OperationQueue()
        let _ = queue.publisher(for: \.operationCount)
            .sink(receiveValue: {print($0)})
    }
    
    func demoKVO2() {
        let obj = TestObject()
        let _ = obj.publisher(for: \.intergerProperty)
            .sink(receiveValue: {print($0)})
        
        obj.intergerProperty = 100
        obj.intergerProperty = 34
        
        let _ = obj.publisher(for: \.arrayProperty)
            .sink(receiveValue: {print($0)})
        
        obj.arrayProperty = [1, 4]
        
        let _ = obj.publisher(for: \.stringProperty, options: [.prior])
            .sink(receiveValue: {print($0)})
        
        obj.stringProperty = "chen"
        obj.stringProperty = "hello"
        
    }
    
    func demoMonitorObject() {
        let object = MonitorObject()
        let _ = object.objectWillChange
            .sink(receiveValue: {print($0)})
        
        object.someProperty = true
        object.someOtherProperty = "hello world"
    }
    
    
}
