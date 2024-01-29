//
//  CreationViewModel.swift
//  DontForget
//
//  Created by 최지철 on 1/29/24.
//

import SwiftUI
import Combine

final class CreationViewModel: ViewModelType {
    
    // MARK: - Properties
    @Published var state: State
    @Published var alarmPeriods: [AlarmPeriod] = []
    private let creationUseCse: CreationUseCaseProtocol
    @Published var convertedDate: Date?

    // MARK: - Types
    enum Action {
        case registerAnniversary(AnniversaryRequestDTO)

    }
    enum State {
        case idle
        case loading
        case success
        case failed(String)
    }
    
    // MARK: - Init
    
    init(creationUseCse: CreationUseCaseProtocol) {
        self.creationUseCse = creationUseCse
        self.state = .idle
        self.alarmPeriods = creationUseCse.getAlarmPeriod()
    }
    
    // MARK: - Action
    func action(_ action: Action) {
        switch action {
        case .registerAnniversary(let requestDTO):
            registerAnniversary(requestDTO)
        }
    }
    
    // MARK: - Method
    
    func registerAnniversary(_ requestDTO: AnniversaryRequestDTO) {
        state = .loading
        Task {
            do {
                let request = try await creationUseCse.registerAnniversary(request: requestDTO)
                state = .success
            } catch {
                state = .failed(error.localizedDescription)
            }
        }
    }

}
