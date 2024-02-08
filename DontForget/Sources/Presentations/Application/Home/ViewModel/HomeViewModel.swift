//
//  HomeViewModel.swift
//  DontForget
//
//  Created by 제나 on 2/2/24.
//

import SwiftUI
import Combine

final class DefaultHomeViewModel: ViewModelType {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    @Published var state: State
    @Published var firstAnniversaryDetail: AnniversaryDetailDTO?
    @Published var anniversaries: [AnniversaryDTO]
    private let readAnniversariesUseCase: ReadAnniversariesUseCase
    private let fetchFirstAnniversaryDetailUseCase: FetchAnniversaryDetailUseCase
    
    enum Action {
        case readAnniversaries
    }
    
    enum State {
        case idle
        case loading
        case success
        case failed(String)
    }
    
    init(readAnniversariesUseCase: ReadAnniversariesUseCase) {
        self.state = .idle
        self.anniversaries = []
        self.readAnniversariesUseCase = readAnniversariesUseCase
        self.fetchFirstAnniversaryDetailUseCase = DefaultFetchAnniversaryDetailUseCase(
            anniversaryDetailRepository: AnniversaryDetailRepository(
                service: AnniversaryService.shared
            )
        )
    }
    
    // MARK: - Action
    func action(_ action: Action) {
        switch action {
        case .readAnniversaries:
            readAnniversaries()
        }
    }
    
    // MARK: - Method
    private func readAnniversaries() {
        self.state = .loading
        Future<AnniversariesResponse?, Error> { promise in
            Task {
                do {
                    let response = try await self.readAnniversariesUseCase.execute(
                        requestValue: .init(
                            query: AnniversaryQuery(
                                query: Constants.uuid
                            )
                        )
                    )
                    promise(.success(response))
                } catch {
                    print("=== DEBUG: \(error)")
                    promise(.failure(error))
                    self.state = .failed("failed readAnniversaries()")
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .sink { completion in
            if case .failure = completion {
                #warning("handling error")
            }
        } receiveValue: { [weak self] response in
            if let self = self, let response = response {
                // TODO: - Sort anniversaries by date
                self.anniversaries = response.anniversaries
                print("=== DEBUG: \(self.anniversaries)")
                if !self.anniversaries.isEmpty {
                    self.fetchFirstAnniversaryDetail(anniversaryId: self.anniversaries.first!.anniversaryId)
                }
                self.state = .success
            }
        }
        .store(in: &cancellables)
    }
    
    private func fetchFirstAnniversaryDetail(anniversaryId: Int) {
        Future<AnniversaryDetailResponse?, Error> { promise in
            Task {
                do {
                    let response = try await self.fetchFirstAnniversaryDetailUseCase.execute(
                        requestValue: .init(
                            query: AnniversaryDetailQuery(
                                queryId: anniversaryId
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
        .sink { completion in
            if case .failure = completion {
                #warning("handling error")
            }
        } receiveValue: { [weak self] response in
            if let response = response {
                self?.firstAnniversaryDetail = response.anniversaryDetail
            }
        }
        .store(in: &cancellables)
    }
}
