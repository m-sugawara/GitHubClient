//
//  Result.swift
//  GitTool
//
//  Created by M_Sugawara on 2017/06/18.
//  Copyright © 2017年 M_Sugawara. All rights reserved.
//

enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}
