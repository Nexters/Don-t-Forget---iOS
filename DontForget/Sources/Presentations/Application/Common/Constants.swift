//
//  Constants.swift
//  DontForget
//
//  Created by 제나 on 1/26/24.
//

import Foundation

struct Constants {
    static let horizontalLayout = 20.0
    static let topLayout = 59.0
    
    static func getDDay(_ formatted: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let from = formatter.date(from: formatted)!
        let calendar = Calendar.current
        let currentDate = Date()
        return calendar.dateComponents([.day], from: from, to: currentDate).day! + 1
    }
}
