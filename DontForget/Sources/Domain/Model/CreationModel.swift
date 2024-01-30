//
//  CreationModel.swift
//  DontForget
//
//  Created by 최지철 on 1/29/24.
//

import Foundation

enum convertDate {
    case solar
    case lunar
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
}
extension AlarmPeriod {
   static var allCases: [AlarmPeriod] {
        return [.dDay, .dayAgo, .threeDayAgo, .oneWeekAgo, .twoWeekAgo, .oneMonthAgo]
    }
        
}
