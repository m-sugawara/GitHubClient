//
//  String+IdentifiableType.swift
//  GitTool
//
//  Created by M_Sugawara on 2017/06/12.
//  Copyright © 2017年 M_Sugawara. All rights reserved.
//

import Foundation

extension String: IdentifiableType {
    public typealias Identity = String
    
    public var identity: String {
        return self
    }
}
