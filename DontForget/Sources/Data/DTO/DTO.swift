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
    let note: String
    let cardType: Int
    let lunarDate: String
    let solarDate: String
}

extension Anniversary {
    static var dummy = [
        Anniversary(
            anniversaryId: UUID().uuidString,
            title: "음력으로 내 생일",
            note: "가족 여행 미리 계획하기",
            cardType: Int.random(in: 1..<6),
            lunarDate: Date().formatted(date: .numeric, time: .omitted),
            solarDate: Date().formatted(date: .numeric, time: .omitted)
        ),
        Anniversary(
            anniversaryId: UUID().uuidString,
            title: "음력으로 내 생일",
            note: "가족 여행 미리 계획하기",
            cardType: Int.random(in: 1..<6),
            lunarDate: Date().formatted(date: .numeric, time: .omitted),
            solarDate: Date().formatted(date: .numeric, time: .omitted)
        ),
        Anniversary(
            anniversaryId: UUID().uuidString,
            title: "음력으로 내 생일",
            note: "가족 여행 미리 계획하기",
            cardType: Int.random(in: 1..<6),
            lunarDate: Date().formatted(date: .numeric, time: .omitted),
            solarDate: Date().formatted(date: .numeric, time: .omitted)
        ),
        Anniversary(
            anniversaryId: UUID().uuidString,
            title: "음력으로 내 생일",
            note: "가족 여행 미리 계획하기",
            cardType: Int.random(in: 1..<6),
            lunarDate: Date().formatted(date: .numeric, time: .omitted),
            solarDate: Date().formatted(date: .numeric, time: .omitted)
        ),
        Anniversary(
            anniversaryId: UUID().uuidString,
            title: "음력으로 내 생일",
            note: "가족 여행 미리 계획하기",
            cardType: Int.random(in: 1..<6),
            lunarDate: Date().formatted(date: .numeric, time: .omitted),
            solarDate: Date().formatted(date: .numeric, time: .omitted)
        ),
        Anniversary(
            anniversaryId: UUID().uuidString,
            title: "음력으로 내 생일",
            note: "가족 여행 미리 계획하기",
            cardType: Int.random(in: 1..<6),
            lunarDate: Date().formatted(date: .numeric, time: .omitted),
            solarDate: Date().formatted(date: .numeric, time: .omitted)
        ),
        Anniversary(
            anniversaryId: UUID().uuidString,
            title: "음력으로 내 생일",
            note: "가족 여행 미리 계획하기",
            cardType: Int.random(in: 1..<6),
            lunarDate: Date().formatted(date: .numeric, time: .omitted),
            solarDate: Date().formatted(date: .numeric, time: .omitted)
        )
    ]
}
