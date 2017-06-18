//
//  Version.swift
//  GitTool
//
//  Created by M_Sugawara on 2017/06/17.
//  Copyright © 2017年 M_Sugawara. All rights reserved.
//

import class Foundation.NSObject

class Unique: NSObject {
    
}
struct Version<Value>: Hashable {
    
    private let _unique: Unique
    let value: Value
    
    init(_ value: Value) {
        self._unique = Unique()
        self.value = value
    }
    
    var hashValue: Int {
        return self._unique.hash
    }
    
    static func ==(lhs: Version<Value>, rhs: Version<Value>) -> Bool {
        return lhs._unique === rhs._unique
    }
}

extension Version {
    func mutate(transform: (inout Value) -> ()) -> Version<Value> {
        var newSelf = self.value
        transform(&newSelf)
        return Version(newSelf)
    }
    
    
    func mutate(transform: (inout Value) throws -> ()) rethrows -> Version<Value> {
        var newSelf = self.value
        try transform(&newSelf)
        return Version(newSelf)
    }
}
