//
//  HomeModel.swift
//  DontForget
//
//  Created by 제나 on 2/1/24.
//

import SwiftUI

extension Anniversary { // TODO: - 추후 삭제
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
