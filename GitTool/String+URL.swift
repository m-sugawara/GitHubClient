//
//  String+URL.swift
//  GitTool
//
//  Created by M_Sugawara on 2017/06/17.
//  Copyright © 2017年 M_Sugawara. All rights reserved.
//

extension String {
    var URLEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}
