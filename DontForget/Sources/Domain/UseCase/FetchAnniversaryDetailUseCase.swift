//
//  FetchAnniversaryDetailUseCase.swift
//  DontForget
//
//  Created by 제나 on 2/5/24.
//

import Foundation

protocol FetchAnniversaryDetailUseCase {
    func execute(requestValue: FetchAnniversaryDetailUseCaseRequestValue) async throws -> AnniversaryDetailResponse
}

struct FetchAnniversaryDetailUseCaseRequestValue {
    let query: AnniversaryDetailQuery
}

final class DefaultFetchAnniversaryDetailUseCase: FetchAnniversaryDetailUseCase {
    
    // MARK: - Properties
    private let anniversaryDetailRepository: AnniversaryDetailRepository
    
    init(anniversaryDetailRepository: AnniversaryDetailRepository) {
        self.anniversaryDetailRepository = anniversaryDetailRepository
    }
    
    func execute(requestValue: FetchAnniversaryDetailUseCaseRequestValue) async throws -> AnniversaryDetailResponse {
        return try await anniversaryDetailRepository.fetchAnniversaryDetail(query: requestValue.query)
    }
}
