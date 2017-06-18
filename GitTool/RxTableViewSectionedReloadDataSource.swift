//
//  RxTableViewSectionedReloadDataSource.swift
//  GitTool
//
//  Created by M_Sugawara on 2017/06/04.
//  Copyright © 2017年 M_Sugawara. All rights reserved.
//

import Foundation
import UIKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

public class RxTableViewSectionedReloadDataSource<S: SectionModelType>: TableViewSectionedDataSource<S>, RxTableViewDataSourceType {
    public typealias Element = [S]
    
    public override init() {
        super.init()
    }
    
    public func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {
        UIBindingObserver(UIElement: self) { dataSource, element in
            #if DEBUG
                self._dataSourceBound = true
            #endif
            dataSource.setSections(element)
            tableView.reloadData()
        }.on(observedEvent)
    }
}
