//
//  DeleteAnniversaryUseCase.swift
//  DontForget
//
//  Created by 제나 on 2/5/24.
//

import Foundation

protocol DeleteAnniversaryUseCase {
    func execute(requestValue: DeleteAnniversaryUseCaseRequestValue) async throws
}

struct DeleteAnniversaryUseCaseRequestValue {
    let query: AnniversaryDetailQuery
}

final class DefaultDeleteAnniversaryUseCase: DeleteAnniversaryUseCase {
    
    // MARK: - Properties
    private let anniversaryDetailRepository: AnniversaryDetailRepository
    
    init(anniversaryDetailRepository: AnniversaryDetailRepository) {
        self.anniversaryDetailRepository = anniversaryDetailRepository
    }
    
    func execute(requestValue: DeleteAnniversaryUseCaseRequestValue) async throws {
        try await anniversaryDetailRepository.deleteAnniversary(query: requestValue.query)
    }
}
