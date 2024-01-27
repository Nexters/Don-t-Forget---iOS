//
//  DTO.swift
//  DontForget
//
//  Created by 최지철 on 1/27/24.
//

import Foundation

struct AnniversaryRequestDTO: Decodable {
    let title: String
    let date: String
    let type: String
    let alarmSchedule: [String]
    let content: String
}

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
    let lunarDate: String
    let solarDate: String
}

extension Anniversary {
    static let dummy = Anniversary(
        anniversaryId: UUID().uuidString,
        title: "할머니 생신",
        lunarDate: Date().formatted(),
        solarDate: Date().formatted()
    )
}
