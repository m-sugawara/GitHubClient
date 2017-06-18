//
//  Lenses.swift
//  GitTool
//
//  Created by M_Sugawara on 2017/06/18.
//  Copyright © 2017年 M_Sugawara. All rights reserved.
//

// These are kind of "Swift" lenses. We don't need to generate a lot of code this way and can just use Swift `var`
protocol Mutable {
}

extension Mutable {
    func mutateOne<T>(transform: (inout Self) -> T) -> Self {
        var newSelf = self
        _ = transform(&newSelf)
        return newSelf
    }
    
    func mutate(transform: (inout Self) -> ()) -> Self {
        var newSelf = self
        transform(&newSelf)
        return newSelf
    }
}
