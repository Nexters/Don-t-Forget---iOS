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
    @Published var anniversaries: [AnniversaryDTO]
    private let readAnniversariesUseCase: ReadAnniversariesUseCase
    
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
    }
    
    // MARK: - Action
    func action(_ action: Action) {
        switch action {
        case .readAnniversaries:
            readAnniversaries()
        }
    }
    
    #warning("TEST NEEDED")
    // MARK: - Method
    private func readAnniversaries() {
        Future<AnniversariesResponse?, Error> { promise in
            Task {
                do {
                    let response = try await self.readAnniversariesUseCase.execute(requestValue: .init(query: AnniversaryQuery(query: "deviceId")))
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
                self?.anniversaries = response.anniversaries
                print("=== DEBUG: \(self?.anniversaries)")
            }
        }
        .store(in: &cancellables)
    }
}
