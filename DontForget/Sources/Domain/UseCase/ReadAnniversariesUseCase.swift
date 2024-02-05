//
//  ReadAnniversariesUseCase.swift
//  DontForget
//
//  Created by 제나 on 2/2/24.
//

import Foundation

protocol ReadAnniversariesUseCase {
    func execute(requestValue: ReadAnniversariesUseCaseRequestValue) async throws -> AnniversariesResponse?
}

struct ReadAnniversariesUseCaseRequestValue {
    let query: AnniversaryQuery
}

final class DefaultReadAnniversariesUseCase: ReadAnniversariesUseCase {
    
    // MARK: - Properties
    private let anniversariesRepository: AnniversariesRepository
    
    init(anniversariesRepository: AnniversariesRepository) {
        self.anniversariesRepository = anniversariesRepository
    }
    
    func execute(requestValue: ReadAnniversariesUseCaseRequestValue) async throws -> AnniversariesResponse? {
        return try await anniversariesRepository.fetchAnniversaries(query: requestValue.query)
    }
}
