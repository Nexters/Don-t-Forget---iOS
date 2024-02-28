//
//  HomeView.swift
//  DontForget
//
//  Created by 제나 on 1/17/24.
//

import SwiftUI

struct HomeView: View {
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    @StateObject private var viewModel = DefaultHomeViewModel(
        readAnniversariesUseCase: DefaultReadAnniversariesUseCase(
            anniversariesRepository: AnniversariesRepository(
                service: AnniversaryService.shared
            )
        )
    )
    private var anniversaries: [AnniversaryDTO] {
        viewModel.anniversaries
    }
    @State private var navigateToCreationView = false
    @State private var isNavigate = false
    @State private var id = -1
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ZStack {
                        /* Background */
                        Image(viewModel.anniversaries.count == 0 ? .homeBackgroundFull : .homeBackgroundHalf)
                            .resizable()
                            .scaledToFill()
                        
                        NavigationLink(isActive: $isNavigate) {
                            AnniversaryDetailView(
                                viewModel: DefaultAnniversaryDetailViewModel(
                                    anniversaryId: id,
                                    anniversaryDetailRepository: AnniversaryDetailRepository(
                                        service: AnniversaryService.shared
                                    ),
                                    deletionRepository: DeletionRepository(
                                        service: AnniversaryService.shared
                                    )
                                )
                            )
                        } label: { EmptyView() }
                        
                        VStack {
                            /* Main Anniversary */
                            if let firstAnniversary = anniversaries.first {
                                ZStack {
                                    if let firstAnniversaryDetail = viewModel.firstAnniversaryDetail {
                                        AnniversaryContentView(anniversary: firstAnniversaryDetail)
                                            .onTapGesture {
                                                id = firstAnniversaryDetail.anniversaryId
                                                isNavigate = true
                                            }
                                    }
                                }
                                .onAppear {
                                    viewModel.action(.fetchFirstAnniversaryDetail)
                                }
                            } else {
                                LazyVGrid(columns: columns) {
                                    creationViewNavigationLink
                                        .padding(.leading, 24)
                                        .padding(.bottom, 510)
                                }
                            }
                        }
                        .padding(.top, Constants.topLayout)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 32))
                    
                    Spacer()
                    
                    LazyVGrid(
                        columns: columns,
                        spacing: 20
                    ) {
                        ForEach(1..<anniversaries.count + 1, id: \.self) { index in
                            if anniversaries.count > 0 {
                                if index == anniversaries.count {
                                    creationViewNavigationLink
                                } else {
                                    GridView(anniversary: anniversaries[index])
                                        .simultaneousGesture(
                                            TapGesture()
                                                .onEnded({
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                        id = anniversaries[index].anniversaryId
                                                        isNavigate = true
                                                    }
                                                })
                                        )
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 28)
                    
                    #if DEBUG
                    Button("FCM TEST") {
                        viewModel.action(.fcmTest)
                    }.buttonStyle(BorderedButtonStyle())
                    #endif
                    
                    Spacer()
                        .frame(height: 120)
                }
                .onAppear {
                    viewModel.action(.readAnniversaries)
                    viewModel.action(.changePushState)
                }
            }
            .background(Color.bgColor)
            .ignoresSafeArea()
        }
    }
}

#Preview {
    HomeView()
}

struct AddNewAnniversaryView: View {
    var body: some View {
        ZStack {
            Color(hex: 0x181E23)
                .opacity(0.4)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray700, lineWidth: 1.0)
            VStack(spacing: 12) {
                Image(.calendarAddOnIcon)
                    .resizable()
                    .frame(width: 56, height: 56)
                    .foregroundStyle(Color.gray500)
                Text("기념일 만들기")
                    .foregroundStyle(Color.gray400)
            }
            .padding(.horizontal, 20)
        }
        .frame(minHeight: 170)
    }
}

extension HomeView {
    var creationViewNavigationLink: some View {
        NavigationLink(
            destination: CreationView(
                viewModel: CreationViewModel(
                    creationUseCase: CreationUseCase(
                        creationRepository: CreationRepository(
                            service: AnniversaryService.shared
                        )
                    ),
                    fetchAnniversaryDetailUseCase: DefaultFetchAnniversaryDetailUseCase(
                        anniversaryDetailRepository: AnniversaryDetailRepository(
                            service: AnniversaryService.shared
                        )
                    )
                ),
                id: nil,
                type: .create
            ),
            isActive: $navigateToCreationView,
            label: { AddNewAnniversaryView() }
        )
    }
}
