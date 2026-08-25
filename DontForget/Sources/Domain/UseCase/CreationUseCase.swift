//
//  CreationUseCase.swift
//  DontForget
//
//  Created by 최지철 on 1/29/24.
//

import Foundation
import Combine /// 비동기처리가 필요없는 모델(엔티티)를 이용한 비지니스 로직을 위해 import 했숨당

import KoreanLunarSolarConverter

protocol CreationUseCaseProtocol {
    func registerAnniversary(request: RegisterAnniversaryRequest) async throws -> CreationResponse
    func putAnniversary(id: Int, parameters: RegisterAnniversaryRequest) async throws -> CreationResponse
    func getAlarmPeriod() -> [AlarmPeriod]
    func converToDate(type: ConvertDate, date: Date) async -> Date
}

final class CreationUseCase: CreationUseCaseProtocol {
    
    // MARK: - Properties
    private let creationRepository: CreationInterface
    private let solarConverter =  KoreanLunarToSolarConverter()
    private let lunarConverter = KoreanSolarToLunarConverter()
    
    // MARK: - Init
    init(creationRepository: CreationInterface) {
        self.creationRepository = creationRepository
    }
    
    // MARK: - Method to Network

    func registerAnniversary(request: RegisterAnniversaryRequest) async throws -> CreationResponse {
        return try await creationRepository.registerAnniversary(request: request)
    }
    
    func putAnniversary(id: Int, parameters: RegisterAnniversaryRequest) async throws -> CreationResponse {
        return try await creationRepository.putAnniversary(id: id, parameters: parameters)
    }
    
    // MARK: - Method to Model(Entity)
    func getAlarmPeriod() -> [AlarmPeriod] {
        return AlarmPeriod.allCases
    }
    
    /// 화면에 표시할 달력 기준으로 날짜를 변환합니다.
    /// type은 "이 날짜를 무엇으로 볼 것인가"이므로, 원본은 그 반대 기준의 날짜입니다.
    /// 변환할 수 없는 날짜(지원 범위 밖)는 입력값을 그대로 돌려줍니다.
    func converToDate(type: ConvertDate, date: Date) async -> Date {
        switch type {
        case .solar:
            /// 음력으로 보고 있던 날짜를 양력으로 바꿉니다.
            return (try? solarConverter.solarDate(fromLunar: date))?.date ?? date
        case .lunar:
            /// 양력으로 보고 있던 날짜를 음력으로 바꿉니다.
            return (try? lunarConverter.lunarDate(fromSolar: date))?.date ?? date
        }
    }
}

