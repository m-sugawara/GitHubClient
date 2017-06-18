//
//  UINavigationController+Extensions.swift
//  GitTool
//
//  Created by M_Sugawara on 2017/06/18.
//  Copyright © 2017年 M_Sugawara. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct Colors {
    static let offlineCotor = UIColor(red: 1.0, green: 0.6, blue: 0.6, alpha: 1.0)
    static let onlineColor = nil as UIColor?
}

extension Reactive where Base: UINavigationController {
    var isOffline: UIBindingObserver<Base, Bool> {
        return UIBindingObserver(UIElement: base, binding: { navigationController, isOffline in
            navigationController.navigationBar.barTintColor = isOffline
                ? Colors.offlineCotor
                : Colors.onlineColor
        })
    }
}
