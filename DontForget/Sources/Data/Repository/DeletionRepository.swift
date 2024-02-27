//
//  DeletionRepository.swift
//  DontForget
//
//  Created by 제나 on 2/27/24.
//

import Foundation

final class DeletionRepository: DeletionInterface {
    
    private let service: AnniversaryService
    
    init(service: AnniversaryService) {
        self.service = service
    }
    
    func deleteAnniversary(query: AnniversaryDetailQuery) async throws {
        try await service.deleteAnniversary(anniversaryId: query.queryId)
    }
}
