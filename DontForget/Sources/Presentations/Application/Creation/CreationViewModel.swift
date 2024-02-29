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
    private let fetchAnniversaryDetailUseCase: FetchAnniversaryDetailUseCase
    @Published var anniversaryDetail: AnniversaryDetailDTO?
    @Published var title: String?
    @Published var date: String?
    @Published var content: String = ""
    @Published var calendarType: String = ""
    @Published var cardType: String = ""
    @Published var alarmSchedule: [String] = []
    @Published var getDate: [Int] = []
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    private var dismiss = false {
            didSet {
                viewDismissalModePublisher.send(dismiss)
            }
        }
    
    // MARK: - Types
    
    enum Action {
        case registerAnniversary(parameters: RegisterAnniversaryRequest)
        case editAnniversary(parameters: RegisterAnniversaryRequest, id: Int)
    }
    enum State {
        case idle
        case loading
        case success
        case failed(String)
    }
    
    // MARK: - Init
    
    init(
        creationUseCase: CreationUseCaseProtocol,
        fetchAnniversaryDetailUseCase: FetchAnniversaryDetailUseCase
    ) {
        self.creationUseCase = creationUseCase
        self.state = .idle
        self.fetchAnniversaryDetailUseCase = fetchAnniversaryDetailUseCase
        self.alarmPeriods = creationUseCase.getAlarmPeriod()
    }
    
    // MARK: - Action
    
    func action(_ action: Action) {
        switch action {
        case .registerAnniversary(parameters: let parameters):
            self.registerAnniversary(request: parameters)
        case .editAnniversary(parameters: let parameters, id: let id):
            self.editAnniversary(id: id, request: parameters)
        }
    }
    
    // MARK: - Method
    
    func registerAnniversary(request: RegisterAnniversaryRequest) {
        self.state = .loading
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
        .sink { completion in
            self.dismiss = true
            if case let .failure(error) = completion {
                self.errorMessage = error.localizedDescription
            }
        } receiveValue: { response in
            self.creationResponse = response
        }
        .store(in: &cancellables)
    }
    
    func editAnniversary(id: Int, request: RegisterAnniversaryRequest) {
        self.state = .loading
        Future<CreationResponse?, Error> { promise in
            Task {
                do {
                    _ = try await self.creationUseCase.putAnniversary(id: id, parameters: request)
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .sink { completion in
            self.dismiss = true
            if case let .failure(error) = completion {
                self.errorMessage = error.localizedDescription
                print("=== \(String(describing: self.errorMessage))")
            }
        } receiveValue: { response in
            self.creationResponse = response
        }
        .store(in: &cancellables)
    }
    
    func fetchAnniversaryDetail(id: Int) {
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
