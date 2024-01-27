//
//  EndPoint.swift
//  DontForget
//
//  Created by 최지철 on 1/27/24.
//

import Foundation
import Moya

enum DontForgetTarget {
    case registerAnniversary(request: AnniversaryRequestDTO) // 기념일 등록
    case checkAnniversary(anniversaryId: String) // 기념일 단건 조회
    case checkAnniversaryList // 기념일 목록조회
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
            return "device/{deviceId}"
        case .checkAnniversary(anniversaryId: let anniversaryId):
            return "anniversary/\(anniversaryId)"
        case .checkAnniversaryList:
            return "anniversary"
        case .editAnniversary(anniversaryId: let anniversaryId):
            return "anniversary/\(anniversaryId)"
        case .deleteAnniversary(anniversaryId: let anniversaryId):
            return "anniversary/\(anniversaryId)"
        case .changePushState(deviceId: let deviceId):
            return "device/\(deviceId)"
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .registerAnniversary:
            return .post
        case .checkAnniversary,
                .checkAnniversaryList:
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
        case .registerAnniversary(let request):
            return .requestJSONEncodable(request as! Encodable)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            guard let deviceId = UserDefaults.standard.string(forKey: "(deviceId)") else {
                return nil
            }
            return ["Authorization": "Bearer \(deviceId)", "Content-Type": "application/json"]
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
