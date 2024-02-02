//
//  DTO.swift
//  DontForget
//
//  Created by 최지철 on 1/27/24.
//

import Foundation

struct CheckAnniversaryDTO: Decodable {
    let anniversaryId: String
    let title: String
    let lunarDate: String
    let solarDate: String
    let type: String
    let alarmSchedule: [String]
    let content: String
    let deviceId: String
}

struct AnniversaryListResponseDTO: Decodable {
    let deviceId: String
    let anniversaries: [Anniversary]
}

struct Anniversary: Codable {
    let anniversaryId: String
    let title: String
    let note: String
    let cardType: Int
    let lunarDate: String
    let solarDate: String
}
