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
    private var isLoadingAnniversaryDetail = false

    enum Action {
        case readAnniversaries
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
        .sink { [weak self] completion in
            self?.isLoadingAnniversaryDetail = false // 작업 완료 후 상태 업데이트
            if case .failure = completion {
                #warning("handling error")
            }
        } receiveValue: { [weak self] response in
            if let self = self, let response = response {
                // TODO: - Sort anniversaries by date
                self.anniversaries = response.anniversaries
                print("=== DEBUG: \(self.anniversaries)")
                if !self.anniversaries.isEmpty {
                    print(self.anniversaries.first!.anniversaryId)
                    self.fetchFirstAnniversaryDetail(anniversaryId: self.anniversaries.first!.anniversaryId)
                } else {
                    
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
                    print("쿼리ID\(anniversaryId)")
                    let response = try await self.fetchFirstAnniversaryDetailUseCase.execute(
                        requestValue: .init(
                            query: AnniversaryDetailQuery(
                                queryId: anniversaryId
                            )
                        )
                    )
                    print("뷰모델!!\(response)")
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
    
    private func changeStatus() {
        Future<Int, Error> { promise in
            Task {
                do {
                    let response = try await AnniversaryService.shared.changePushState(status: "ON")
                    promise(.success(response))
                } catch {
                    print("=== DEBUG: changeStatus \(error)")
                    promise(.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .sink { completion in
            if case .failure = completion {
                #warning("handling error")
            }
        } receiveValue: { response in
            print("=== DEBUG: fcm 발송 테스트 \(response)")
        }
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
        .sink { completion in
            if case .failure = completion {
                #warning("handling error")
            }
        } receiveValue: { response in
            print("=== DEBUG: fcmTest \(response)")
        }
        .store(in: &cancellables)
    }
}
