//
//  AnniversaryService.swift
//  DontForget
//
//  Created by 최지철 on 1/27/24.
//

import Foundation
import Moya

class AnniversaryService {
    
    static let shared = AnniversaryService()
    private let provider = MoyaProvider<DontForgetTarget>()
    
    func registerAnniversary(parameters: RegisterAnniversaryRequest) async throws -> CreationResponse {  /// 기념일 등록을 요청하는 함수 Swift Concurrency를 통해 비동기처리
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.registerAnniversary(parameter: parameters)) { result in
                switch result {
                case .success(let response):
                    print("=== DEBUG: \(response)")
                    do {
                        let creationResponse = try response.map(CreationResponse.self)
                        continuation.resume(returning: creationResponse)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    print("=== DEBUG: \(error)")
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
    
    func putAnniversary(id: Int, parameters: RegisterAnniversaryRequest) async throws -> CreationResponse {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.editAnniversary(anniversaryId: id, parameter: parameters)) { result in
                switch result {
                case .success(let response):
                    print("=== DEBUG: \(response)")
                    do {
                        let creationResponse = try response.map(CreationResponse.self)
                        continuation.resume(returning: creationResponse)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    print("=== DEBUG: \(error)")
                    do {
                        let errorResponse = try error.response?.map(ErrorResponse.self)
                        continuation.resume(throwing: ServiceError.serverError(errorResponse ?? ErrorResponse(message: "에러메시지가 null")))
                    } catch {
                        continuation.resume(throwing: ServiceError.unknownError(error))
                    }
                }
            }
        }
    }
    
    func fetchAnniversaries() async throws -> AnniversariesResponse {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.readAnniversaries) { result in
                switch result {
                case let .success(response):
                    do {
                        let response = try response.map([AnniversaryDTO].self)
                        continuation.resume(returning: AnniversariesResponse(anniversaries: response))
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case let .failure(error):
                    print("=== DEBUG: \(error)")
                }
            }
        }
    }
    
    func fetchAnniversaryDetail(anniversaryId: Int) async throws -> AnniversaryDetailResponse {
        return try await withCheckedThrowingContinuation { continuation in
            print("=== DEBUG: fetch detail \(anniversaryId)")
            provider.request(.readAnniversary(anniversaryId: anniversaryId)) { result in
                switch result {
                case let .success(response):
                    do {
                        let response = try response.map(AnniversaryDetailDTO.self)
                        continuation.resume(returning: AnniversaryDetailResponse(anniversaryDetail: response))
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func deleteAnniversary(anniversaryId: Int) async throws {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(.deleteAnniversary(anniversaryId: anniversaryId)) { result in
                switch result {
                case .success:
                    continuation.resume()
                case let .failure(error):
                    print("=== DEBUG: \(error)")
                    continuation.resume()
                }
            }
        }
    }
    
    func changePushState(status: String) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            if let token = UserDefaults.standard.string(forKey: .fcmToken) {
                let request = ChangePushStateRequest(
                    token: token,
                    deviceUuid: Constants.uuid,
                    status: status
                )
                provider.request(.changePushState(parameter: request)) { result in
                    switch result {
                    case let .success(response):
                        do {
                            let response = try response.map(Int.self)
                            continuation.resume(returning: response)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    case let .failure(error):
                        print("=== DEBUG: changePushState \(error)")
                    }
                }
            }
        }
    }
    
    func fcmTest() async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            let request = TestRequest(deviceUuid: Constants.uuid, title: "하잉", body: "다연이지요")
            provider.request(.fcmTest(parameter: request)) { result in
                switch result {
                case let .success(response):
                    do {
                        let response = try response.map(Int.self)
                        continuation.resume(returning: response)
                        print("=== DEBUG: fcmTest() \(response)")
                    } catch {
                        continuation.resume(throwing: error)
                        print("=== DEBUG: fcmTest() \(error)")
                    }
                case let .failure(error):
                    print("=== DEBUG: failed fcmTest \(error.localizedDescription)")
                }
            }
        }
    }
}
