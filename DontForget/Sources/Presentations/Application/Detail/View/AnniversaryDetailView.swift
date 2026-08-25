//
//  DetailView.swift
//  DontForget
//
//  Created by 제나 on 1/30/24.
//

import SwiftUI

struct AnniversaryDetailView: View {
    
    @State private var showEditView = false
    @Environment(\.dismiss) private var dismiss
    @State private var showConfirmView = false
    @ObservedObject var viewModel: DefaultAnniversaryDetailViewModel
    
    var body: some View {
        ZStack {
            /* Background */
            Image(.splashBackground)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack {
                Spacer()
                LottieView.lottieInDetailView
            }
            .ignoresSafeArea()
            /// 네비게이션 바가 차지하는 만큼 아래에서 시작해야 하므로 safe area를 그대로 둡니다.
            VStack {
                if let detail = viewModel.anniversaryDetail {
                    AnniversaryContentView(anniversary: detail)
                        .padding(.bottom, 200)
                }
            }
            if viewModel.state == .loading {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                ProgressView()
            }
            if showConfirmView {
                ConfirmView(
                    viewModel: viewModel,
                    alertType: .deleteAnniversary,
                    isPresentend: $showConfirmView,
                    dismiss: dismiss
                )
                .ignoresSafeArea()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showEditView = true
                } label: {
                    Image(.editIcon)
                        .foregroundColor(.white)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showConfirmView = true
                } label: {
                    Image(.deleteIcon)
                        .foregroundColor(.white)
                }
            }
        }
        /// 배경 이미지가 상단까지 이어지도록 바를 투명하게 둡니다.
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .navigationDestination(isPresented: $showEditView) {
            CreationView(
                viewModel: CreationViewModel(
                    creationUseCase: CreationUseCase(
                        creationRepository: CreationRepository(
                            service: LocalAnniversaryService.shared
                        )
                    ),
                    fetchAnniversaryDetailUseCase: DefaultFetchAnniversaryDetailUseCase(
                        anniversaryDetailRepository: AnniversaryDetailRepository(
                            service: LocalAnniversaryService.shared
                        )
                    )
                ),
                id: viewModel.anniversaryId,
                type: .edit
            )
        }
        .onAppear {
            viewModel.action(.fetchAnniversaryDetail)
        }
        .onReceive(viewModel.viewDismissalModePublisher) { shouldDismiss in
            if shouldDismiss {
                withAnimation {
                    dismiss()
                }
            }
        }
    }
}
