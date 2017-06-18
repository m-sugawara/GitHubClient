//
//  Wireframe.swift
//  GitTool
//
//  Created by M_Sugawara on 2017/06/15.
//  Copyright © 2017年 M_Sugawara. All rights reserved.
//

#if !RX_NO_MODULE
    import RxSwift
#endif

#if os(iOS)
    import UIKit
#elseif os(macOS)
    import Cocoa
#endif

enum RetryResult {
    case retry
    case cancel
}

protocol Wireframe {
    func open(url: URL)
    func promptFor<Action: CustomStringConvertible>(_ message: String, cancelAction: Action, actions: [Action]) -> Observable<Action>
}

class DefaultWireframe: Wireframe {
    static let sharedInstance = DefaultWireframe()
    
    func open(url: URL) {
        #if os(iOS)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        #elseif os(macOS)
            NSWorkspace.shared().open(url)
        #endif
    }
    
    #if os(iOS)
    private static func rootViewController() -> UIViewController {
        // cheating
        return UIApplication.shared.keyWindow!.rootViewController!
    }
    #endif
    
    static func presentAlert(_ message: String) {
        #if os(iOS)
            let alertView = UIAlertController(title: "RxExample", message: message, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            }))
            rootViewController().present(alertView, animated: true, completion: nil)
        #endif
    }
    
    func promptFor<Action>(_ message: String, cancelAction: Action, actions: [Action]) -> Observable<Action> where Action : CustomStringConvertible {
        #if os(iOS)
            return Observable.create({ (observer) -> Disposable in
                let alertView = UIAlertController(title: "RxExample", message: message, preferredStyle: .alert)
                alertView.addAction(UIAlertAction(title: cancelAction.description, style: .cancel, handler: { _ in
                    observer.on(.next(cancelAction))
                }))
                
                for action in actions {
                    alertView.addAction(UIAlertAction(title: action.description, style: .default, handler: { (_) in
                        
                    }))
                }
                
                DefaultWireframe.rootViewController().present(alertView, animated: true, completion: nil)
                
                return Disposables.create {
                    alertView.dismiss(animated: false, completion: nil)
                }
            })
            
        #elseif os(macOS)
            return Observable.error(NSError(domain: "Unimplemented", code: -1, userInfo: nil))
            
        #endif
    }
}

extension RetryResult: CustomStringConvertible {
    var description: String {
        switch self {
        case .retry:
            return "Retry"
        case .cancel:
            return "Cancel"
        }
    }
}
