//
//  EndPoint.swift
//  DontForget
//
//  Created by 최지철 on 1/27/24.
//

import Foundation
import UIKit

import Moya

enum DontForgetTarget {
    case registerAnniversary(parameter: RegisterAnniversaryRequest) // 기념일 등록
    case readAnniversary(anniversaryId: Int) // 기념일 단건 조회
    case readAnniversaries // 기념일 목록조회
    case editAnniversary(anniversaryId: Int, parameter: RegisterAnniversaryRequest) // 기념일 수정
    case deleteAnniversary(anniversaryId: Int) // 기념일 삭제
    case changePushState(parameter: ChangePushStateRequest) // 디바이스 알림상태 변경
    case fcmTest(parameter: TestRequest)
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
        case let .editAnniversary(anniversaryId, _):
            return "anniversary/\(anniversaryId)"
        case let .deleteAnniversary(anniversaryId):
            return "anniversary/\(anniversaryId)"
        case .changePushState:
            return "v1/notice/device"
        case .fcmTest:
            return "v1/notice"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .registerAnniversary,
                .changePushState,
                .fcmTest:
            return .post
        case .readAnniversary,
                .readAnniversaries:
            return .get
        case .editAnniversary:
            return .put
        case .deleteAnniversary:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .registerAnniversary(parameter):
            let parameters = parameter.toDictionary()
            return .requestParameters(
                parameters: parameters,
                encoding: JSONEncoding.default
            )
        case let .editAnniversary(_, parameter):
            let parameters = parameter.toDictionary()
            return .requestParameters(
                parameters: parameters,
                encoding: JSONEncoding.default
            )
        case let .changePushState(parameter):
            let parameters = parameter.toDictionary()
            return .requestParameters(
                parameters: parameters,
                encoding: JSONEncoding.default
            )
        case let .fcmTest(parameter):
            let parameters = parameter.toDictionary()
            return .requestParameters(
                parameters: parameters,
                encoding: JSONEncoding.default
            )
        default:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return [
                "deviceId": Constants.uuid,
                "Content-Type": "application/json"
            ]
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
