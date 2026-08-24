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

    /// 저장된 alarmSchedule 문자열로부터 알람 주기를 복원합니다.
    init?(schedule: String) {
        guard let period = AlarmPeriod.allCases.first(where: { $0.schedule == schedule }) else {
            return nil
        }
        self = period
    }

    /// 기념일 당일로부터 얼마나 앞서 알릴지를 나타냅니다.
    /// 한 달 전은 일수가 달마다 달라 month 단위로 계산합니다.
    var notificationOffset: DateComponents {
        switch self {
        case .dDay:
            return DateComponents(day: 0)
        case .dayAgo:
            return DateComponents(day: -1)
        case .threeDayAgo:
            return DateComponents(day: -3)
        case .oneWeekAgo:
            return DateComponents(day: -7)
        case .twoWeekAgo:
            return DateComponents(day: -14)
        case .oneMonthAgo:
            return DateComponents(month: -1)
        }
    }

    /// 알림 본문에 쓰이는 문구입니다.
    var notificationPhrase: String {
        switch self {
        case .dDay:
            return "오늘이에요"
        default:
            return "\(title)이에요"
        }
    }
}
