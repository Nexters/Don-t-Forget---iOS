//
//  EditViewModel.swift
//  DontForget
//
//  Created by 최지철 on 2/9/24.
//

import SwiftUI
import Combine

final class EditViewModel: ViewModelType {
    
    private var cancellables = Set<AnyCancellable>()
    private let fetchAnniversaryDetailUseCase: FetchAnniversaryDetailUseCase
    @Published var anniversaryDetail: AnniversaryDetailDTO?
    @Published var state: State
    
    init(state: State, fetchAnniversaryDetailUseCase: FetchAnniversaryDetailUseCase) {
        self.state = state
        self.fetchAnniversaryDetailUseCase = fetchAnniversaryDetailUseCase
    }
    
    func action(_ action: Action) {
        
    }
    
    enum Action {
        
    }
    enum State {
        case idle
        case loading
        case success
        case failed(String)
    }
    
    private func fetchAnniversaryDetail(id: Int) {
        self.state = .loading
        Future<AnniversaryDetailResponse?, Error> { promise in
            Task {
                do {
                    let response = try await self.fetchAnniversaryDetailUseCase.execute(
                        requestValue: .init(
                            query: AnniversaryDetailQuery(
                                queryId: id
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
