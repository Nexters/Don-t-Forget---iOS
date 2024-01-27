//
//  Anniversary.swift
//  DontForget
//
//  Created by 제나 on 1/26/24.
//

import Foundation

struct Anniversary {
    var title: String
    var solarDate: Date
}

extension Anniversary {
    static let dummy = Anniversary(
        title: "할머니 생신",
        solarDate: Date()
    )
}
