//
//  AnimationConfiguration.swift
//  GitTool
//
//  Created by M_Sugawara on 2017/06/12.
//  Copyright © 2017年 M_Sugawara. All rights reserved.
//

import Foundation
import UIKit

/**
   Exposes custom animation styles for insertion, deletion and reloading behavior.
 */
public struct AnimationConfiguration {
    let insertAnimation: UITableViewRowAnimation
    let reloadAnimation: UITableViewRowAnimation
    let deleteAnimation: UITableViewRowAnimation
    
    public init(insertAnimation: UITableViewRowAnimation = .automatic,
                reloadAnimation: UITableViewRowAnimation = .automatic,
                deleteAnimation: UITableViewRowAnimation = .automatic) {
        self.insertAnimation = insertAnimation
        self.reloadAnimation = reloadAnimation
        self.deleteAnimation = deleteAnimation
    }
}
