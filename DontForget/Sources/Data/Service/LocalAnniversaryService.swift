//
//  LocalAnniversaryService.swift
//  DontForget
//
//  Created by 제나 on 8/20/24.
//

import Foundation

class LocalAnniversaryService: AnniversaryServiceProtocol {
    static let shared = LocalAnniversaryService()
    private let storage = LocalAnniversaryStorage.shared
    private let idGenerator = AnniversaryIdGenerator.shared

    func registerAnniversary(parameters: RegisterAnniversaryRequest) async throws -> CreationResponse {
        let newId = idGenerator.generateId()
        let detail = AnniversaryDetailDTO(
            anniversaryId: newId,
            title: parameters.title,
            lunarDate: parameters.date,
            solarDate: parameters.date,
            alarmSchedule: parameters.alarmSchedule,
            content: parameters.content,
            deviceId: Constants.uuid,
            cardType: parameters.cardType,
            baseDate: parameters.date,
            baseType: parameters.calendarType
        )
        try storage.save(anniversary: detail)
        return CreationResponse()
    }

    func putAnniversary(id: Int, parameters: RegisterAnniversaryRequest) async throws -> CreationResponse {
        let detail = AnniversaryDetailDTO(
            anniversaryId: id,
            title: parameters.title,
            lunarDate: parameters.date,
            solarDate: parameters.date,
            alarmSchedule: parameters.alarmSchedule,
            content: parameters.content,
            deviceId: Constants.uuid,
            cardType: parameters.cardType,
            baseDate: parameters.date,
            baseType: parameters.calendarType
        )
        try storage.save(anniversary: detail)
        return CreationResponse()
    }

    func fetchAnniversaries() async throws -> AnniversariesResponse {
        let details = try storage.loadAll()
        let dtos = details.map { detail -> AnniversaryDTO in
            AnniversaryDTO(
                anniversaryId: detail.anniversaryId,
                title: detail.title,
                lunarDate: detail.lunarDate,
                solarDate: detail.solarDate,
                cardType: detail.cardType
            )
        }
        return AnniversariesResponse(anniversaries: dtos)
    }

    func fetchAnniversaryDetail(anniversaryId: Int) async throws -> AnniversaryDetailResponse {
        let detail = try storage.load(id: anniversaryId)
        return AnniversaryDetailResponse(anniversaryDetail: detail)
    }

    func deleteAnniversary(anniversaryId: Int) async throws {
        try storage.delete(id: anniversaryId)
    }

    func changePushState(status: String) async throws -> Int {
        return 200
    }

    func fcmTest() async throws -> Int {
        return 200
    }
}
