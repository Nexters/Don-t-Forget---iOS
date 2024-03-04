//
//  HomeView.swift
//  DontForget
//
//  Created by 제나 on 1/17/24.
//

import SwiftUI

struct HomeView: View {
    
    private static let scrollTopView = "scrollTopView"
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
    private var networkConnected: Bool { NetworkMonitor.shared.isConnected }
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack {
                        ZStack {
                            /* Navigation Link with Empty View*/
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
                            } label: {
                                EmptyView()
                            }
                            
                            /* Background */
                            if anniversaries.isEmpty {
                                ZStack {
                                    Image(.splashBackground)
                                        .resizable()
                                        .scaledToFill()
                                    LottieView(
                                        name: .mainLottie,
                                        loopMode: .loop
                                    )
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 32))
                            }
                            /* Main Anniversary */
                            if anniversaries.first != nil {
                                ZStack {
                                    Image(.splashBackground)
                                        .resizable()
                                        .scaledToFill()
                                    LottieView(
                                        name: .mainLottie,
                                        loopMode: .loop
                                    )
                                    if let firstAnniversaryDetail = viewModel.firstAnniversaryDetail {
                                        AnniversaryContentView(anniversary: firstAnniversaryDetail)
                                            .padding(.top, 120)
                                    }
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 32))
                                .onTapGesture {
                                    if let firstAnniversaryDetail = viewModel.firstAnniversaryDetail,
                                    networkConnected {
                                        id = firstAnniversaryDetail.anniversaryId
                                        isNavigate = true
                                    }
                                }
                            } else {
                                LazyVGrid(columns: columns) {
                                    creationViewNavigationLink
                                        .padding(.leading, 24)
                                        .padding(.bottom, 510)
                                }
                            }
                        }
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
                                                        if networkConnected {
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                                id = anniversaries[index].anniversaryId
                                                                isNavigate = true
                                                            }
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
                    }
                    .offset(y: anniversaries.isEmpty ? 0 : -140)
                    .onAppear(perform: actionOnAppear)
                    .id(Self.scrollTopView)
                }
                .scrollDisabled(anniversaries.isEmpty)
                .background(
                    Image(.homeBackgroundWithNoise)
                        .resizable()
                        .scaledToFill()
                        .brightness(-0.01)
                )
                .ignoresSafeArea()
                .onChange(of: anniversaries) { _, anniversaries in
                    if anniversaries.isEmpty {
                        withAnimation {
                            proxy.scrollTo(Self.scrollTopView, anchor: .top)
                        }
                    }
                }
                .onChange(of: networkConnected) { _, status in
                    if status {
                        actionOnAppear()
                    }
                }
                .toolbar {
                    if !networkConnected {
                        ToolbarItem(placement: .status) {
                            Text("네트워크 연결이 없어요")
                                .font(.pretendard(size: 15))
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}

struct AddNewAnniversaryView: View {
    let gridWidth = (UIScreen.width - 60) / 2
    var body: some View {
        ZStack {
            Color(hex: 0x181E23)
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
                    .font(.pretendard(.semiBold, size: 18))
            }
            .padding(.horizontal, 20)
        }
        .frame(width: gridWidth, height: gridWidth)
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
        .disabled(!networkConnected)
    }
    
    private func actionOnAppear() {
        viewModel.action(.readAnniversaries)
        viewModel.action(.changePushState)
    }
}
