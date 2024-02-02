//
//  AnniversaryService.swift
//  DontForget
//
//  Created by 최지철 on 1/27/24.
//

import Foundation
import Moya

class AnniversaryService {
    
    private let provider = MoyaProvider<DontForgetTarget>()
    
    func fetchAnniversaries() async throws -> AnniversariesResponse {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.readAnniversaries) { result in
                switch result {
                case let .success(response):
                    print("=== DEBUG: \(response)")
                    do {
                        let response = try response.map(AnniversariesResponse.self)
                        continuation.resume(returning: response)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                    
                case let .failure(error):
                    print("=== DEBUG: \(error)")
                    // TODO: - handling error
                }
            }
        }
    }
    
    func registerAnniversary(
        deviceId: String,
        title: String,
        date: String,
        content: String,
        type: String,
        alarmSchedule: [String]
    ) async throws -> CreationResponse {  /// 기념일 등록을 요청하는 함수 Swift Concurrency를 통해 비동기처리
        print("asdas")
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.registerAnniversary(deviceUuid: deviceId, title: title, date: date, content: content, type: type, alarmSchedule: alarmSchedule)) { result in
                switch result {
                case .success(let response):
                    print(response)
                    do {
                        let creationResponse = try response.map(CreationResponse.self)
                        continuation.resume(returning: creationResponse)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    print(error)
                    do {
                        /// 에러 응답을 ErrorResponse로 디코딩합니다.
                        let errorResponse = try error.response?.map(ErrorResponse.self)
                        continuation.resume(throwing: ServiceError.serverError(errorResponse ?? ErrorResponse(message: "에러메시지가 null")))
                    } catch {
                        /// 디코딩 실패 시 일반 에러로 처리합니다.
                        continuation.resume(throwing: ServiceError.unknownError(error))
                    }
                }
            }
        }
    }
}
