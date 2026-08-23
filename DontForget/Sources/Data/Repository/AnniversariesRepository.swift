//
//  AnniversariesRepository.swift
//  DontForget
//
//  Created by 제나 on 2/2/24.
//

import Foundation

public final class AnniversariesRepository: AnniversariesInterface {

    private let service: AnniversaryServiceProtocol

    public init(service: AnniversaryServiceProtocol) {
        self.service = service
    }
    
    public func fetchAnniversaries(query: AnniversaryQuery) async throws -> AnniversariesResponse {
        return try await service.fetchAnniversaries()
    }
}
