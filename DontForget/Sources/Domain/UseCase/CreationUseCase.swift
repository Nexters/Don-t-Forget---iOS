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
    func registerAnniversary(
        deviceId: String,
        title: String,
        date: String,
        content: String,
        type: String,
        alarmSchedule: [String]
    ) async throws -> CreationResponse
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

    func registerAnniversary(
        deviceId: String,
        title: String,
        date: String,
        content: String,
        type: String,
        alarmSchedule: [String]
    ) async throws -> CreationResponse {
        return try await creationRepository.registerAnniversary(
            deviceId: deviceId,
            title: title,
            date: date,
            content: content,
            type: type,
            alarmSchedule: alarmSchedule
        )
    }
    
    // MARK: - Method to Model(Entity)
    func getAlarmPeriod() -> [AlarmPeriod] {
        return AlarmPeriod.allCases
    }
    
    func converToDate(type: ConvertDate, date: Date) async -> Date {
        switch type {
        case .solar:
            let lunarDate = try? lunarConverter.lunarDate(fromSolar: date)
            return lunarDate!.date
        case .lunar:
            let solarDate = try? solarConverter.solarDate(fromLunar: date)
            return solarDate!.date
        }
    }
}

