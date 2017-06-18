//
//  SectionModelType.swift
//  GitTool
//
//  Created by M_Sugawara on 2017/06/04.
//  Copyright © 2017年 M_Sugawara. All rights reserved.
//

import Foundation

public protocol SectionModelType {
    associatedtype Item
    
    var items: [Item] { get }
    
    init(original: Self, items: [Item])
}
