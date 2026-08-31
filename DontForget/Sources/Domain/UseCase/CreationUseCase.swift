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
    /// 컨버터가 내부 캐시를 동기화 없이 갱신하므로 동시 호출을 막습니다.
    private let conversionQueue = DispatchQueue(label: "com.dontforget.creationusecase.conversion")
    
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
    
    /// 변환 지원 범위(1000~2050년)를 벗어나면 입력값을 그대로 돌려줍니다.
    func converToDate(type: ConvertDate, date: Date) async -> Date {
        conversionQueue.sync { () -> Date in
            switch type {
            case .solar:
                return (try? lunarConverter.lunarDate(fromSolar: date))?.date ?? date
            case .lunar:
                return (try? solarConverter.solarDate(fromLunar: date))?.date ?? date
            }
        }
    }
}

