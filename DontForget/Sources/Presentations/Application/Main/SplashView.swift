//
//  SplashView.swift
//  DontForget
//
//  Created by 제나 on 1/26/24.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        Image(.splashBackground)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
}

#Preview {
    SplashView()
}
