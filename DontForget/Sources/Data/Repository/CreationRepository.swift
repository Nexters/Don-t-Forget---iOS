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
    
    func registerAnniversary(request: RegisterAnniversaryRequest) async throws -> CreationResponse {
        return try await service.registerAnniversary(parameters: request)
    }
    
    func putAnniversary(id: Int, parameters: RegisterAnniversaryRequest) async throws -> CreationResponse {
        return try await service.putAnniversary(id: id, parameters: parameters)
    }
}
