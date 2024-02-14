//
//  InputNameView.swift
//  DontForget
//
//  Created by 제나 on 2/14/24.
//

import SwiftUI

struct InputNameView: View {
    @Binding var name: String
    @FocusState private var isNameFieldFocused: Bool
    var viewModel: CreationViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text.coloredText("기념일 이름 *", coloredPart: "*", color: .red)
                .padding(.leading, 16)
                .padding(.bottom, 32)
                .foregroundColor(.white)
            TextField(
                "",
                text: $name,
                prompt: Text("사랑하는 엄마에게").foregroundColor(.gray700)
            )
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
            .frame(height: 46)
            .focused($isNameFieldFocused)
            .foregroundColor(.white)
            Rectangle()
                .padding(.horizontal, 20)
                .frame(height: 1)
                .foregroundColor(isNameFieldFocused ? Color.primary500 : Color.gray800)
                .onChange(of: name, { _, text in
                    self.viewModel.title = text
                })
        }
    }
}
