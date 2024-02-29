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

struct RegisterAnniversaryRequest {
    let title: String
    let date: String
    let content: String
    let calendarType: String
    let cardType: String
    let alarmSchedule: [String]
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

struct AnniversaryDTO: Decodable, Equatable {
    let anniversaryId: Int
    let title: String
    let lunarDate: String
    let solarDate: String
    let cardType: String
}

struct AnniversaryDetailDTO: Decodable {
    let anniversaryId: Int
    let title: String
    let lunarDate: String
    let solarDate: String
    let alarmSchedule: [String]
    let content: String
    let deviceId: String
    let cardType: String
    let baseDate: String
    let baseType: String
}
