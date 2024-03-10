//
//  ConfirmView.swift
//  DontForget
//
//  Created by 제나 on 1/30/24.
//

import SwiftUI

enum AlertType {
    case cancelCreating
    case cancelEditing
    case deleteAnniversary
}

struct ConfirmView: View {
    
    let viewModel: any ViewModelType
    
    let alertType: AlertType
    @Binding var isPresentend: Bool
    
    /* This parameter is required if the AlertType is .cancelEditing */
    var dismiss: DismissAction?
    
    @State private var animationOffsetY = UIScreen.height
    
    var isConfirmToCancel: Bool {
        alertType == .cancelEditing || alertType == .cancelCreating
    }
    
    var confirmTitle: String {
        switch self.alertType {
        case .cancelEditing:
            return "기념일 수정을 취소할까요?"
        case .deleteAnniversary:
            return "기념일을 삭제할까요?"
        case .cancelCreating:
            return "기념일 만들기를 취소할까요?"
        }
    }
    
    var confirmDescription: String {
        switch alertType {
        case .cancelEditing:
            "수정 중이던 내용은\n저장되지 않고, 사라집니다."
        case .deleteAnniversary:
            "기념일을 삭제한 후에는\n되돌릴 수 없어요."
        case .cancelCreating:
            "만들고 있던 기념일은\n저장되지않고, 사라집니다."
        }
    }
    
    private func closeAction() {
        withAnimation(.easeIn(duration: 0.3)) {
            animationOffsetY = UIScreen.height
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isPresentend.toggle()
        }
    }
    
    private func dismissView() {
        if let dismiss = dismiss {
            dismiss.callAsFunction()
        }
    }
    
    private func cancelEditingAction() {
        dismissView()
    }
    
    private func deleteAnniversaryAction() {
        if viewModel is DefaultAnniversaryDetailViewModel {
            let viewModel = viewModel as! DefaultAnniversaryDetailViewModel
            viewModel.action(.deleteAnniversary)
            #warning("Need to check response code")
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
            VStack {
                Image(.calendarDeleteIcon)
                    .resizable()
                    .frame(width: 56, height: 56)
                    .padding(.top, 32)
                    .padding(.bottom, 24)
                Text(confirmTitle)
                    .font(.pretendard(.semiBold, size: 18))
                    .foregroundStyle(.white)
                    .padding(.bottom, 16)
                Text(confirmDescription)
                    .multilineTextAlignment(.center)
                    .font(.pretendard(.regular, size: 16))
                    .foregroundStyle(Color.gray600)
                    .padding(.bottom, 28)
                
                Rectangle()
                    .frame(width: nil, height: 1)
                    .foregroundStyle(Color.gray800)
                    .padding(0)
                
                /* Action Buttons */
                HStack(spacing: 0) {
                    Button {
                        closeAction()
                    } label: {
                        Text("닫기")
                            .font(.pretendard(size: 16))
                            .foregroundStyle(Color.gray600)
                            .padding(.trailing, 60)
                            .padding(.bottom, 5)
                    }
                    
                    Rectangle()
                        .frame(width: 1, height: 50)
                        .foregroundStyle(Color.gray800)
                        .offset(y: -3)
                    Button {
                        isConfirmToCancel ? cancelEditingAction() : deleteAnniversaryAction()
                    } label: {
                        Text(isConfirmToCancel ? "취소" : "삭제")
                            .font(.pretendard(size: 16))
                            .foregroundStyle(isConfirmToCancel ? Color.primary500 : .red500)
                            .padding(.leading, 60)
                            .padding(.bottom, 5)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.gray900)
            .clipShape(
                RoundedRectangle(cornerRadius: 8)
            )
            .padding(.horizontal, 45)
            .offset(y: animationOffsetY)
            .onAppear {
                withAnimation(Animation.spring()) {
                    animationOffsetY = 0
                }
            }
        }
        .ignoresSafeArea()
    }
}
