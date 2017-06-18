//
//  DataSources.swift
//  GitTool
//
//  Created by M_Sugawara on 2017/06/12.
//  Copyright © 2017年 M_Sugawara. All rights reserved.
//

import Foundation

enum RxDataSourceError: Error {
    case unwrappingOptional
    case preconditionFailed(message: String)
}

func rxPrecondition(_ condition: Bool, _ message: @autoclosure() -> String) throws -> () {
    if condition {
        return
    }
    rxDebugFatalError("Precondition failed")
    
    throw RxDataSourceError.preconditionFailed(message: message())
}

func rxDebugFatalError(_ error: Error) {
    rxDebugFatalError("\(error)")
}

func rxDebugFatalError(_ message: String) {
    #if DEBUG
        fatalError(message)
    #else
        print(message)
    #endif
}
