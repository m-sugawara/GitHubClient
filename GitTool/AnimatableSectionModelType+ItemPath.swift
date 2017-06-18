//
//  AnimatableSectionModelType+ItemPath.swift
//  GitTool
//
//  Created by M_Sugawara on 2017/06/12.
//  Copyright © 2017年 M_Sugawara. All rights reserved.
//

import Foundation

extension Array where Element: AnimatableSectionModelType {
    subscript(index: ItemPath) -> Element.Item {
        return self[index.sectionIndex].items[index.itemIndex]
    }
}
