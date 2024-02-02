//
//  AnniversariesRepository.swift
//  DontForget
//
//  Created by 제나 on 2/2/24.
//

import Foundation

final class AnniversariesRepository: AnniversariesInterface {
    
    private let service: AnniversaryService
    
    init(service: AnniversaryService) {
        self.service = service
    }
    
    func fetchAnniversaries(query: AnniversaryQuery) async throws -> AnniversariesResponse {
        return try await service.fetchAnniversaries()
    }
}
