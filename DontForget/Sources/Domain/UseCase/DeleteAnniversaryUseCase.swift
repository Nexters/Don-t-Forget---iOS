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
    private let deletionRepository: DeletionRepository
    
    init(deletionRepository: DeletionRepository) {
        self.deletionRepository = deletionRepository
    }
    
    func execute(requestValue: DeleteAnniversaryUseCaseRequestValue) async throws {
        try await deletionRepository.deleteAnniversary(query: requestValue.query)
    }
}
