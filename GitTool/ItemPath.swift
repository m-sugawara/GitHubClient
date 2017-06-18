//
//  ItemPath.swift
//  GitTool
//
//  Created by M_Sugawara on 2017/06/12.
//  Copyright © 2017年 M_Sugawara. All rights reserved.
//

import Foundation

public struct ItemPath {
    public let sectionIndex: Int
    public let itemIndex: Int
}

extension ItemPath: Equatable {
    
}

public func == (lhs: ItemPath, rhs: ItemPath) -> Bool {
    return lhs.sectionIndex == rhs.sectionIndex && lhs.itemIndex == rhs.itemIndex
}
