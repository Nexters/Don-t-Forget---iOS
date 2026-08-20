//
//  AnniversaryDetailRepository.swift
//  DontForget
//
//  Created by 제나 on 2/5/24.
//

import Foundation

final class AnniversaryDetailRepository: AnniversaryDetailInterface {

    private let service: AnniversaryServiceProtocol

    init(service: AnniversaryServiceProtocol) {
        self.service = service
    }
    
    func fetchAnniversaryDetail(query: AnniversaryDetailQuery) async throws -> AnniversaryDetailResponse {
        return try await service.fetchAnniversaryDetail(anniversaryId: query.queryId)
    }
}
