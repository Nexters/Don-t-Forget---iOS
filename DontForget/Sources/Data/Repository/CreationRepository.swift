//
//  CreationRepository.swift
//  DontForget
//
//  Created by 최지철 on 1/29/24.
//

import Foundation

final class CreationRepository: CreationInterface {
    
    private let service: AnniversaryService
    
    init(service: AnniversaryService) {
        self.service = service
    }
    
    func registerAnniversary(deviceId: String, title: String, date: String, content: String, type: String, alarmSchedule: [String]) async throws -> CreationResponse {
        return try await service.registerAnniversary(deviceId: deviceId, title: title, date: date, content: content, type: type, alarmSchedule: alarmSchedule)
    }
}
