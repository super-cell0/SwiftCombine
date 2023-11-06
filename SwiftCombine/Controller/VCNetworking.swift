//
//  VCNetworking.swift
//  SwiftCombine
//
//  Created by mac on 2023/11/6.
//

//9.0
import Foundation
import Combine

struct Car: Codable {
    let make: String
    let model: String
    let year: Int
    let color: String
}


extension ViewController {
    
    func demoRequest() {
        guard let url = URL(string: "https://mysite.com/mydata.json") else { return }
        let subsscription = URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Car.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                if case .failure(let failure) = completion {
                    print(failure)
                }
            }, receiveValue: { data in
                print(data)
            })
        
    }
    
    
}

// 11
extension ViewController {
    
    func demoDispatchQueue() {
        let source = PassthroughSubject<Int, Never>()
        let queue = DispatchQueue.main
        var counter = 0
        
        let cancellable = queue.schedule(after: queue.now, interval: .seconds(1)) {
            source.send(counter)
            counter += 1
        }
        
        let subscrption = source.sink(receiveValue: {print($0)})
    }
    
    func demoTimer() {
        
    }
    
    
}
