//
//  AnniversaryDetailViewModel.swift
//  DontForget
//
//  Created by 제나 on 2/5/24.
//

import SwiftUI
import Combine

final class DefaultAnniversaryDetailViewModel: ViewModelType {
    
    // MARK: - Properties
    let anniversaryId: Int
    private var cancellables = Set<AnyCancellable>()
    @Published var state: State
    @Published var anniversaryDetail: AnniversaryDetailDTO?
    private let anniversaryDetailRepository: AnniversaryDetailRepository
    private let deletionRepository: DeletionRepository
    private let fetchAnniversaryDetailUseCase: FetchAnniversaryDetailUseCase
    private let deleteAnniversaryUseCase: DeleteAnniversaryUseCase
    
    enum Action {
        case fetchAnniversaryDetail
        case deleteAnniversary
    }
    
    enum State: Equatable {
        case idle
        case loading
        case success
        case failed(String)
        case deleted
    }
    
    init(
        anniversaryId: Int,
        anniversaryDetailRepository: AnniversaryDetailRepository,
        deletionRepository: DeletionRepository
    ) {
        self.state = .idle
        self.anniversaryId = anniversaryId
        self.anniversaryDetailRepository = anniversaryDetailRepository
        self.fetchAnniversaryDetailUseCase = DefaultFetchAnniversaryDetailUseCase(
            anniversaryDetailRepository: anniversaryDetailRepository
        )
        self.deletionRepository = deletionRepository
        self.deleteAnniversaryUseCase = DefaultDeleteAnniversaryUseCase(
            deletionRepository: deletionRepository
        )
    }
    
    // MARK: - Action
    func action(_ action: Action) {
        switch action {
        case .fetchAnniversaryDetail:
            fetchAnniversaryDetail()
        case .deleteAnniversary:
            deleteAnniversary()
        }
    }
    
    // MARK: - Method
    private func fetchAnniversaryDetail() {
        Future<AnniversaryDetailResponse?, Error> { promise in
            self.state = .loading
            Task {
                do {
                    let response = try await self.fetchAnniversaryDetailUseCase.execute(
                        requestValue: .init(
                            query: AnniversaryDetailQuery(
                                queryId: self.anniversaryId
                            )
                        )
                    )
                    promise(.success(response))
                } catch {
                    print("=== DEBUG: \(error)")
                    promise(.failure(error))
                    self.state = .failed("failed fetchAnniversaryDetail()")
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .sink { completion in
            if case .failure = completion {
                #warning("handling error")
            }
        } receiveValue: { [weak self] response in
            if let response = response {
                self?.anniversaryDetail = response.anniversaryDetail
                self?.state = .success
            }
        }
        .store(in: &cancellables)
    }
    
    private func deleteAnniversary() {
        Future<Bool, Error> { promise in
            self.state = .loading
            Task {
                do {
                    try await self.deleteAnniversaryUseCase.execute(
                        requestValue: .init(
                            query: AnniversaryDetailQuery(
                                queryId: self.anniversaryId
                            )
                        )
                    )
                    promise(.success(true))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .sink { completion in
            if case .failure = completion {
                #warning("handling error")
            }
        } receiveValue: { _ in
            self.state = .deleted
        }
        .store(in: &cancellables)
    }
}
