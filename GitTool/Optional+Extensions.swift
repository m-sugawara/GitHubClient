//
//  Optional+Extensions.swift
//  GitTool
//
//  Created by M_Sugawara on 2017/06/12.
//  Copyright © 2017年 M_Sugawara. All rights reserved.
//

import Foundation

extension Optional {
    func unwrap() throws -> Wrapped {
        if let unwrapped = self {
            return unwrapped
        }
        else {
            rxDebugFatalError("Error during unwrapping optional")
            throw RxDataSourceError.unwrappingOptional
        }
    }
}
