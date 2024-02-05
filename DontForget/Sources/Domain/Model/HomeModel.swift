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
            id: UUID().uuidString,
            title: "음력으로 내 생일",
            date: Date().formatted(date: .numeric, time: .omitted),
            content: "가족 여행 미리 계획하기",
            calendarType: CalendarType.solar.rawValue,
            cardType: CardType.lunar.rawValue,
            alarmSchedule: [AlarmPeriod.oneMonth.rawValue]
        ),
        Anniversary(
            id: UUID().uuidString,
            title: "음력으로 내 생일",
            date: Date().formatted(date: .numeric, time: .omitted),
            content: "가족 여행 미리 계획하기",
            calendarType: CalendarType.solar.rawValue,
            cardType: CardType.lunar.rawValue,
            alarmSchedule: [AlarmPeriod.oneMonth.rawValue]
        ),
        Anniversary(
            id: UUID().uuidString,
            title: "음력으로 내 생일",
            date: Date().formatted(date: .numeric, time: .omitted),
            content: "가족 여행 미리 계획하기",
            calendarType: CalendarType.solar.rawValue,
            cardType: CardType.lunar.rawValue,
            alarmSchedule: [AlarmPeriod.oneMonth.rawValue]
        ),Anniversary(
            id: UUID().uuidString,
            title: "음력으로 내 생일",
            date: Date().formatted(date: .numeric, time: .omitted),
            content: "가족 여행 미리 계획하기",
            calendarType: CalendarType.solar.rawValue,
            cardType: CardType.lunar.rawValue,
            alarmSchedule: [AlarmPeriod.oneMonth.rawValue]
        ),
        Anniversary(
            id: UUID().uuidString,
            title: "음력으로 내 생일",
            date: Date().formatted(date: .numeric, time: .omitted),
            content: "가족 여행 미리 계획하기",
            calendarType: CalendarType.solar.rawValue,
            cardType: CardType.lunar.rawValue,
            alarmSchedule: [AlarmPeriod.oneMonth.rawValue]
        ),
        Anniversary(
            id: UUID().uuidString,
            title: "음력으로 내 생일",
            date: Date().formatted(date: .numeric, time: .omitted),
            content: "가족 여행 미리 계획하기",
            calendarType: CalendarType.solar.rawValue,
            cardType: CardType.lunar.rawValue,
            alarmSchedule: [AlarmPeriod.oneMonth.rawValue]
        )
    ]
}
