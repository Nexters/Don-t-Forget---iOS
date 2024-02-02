//
//  Anniversary.swift
//  DontForget
//
//  Created by 제나 on 2/2/24.
//

import Foundation

struct Anniversary: Equatable, Identifiable {
    typealias Identifier = String
    let id: Identifier
    let title: String
    let note: String?
    let cardType: Int
    let lunarDate: String
    let solarDate: String
}

struct Anniversaries {
    let anniversaries: [Anniversary]
}
