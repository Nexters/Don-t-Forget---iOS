//
//  DTO.swift
//  DontForget
//
//  Created by 최지철 on 1/27/24.
//

import Foundation

struct TestRequest {
    let deviceUuid: String
    let title: String
    let body: String
    
    func toDictionary() -> [String: Any] {
        return [
            "deviceUuid": deviceUuid,
            "title": title,
            "body": body
        ]
    }
}

struct ChangePushStateRequest {
    let token: String
    let deviceUuid: String
    let status: String
    
    func toDictionary() -> [String: Any] {
        return [
            "token": token,
            "deviceUuid": deviceUuid,
            "status": status
        ]
    }
}

public struct RegisterAnniversaryRequest {
    public let title: String
    public let date: String
    public let content: String
    public let calendarType: String
    public let cardType: String
    public let alarmSchedule: [String]

    public init(title: String, date: String, content: String, calendarType: String, cardType: String, alarmSchedule: [String]) {
        self.title = title
        self.date = date
        self.content = content
        self.calendarType = calendarType
        self.cardType = cardType
        self.alarmSchedule = alarmSchedule
    }
}

extension RegisterAnniversaryRequest {
    func toDictionary() -> [String: Any] {
         return [
             "title": title,
             "date": date,
             "content": content,
             "calendarType": calendarType,
             "cardType": cardType,
             "alarmSchedule": alarmSchedule
         ]
     }
}

public struct AnniversaryDTO: Decodable, Equatable {
    public let anniversaryId: Int
    public let title: String
    public let lunarDate: String
    public let solarDate: String
    public let cardType: String

    public init(anniversaryId: Int, title: String, lunarDate: String, solarDate: String, cardType: String) {
        self.anniversaryId = anniversaryId
        self.title = title
        self.lunarDate = lunarDate
        self.solarDate = solarDate
        self.cardType = cardType
    }
}

public struct AnniversaryDetailDTO: Codable {
    public let anniversaryId: Int
    public let title: String
    public let lunarDate: String
    public let solarDate: String
    public let alarmSchedule: [String]
    public let content: String
    public let deviceId: String
    public let cardType: String
    public let baseDate: String
    public let baseType: String

    public init(anniversaryId: Int, title: String, lunarDate: String, solarDate: String, alarmSchedule: [String], content: String, deviceId: String, cardType: String, baseDate: String, baseType: String) {
        self.anniversaryId = anniversaryId
        self.title = title
        self.lunarDate = lunarDate
        self.solarDate = solarDate
        self.alarmSchedule = alarmSchedule
        self.content = content
        self.deviceId = deviceId
        self.cardType = cardType
        self.baseDate = baseDate
        self.baseType = baseType
    }
}
