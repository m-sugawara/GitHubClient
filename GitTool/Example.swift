//
//  Example.swift
//  GitTool
//
//  Created by M_Sugawara on 2017/06/17.
//  Copyright © 2017年 M_Sugawara. All rights reserved.
//

#if os(iOS)
    import UIKit
    typealias Image = UIImage
#elseif os(macOS)
    import Cocoa
    import AppKit
    typealias Image = NSImage
#endif

let MB = 1024 * 1024

func exampleError(_ error: String, location: String = "\(#file):\(#line)") -> NSError {
    return NSError(domain: "ExampleError", code: -1, userInfo: [NSLocalizedDescriptionKey: "\(location): \(error)"])
}

extension String {
    func toFloat() -> Float? {
        let numberFormatter = NumberFormatter()
        return numberFormatter.number(from: self)?.floatValue
    }
    
    func toDouble() -> Double? {
        let numberFormatter = NumberFormatter()
        return numberFormatter.number(from: self)?.doubleValue
    }
}

func showAlert(_ message: String) {
    #if os(iOS)
        UIAlertView(title: "RxExample", message: message, delegate: nil, cancelButtonTitle: "OK").show()
    #elseif os(macOS)
        let alert = NSAlert()
        alert.messageText = message
        alert.runModal()
    #endif
}
