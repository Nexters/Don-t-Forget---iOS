//
//  DTO.swift
//  DontForget
//
//  Created by 최지철 on 1/27/24.
//

import Foundation

struct AnniversaryDTO: Decodable {
    let anniversaryId: Int
    let title: String
    let lunarDate: String
    let solarDate: String
    let cardType: String
}
