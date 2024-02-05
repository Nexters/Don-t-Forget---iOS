//
//  EndPoint.swift
//  DontForget
//
//  Created by 최지철 on 1/27/24.
//

import Foundation
import Moya

enum DontForgetTarget {
    case registerAnniversary(
        title: String,
        date: String,
        content: String,
        calendarType: String,
        cardType: String,
        alarmSchedule: [String]
    ) // 기념일 등록
    case readAnniversary(anniversaryId: Int) // 기념일 단건 조회
    case readAnniversaries // 기념일 목록조회
    case editAnniversary(anniversaryId: Int) // 기념일 수정
    case deleteAnniversary(anniversaryId: Int) // 기념일 삭제
    case changePushState(deviceId: String) // 디바이스 알림상태 변경
}

extension DontForgetTarget: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .registerAnniversary:
            return "anniversary"
        case let .readAnniversary(anniversaryId):
            return "anniversary/\(anniversaryId)"
        case .readAnniversaries:
            return "anniversary"
        case let .editAnniversary(anniversaryId):
            return "anniversary/\(anniversaryId)"
        case let .deleteAnniversary(anniversaryId):
            return "anniversary/\(anniversaryId)"
        case let .changePushState(deviceId):
            return "device/\(deviceId)"
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .registerAnniversary:
            return .post
        case .readAnniversary,
                .readAnniversaries:
            return .get
        case .editAnniversary,
                .changePushState:
            return .put
        case .deleteAnniversary:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .registerAnniversary(title, date, content, calendarType, cardType, alarmSchedule):
            let parameters: [String: Any] = [
                "title": title,
                "date": date,
                "content": content,
                "calendarType": calendarType,
                "cardType": cardType,
                "alarmSchedule": alarmSchedule
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return ["deviceId": "deviceId", "Content-Type": "application/json"]
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
