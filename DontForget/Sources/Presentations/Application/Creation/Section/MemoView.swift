//
//  MemoView.swift
//  DontForget
//
//  Created by 제나 on 2/14/24.
//

import SwiftUI

struct MemoView: View {
    
    @Binding var memo: String
    @FocusState private var isMemoFieldFocused: Bool
    var viewModel: CreationViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("간단 메모")
                .font(.system(size: 19, weight: .semibold))
                .padding(.leading, 16)
                .padding(.bottom, 32)
                .foregroundColor(.white)
            TextField(
                "", 
                text: $memo,
                prompt: Text("가족 여행 미리 계획하기").foregroundColor(.gray700)
            )
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
            .frame(height: 46)
            .focused($isMemoFieldFocused)
            .foregroundColor(.white)
            Rectangle()
                .padding(.horizontal, 39)
                .frame(height: 1)
                .foregroundColor(isMemoFieldFocused ? Color.primary500 : Color.gray800)
        }
    }
}
