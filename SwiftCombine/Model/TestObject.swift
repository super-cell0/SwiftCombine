//
//  TestObject.swift
//  SwiftCombine
//
//  Created by mac on 2023/11/7.
//

import Foundation


class TestObject: NSObject {
    @objc dynamic var intergerProperty: Int = 0
    @objc dynamic var stringProperty: String = ""
    @objc dynamic var arrayProperty: [Float] = []
    
    //@objc dynamic var structPropetry: PureSwift = .init(a: (0, false))

}

struct PureSwift {
    let a: (Int, Bool)
}


class MonitorObject: ObservableObject {
  @Published var someProperty = false
  @Published var someOtherProperty = ""
}
