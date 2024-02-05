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
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ZStack {
                        /* Background */
                        Image(viewModel.anniversaries.count == 0 ? .homeBackgroundFull : .homeBackgroundHalf)
                            .resizable()
                            .scaledToFill()
                        
                        VStack {
                            /* Main Anniversary */
                            if let firstAnniversary = viewModel.anniversaries.first {
                                NavigationLink {
                                    AnniversaryDetailView(
                                        viewModel: DefaultAnniversaryDetailViewModel(
                                            anniversaryId: firstAnniversary.anniversaryId,
                                            anniversaryDetailRepository: AnniversaryDetailRepository(
                                                service: AnniversaryService.shared
                                            )
                                        )
                                    )
                                } label: {
                                    if let firstAnniversaryDetail = viewModel.firstAnniversaryDetail {
                                        AnniversaryContentView(anniversary: firstAnniversaryDetail)
                                    }
                                }
                            } else {
                                LazyVGrid(columns: columns, content: {
                                    AddNewAnniversaryView()
                                        .padding(.leading, 24)
                                        .padding(.bottom, 510)
                                })
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
                                    NavigationLink {
                                        CreationUIView(
                                            viewModel: CreationViewModel(
                                                creationUseCase: CreationUseCase(
                                                    creationRepository: CreationRepository(service: AnniversaryService.shared)
                                                )
                                            )
                                        )
                                    } label: {
                                        AddNewAnniversaryView()
                                    }
                                } else {
                                    NavigationLink {
                                        AnniversaryDetailView(
                                            viewModel: DefaultAnniversaryDetailViewModel(
                                                anniversaryId: anniversaries[index].anniversaryId,
                                                anniversaryDetailRepository: AnniversaryDetailRepository(
                                                    service: AnniversaryService.shared
                                                )
                                            )
                                        )
                                    } label: {
                                        GridView(anniversary: anniversaries[index])
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 28)
                    
                    Spacer()
                        .frame(height: 30)
                }
                .onAppear {
                    viewModel.action(.readAnniversaries)
                }
            }
            .background(
                LinearGradient(
                    colors: [
                        Color(hex: 0x212529),
                        Color(hex: 0x0E1317)
                    ],
                    startPoint: .top,
                    endPoint: .center
                )
            )
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
