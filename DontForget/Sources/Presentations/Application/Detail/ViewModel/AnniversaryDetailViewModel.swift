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
    private let fetchAnniversaryDetailUseCase: FetchAnniversaryDetailUseCase
    
    enum Action {
        case fetchAnniversaryDetail
    }
    
    enum State {
        case idle
        case loading
        case success
        case failed(String)
    }
    
    init(
        anniversaryId: Int,
        fetchAnniversaryDetailUseCase: FetchAnniversaryDetailUseCase
    ) {
        self.state = .idle
        self.anniversaryId = anniversaryId
        self.fetchAnniversaryDetailUseCase = fetchAnniversaryDetailUseCase
    }
    
    // MARK: - Action
    func action(_ action: Action) {
        switch action {
        case .fetchAnniversaryDetail:
            fetchAnniversaryDetail()
        }
    }
    
    // MARK: - Method
    private func fetchAnniversaryDetail() {
        self.state = .loading
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
}
