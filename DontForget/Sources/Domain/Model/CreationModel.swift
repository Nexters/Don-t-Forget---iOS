//
//  CreationModel.swift
//  DontForget
//
//  Created by 최지철 on 1/29/24.
//

import Foundation

enum ConvertDate {
    case solar
    case lunar
    
    var title: String {
        switch self {
        case .solar:
            return "SOLAR"
        case .lunar:
            return "LUNAR"
        }
    }
}

enum AlarmPeriod {
    case dDay
    case dayAgo
    case threeDayAgo
    case oneWeekAgo
    case twoWeekAgo
    case oneMonthAgo
    
    var title: String {
        switch self {
        case .dDay:
            return "당일"
        case .dayAgo:
            return "하루 전"
        case .threeDayAgo:
            return "3일 전"
        case .oneWeekAgo:
            return "1주 전"
        case .twoWeekAgo:
            return "2주 전"
        case .oneMonthAgo:
            return "1달 전"
        }
    }
    
    var schedule: String {
        switch self {
        case .dDay:
            return "D_DAY"
        case .dayAgo:
            return "ONE_DAYS"
        case .threeDayAgo:
            return "THREE_DAYS"
        case .oneWeekAgo:
            return "ONE_WEEKS"
        case .twoWeekAgo:
            return "TWO_WEEKS"
        case .oneMonthAgo:
            return "ONE_MONTH"
        }
    }
}

extension AlarmPeriod {
   static var allCases: [AlarmPeriod] {
        return [.dDay, .dayAgo, .threeDayAgo, .oneWeekAgo, .twoWeekAgo, .oneMonthAgo]
    }
}
