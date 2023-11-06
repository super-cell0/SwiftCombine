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
//
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        demoDispatchQueue()

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
