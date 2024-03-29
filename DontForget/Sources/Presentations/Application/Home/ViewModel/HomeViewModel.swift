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
    private let fetchAnniversaryDetailUseCase: FetchAnniversaryDetailUseCase
    
    enum Action {
        case readAnniversaries
        case fetchFirstAnniversaryDetail
        case changePushState
        case fcmTest
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
        self.fetchAnniversaryDetailUseCase = DefaultFetchAnniversaryDetailUseCase(
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
        case .fetchFirstAnniversaryDetail:
            fetchFirstAnniversaryDetail()
        case .changePushState:
            changeStatus()
        case .fcmTest:
            fcmTest()
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
        .sink { _ in } receiveValue: { [weak self] response in
            if let self = self, let response = response {
                self.anniversaries = response.anniversaries.sorted(by: { $0.solarDate < $1.solarDate })
                print("=== DEBUG: \(self.anniversaries)")
                self.state = .success
                if !self.anniversaries.isEmpty {
                    self.fetchFirstAnniversaryDetail()
                }
            }
        }
        .store(in: &cancellables)
    }
    
    private func fetchFirstAnniversaryDetail() {
        if let firstAnniversary = self.anniversaries.first {
            self.state = .loading
            Future<AnniversaryDetailResponse?, Error> { promise in
                Task {
                    do {
                        let response = try await self.fetchAnniversaryDetailUseCase.execute(
                            requestValue: .init(
                                query: AnniversaryDetailQuery(
                                    queryId: firstAnniversary.anniversaryId
                                )
                            )
                        )
                        promise(.success(response))
                    } catch {
                        print("=== DEBUG here: \(error) \n \(firstAnniversary)")
                        promise(.failure(error))
                    }
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] response in
                if let response = response {
                    self?.firstAnniversaryDetail = response.anniversaryDetail
                    self?.state = .success
                }
            }
            .store(in: &cancellables)
        }
    }
    
    private func changeStatus() {
        Future<Int, Error> { promise in
            Task {
                do {
                    var status = NotificationStatus.ON.rawValue
                    UNUserNotificationCenter.current().getNotificationSettings { settings in
                        switch settings.authorizationStatus {
                        case .notDetermined, .authorized: /// 한 번만 허용, 푸시 허용
                            status = NotificationStatus.ON.rawValue
                        default:
                            status = NotificationStatus.OFF.rawValue
                        }
                    }
                    let response = try await AnniversaryService.shared.changePushState(status: status)
                    print("=== DEBUG: changeStatus \(status)")
                    promise(.success(response))
                } catch {
                    print("=== DEBUG: changeStatus \(error)")
                    promise(.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .sink { _ in } receiveValue: { _ in }
        .store(in: &cancellables)
    }
    
    private func fcmTest() {
        Future<Int, Error> { promise in
            Task {
                do {
                    let response = try await AnniversaryService.shared.fcmTest()
                    promise(.success(response))
                } catch {
                    print("=== DEBUG: fcmTest \(error)")
                    promise(.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .sink { _ in } receiveValue: { response in
            print("=== DEBUG: fcmTest \(response)")
        }
        .store(in: &cancellables)
    }
}
