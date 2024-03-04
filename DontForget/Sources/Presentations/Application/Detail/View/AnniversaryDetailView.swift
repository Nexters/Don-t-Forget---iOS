//
//  DetailView.swift
//  DontForget
//
//  Created by 제나 on 1/30/24.
//

import SwiftUI

struct AnniversaryDetailView: View {
    
    private enum HeaderIcon {
        case back
        case edit
        case delete
    }
    
    @State private var showEditView = false
    @Environment(\.dismiss) private var dismiss
    @State private var iconStates = [
        HeaderIcon.back: false,
        .edit: false,
        .delete: false
    ]
    @State private var showConfirmView = false
    @ObservedObject var viewModel: DefaultAnniversaryDetailViewModel
    
    var body: some View {
        ZStack {
            /* Background */
            Image(.splashBackground)
                .resizable()
                .scaledToFill()
            VStack {
                Spacer()
                LottieView.lottieInDetailView
            }
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
                    id: viewModel.anniversaryId,
                    type: .edit
                ),
                isActive: $showEditView
            ) { EmptyView() }
            VStack {
                /* Custom Navigation Bar */
                HStack(spacing: 0) {
                    /* back icon */
                    Image(.backIcon)
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .padding(12)
                        .background {
                            if iconStates[.back]! {
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundStyle(Color.white.opacity(0.1))
                            }
                        }
                        .gesture(
                            DragGesture(
                                minimumDistance: 0,
                                coordinateSpace: .local
                            )
                            .onChanged({ _ in
                                iconStates[.back] = true
                            })
                            .onEnded({ _ in
                                iconStates[.back] = false
                                withAnimation {
                                    dismiss()
                                }
                            })
                        )
                    
                    Spacer()
                    /* edit icon */
                    Image(.editIcon)
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .padding(12)
                        .background {
                            if iconStates[.edit]! {
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundStyle(Color.white.opacity(0.1))
                            }
                        }
                        .gesture(
                            DragGesture(
                                minimumDistance: 0,
                                coordinateSpace: .local
                            )
                            .onChanged({ _ in
                                iconStates[.edit] = true
                            })
                            .onEnded({ _ in
                                iconStates[.edit] = false
                                self.showEditView = true
                            })
                        )
                    
                    /* delete icon */
                    Image(.deleteIcon)
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .padding(12)
                        .background {
                            if iconStates[.delete]! {
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundStyle(Color.white.opacity(0.1))
                            }
                        }
                        .gesture(
                            DragGesture(
                                minimumDistance: 0,
                                coordinateSpace: .local
                            )
                            .onChanged({ _ in
                                iconStates[.delete] = true
                            })
                            .onEnded({ _ in
                                iconStates[.delete] = false
                                showConfirmView = true
                            })
                        )
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                
                if let detail = viewModel.anniversaryDetail {
                    AnniversaryContentView(anniversary: detail)
                        .padding(.bottom, 200)
                }
            }
            if viewModel.state == .loading {
                Color.black.opacity(0.4)
                ProgressView()
            }
            if showConfirmView {
                ConfirmView(
                    viewModel: viewModel,
                    alertType: .deleteAnniversary,
                    isPresentend: $showConfirmView,
                    dismiss: dismiss
                )
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .gesture(
            DragGesture(
                minimumDistance: 10,
                coordinateSpace: .local
            )
            .onEnded({ value in
                if value.translation.width > 100 {
                    withAnimation {
                        dismiss()
                    }
                }
            })
        )
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
