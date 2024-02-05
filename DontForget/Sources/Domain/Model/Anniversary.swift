//
//  Anniversary.swift
//  DontForget
//
//  Created by 제나 on 2/2/24.
//

import Foundation

struct Anniversary: Equatable, Identifiable {
    
    enum CalendarType: String {
        case solar = "SOLAR"
        case lunar = "LUNAR"
    }
    
    enum CardType: String {
        case lunar = "LUNAR"
        case face = "FACE"
        case arm = "ARM"
        case tail = "TAIL"
        case forest = "FOREST"
    }
    
    enum AlarmPeriod: String {
        case oneMonth = "ONE_MONTH"
    }
    
    typealias Identifier = String
    let id: Identifier
    var title: String
    var date: String
    var content: String
    var calendarType: String
    let cardType: String
    var alarmSchedule: [String]
}

struct Anniversaries {
    let anniversaries: [Anniversary]
}
