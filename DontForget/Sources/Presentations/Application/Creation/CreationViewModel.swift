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
    private let creationUseCase: CreationUseCaseProtocol
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
        self.creationUseCase = creationUseCse
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
                let request = try await creationUseCase.registerAnniversary(request: requestDTO)
                state = .success
            } catch {
                state = .failed(error.localizedDescription)
            }
        }
    }
    
    func updateConvertedDate(day: Int, month: Int, year: Int) -> Date {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year =  year
        dateComponents.month = month
        dateComponents.day = day
        self.convertedDate = calendar.date(from: dateComponents)
        return convertedDate!
    }
    
    func convertToLunarOrSolar(type: convertDate, date: Date) async -> [Int] {
        let convertedDate = await creationUseCase.converToDate(type: type, date: date)
        let calendar = Calendar.current
        let year = calendar.component(.year, from: convertedDate)
        let month = calendar.component(.month, from: convertedDate)
        let day = calendar.component(.day, from: convertedDate)
        var calculateYear = 0
        if year >= 1925 && year <= 1999 {
            calculateYear = year - 1900
        } else if year >= 2000 && year <= 2024 {
            calculateYear = year - 2000
        }
        return [calculateYear, month, day]
    }
}
