//
//  AnniversaryDetailRepository.swift
//  DontForget
//
//  Created by 제나 on 2/5/24.
//

import Foundation

public final class AnniversaryDetailRepository: AnniversaryDetailInterface {

    private let service: AnniversaryServiceProtocol

    public init(service: AnniversaryServiceProtocol) {
        self.service = service
    }
    
    public func fetchAnniversaryDetail(query: AnniversaryDetailQuery) async throws -> AnniversaryDetailResponse {
        return try await service.fetchAnniversaryDetail(anniversaryId: query.queryId)
    }
}
