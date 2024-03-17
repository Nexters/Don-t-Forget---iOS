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
    @Published var state: State = .idle
    @Published var anniversaryDetail: AnniversaryDetailDTO?
    private let anniversaryDetailRepository: AnniversaryDetailRepository
    private let deletionRepository: DeletionRepository
    private let fetchAnniversaryDetailUseCase: FetchAnniversaryDetailUseCase
    private let deleteAnniversaryUseCase: DeleteAnniversaryUseCase
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    private var dismiss = false {
            didSet {
                viewDismissalModePublisher.send(dismiss)
            }
        }
    
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
        if let cachedDetail = CacheManager.shared.loadDetail(self.anniversaryId) {
            self.anniversaryDetail = cachedDetail.dto
        } else {
            Future<AnniversaryDetailResponse?, Error> { promise in
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
                    }
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] response in
                if let response = response {
                    let detail = response.anniversaryDetail
                    print("=== DEBUG: fetch detail \(detail.anniversaryId)")
                    self?.anniversaryDetail = detail
                    CacheManager.shared.setDetail(AnniversaryDetail(anniversaryDetailDTO: detail))
                }
            }
            .store(in: &cancellables)
        }
    }
    
    private func deleteAnniversary() {
        Future<Bool, Error> { promise in
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
            self.dismiss = true
            if case .failure = completion {
                print("=== DEBUG: \(completion)")
            }
        } receiveValue: { _ in }
        .store(in: &cancellables)
    }
}
