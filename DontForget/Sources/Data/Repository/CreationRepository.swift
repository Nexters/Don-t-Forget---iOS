//
//  CreationRepository.swift
//  DontForget
//
//  Created by 최지철 on 1/29/24.
//

import Foundation

public final class CreationRepository: CreationInterface {

    private let service: AnniversaryServiceProtocol

    public init(service: AnniversaryServiceProtocol) {
        self.service = service
    }
    
    public func registerAnniversary(request: RegisterAnniversaryRequest) async throws -> CreationResponse {
        return try await service.registerAnniversary(parameters: request)
    }

    public func putAnniversary(id: Int, parameters: RegisterAnniversaryRequest) async throws -> CreationResponse {
        return try await service.putAnniversary(id: id, parameters: parameters)
    }
}
