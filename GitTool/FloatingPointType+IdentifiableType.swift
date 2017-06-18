//
//  FloatingPointType+IdentifiableType.swift
//  GitTool
//
//  Created by M_Sugawara on 2017/06/12.
//  Copyright © 2017年 M_Sugawara. All rights reserved.
//

import Foundation

extension FloatingPoint {
    typealias identity = Self

    public var identity: Self {
        return self
    }
}

extension Float: IdentifiableType {
    
}

extension Double: IdentifiableType {
    
}
