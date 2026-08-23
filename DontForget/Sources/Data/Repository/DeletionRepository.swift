//
//  DeletionRepository.swift
//  DontForget
//
//  Created by 제나 on 2/27/24.
//

import Foundation

public final class DeletionRepository: DeletionInterface {

    private let service: AnniversaryServiceProtocol

    public init(service: AnniversaryServiceProtocol) {
        self.service = service
    }
    
    public func deleteAnniversary(query: AnniversaryDetailQuery) async throws {
        try await service.deleteAnniversary(anniversaryId: query.queryId)
    }
}
