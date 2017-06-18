//
//  Application+Extensions.swift
//  GitTool
//
//  Created by M_Sugawara on 2017/06/17.
//  Copyright © 2017年 M_Sugawara. All rights reserved.
//

import Foundation

#if os(iOS)
    import UIKit
    typealias OSApplication = UIApplication
#elseif os(macOS)
    import Cocoa
    typealias OSApplication = NSApplication
#endif

extension OSApplication {
    static var isInUITest: Bool {
        return ProcessInfo.processInfo.environment["isUITest"] != nil;
    }
}
