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
    private var cancellables = Set<AnyCancellable>()
    @Published var state: State
    @Published var alarmPeriods: [AlarmPeriod] = []
    private let creationUseCase: CreationUseCaseProtocol
    @Published var convertedDate: Date?
    @Published var creationResponse: CreationResponse?
    @Published var errorMessage: String?
    
    @Published var title: String?
    @Published var date: String?
    @Published var content: String = ""
    @Published var calendarType: String = ""
    @Published var cardType: String = ""
    @Published var alarmSchedule: [String] = []

    // MARK: - Types
    
    enum Action {
        case registerAnniversary(parameters: RegisterAnniversaryRequest)
    }
    enum State {
        case idle
        case loading
        case success
        case failed(String)
    }
    
    // MARK: - Init
    
    init(creationUseCase: CreationUseCaseProtocol) {
        self.creationUseCase = creationUseCase
        self.state = .idle
        self.alarmPeriods = creationUseCase.getAlarmPeriod()
    }
    
    // MARK: - Action
    
    func action(_ action: Action) {
        switch action {
        case .registerAnniversary(parameters: let parameters):
            self.registerAnniversary(request: parameters)
        }
    }
    
    // MARK: - Method
    
    func registerAnniversary(request: RegisterAnniversaryRequest) {
        Future<CreationResponse?, Error> { promise in
            Task {
                do {
                    let response = try await self.creationUseCase.registerAnniversary(request: request)
                    promise(.success(response))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { completion in
            if case let .failure(error) = completion {
                self.errorMessage = error.localizedDescription
            }
        }, receiveValue: { [weak self] response in
            self?.creationResponse = response
        })
        .store(in: &cancellables)
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
    
    func convertToLunarOrSolar(type: ConvertDate, date: Date) async -> [Int] {
        let convertedDate = await creationUseCase.converToDate(type: type, date: date)
        let calendar = Calendar.current
        let year = calendar.component(.year, from: convertedDate)
        let month = calendar.component(.month, from: convertedDate)
        let day = calendar.component(.day, from: convertedDate)
        DispatchQueue.main.async {
            self.date = "\(year)-\(month)-\(day)"
            print(self.date)
        }
        var calculateYear = 0
        if year >= 1925 && year <= 1999 {
            calculateYear = year - 1900
        } else if year >= 2000 && year <= 2024 {
            calculateYear = year - 2000
        }
        return [calculateYear, month, day]
    }
}
