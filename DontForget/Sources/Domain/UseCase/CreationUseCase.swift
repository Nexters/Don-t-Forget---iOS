//
//  CreationUseCase.swift
//  DontForget
//
//  Created by 최지철 on 1/29/24.
//

import Foundation
import Combine /// 비동기처리가 필요없는 모델(엔티티)를 이용한 비지니스 로직을 위해 import 했숨당

protocol CreationUseCaseProtocol {
    func registerAnniversary(request: AnniversaryRequestDTO) async throws -> CreationResponse
}
final class CreationUseCase: CreationUseCaseProtocol {
    // MARK: - Properties
    private let creationRepository: CreationInterface
    
    // MARK: - Init

    init(creationRepository: CreationInterface) {
        self.creationRepository = creationRepository
    }
    
    // MARK: - Method to Network

    func registerAnniversary(request: AnniversaryRequestDTO) async throws -> CreationResponse {
        return try await creationRepository.registerAnniversary(request: request)
    }
    
    // MARK: - Method to Model(Entity)
  
}

