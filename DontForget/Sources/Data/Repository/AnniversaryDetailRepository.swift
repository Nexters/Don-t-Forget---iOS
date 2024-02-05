//
//  AnniversaryDetailRepository.swift
//  DontForget
//
//  Created by 제나 on 2/5/24.
//

import Foundation

final class AnniversaryDetailRepository: AnniversaryDetailInterface {
    
    private let service: AnniversaryService
    
    init(service: AnniversaryService) {
        self.service = service
    }
    
    func fetchAnniversaryDetail(query: AnniversaryDetailQuery) async throws -> AnniversaryDetailResponse {
        return try await service.fetchAnniversaryDetail(anniversaryId: query.queryId)
    }
    
    func deleteAnniversary(query: AnniversaryDetailQuery) async throws {
        try await service.deleteAnniversary(anniversaryId: query.queryId)
    }
}
