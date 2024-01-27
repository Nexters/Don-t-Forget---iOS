//
//  DTO.swift
//  DontForget
//
//  Created by 최지철 on 1/27/24.
//

import Foundation

struct anniversaryRequestDTO: Decodable {
    let title: String
    let date: String
    let type: String
    let alarmSchedule: [String]
    let content: String
}

struct checkAnniversaryDTO: Decodable {
    let anniversaryId: String
    let title: String
    let lunarDate: String
    let solarDate: String
    let type: String
    let alarmSchedule: [String]
    let content: String
    let deviceId: String
}

struct anniversaryListResponseDTO: Decodable {
    let deviceId: String
    let anniversaries: [anniversary]
}
struct anniversary: Codable {
    let anniversaryId: String
    let title: String
    let lunarDate: String
    let solarDate: String
}
