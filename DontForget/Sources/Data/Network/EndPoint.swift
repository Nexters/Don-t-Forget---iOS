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
        deviceUuid: String,
        title: String,
        date: String,
        content: String,
        type: String,
        alarmSchedule: [String]
    ) // 기념일 등록
    case readAnniversary(anniversaryId: String) // 기념일 단건 조회
    case readAnniversaries // 기념일 목록조회
    case editAnniversary(anniversaryId: String) // 기념일 수정
    case deleteAnniversary(anniversaryId: String) // 기념일 삭제
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
        case let .registerAnniversary(deviceUuid, title, date, content, type, alarmSchedule):
            let parameters: [String: Any] = [
                "deviceUuid": deviceUuid,
                "title": title,
                "date": date,
                "content": content,
                "type": type,
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
            return ["deviceId": "Jicheol's iPhone", "Content-Type": "application/json"]
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
