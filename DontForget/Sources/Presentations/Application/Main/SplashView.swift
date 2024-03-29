//
//  SplashView.swift
//  DontForget
//
//  Created by 제나 on 1/26/24.
//

import SwiftUI

import Lottie

struct SplashView: View {
    var body: some View {
        ZStack {
            Image(.splashBackground)
                .resizable()
                .scaledToFill()
            LottieView(name: .splashLottie)
        }
    }
}

#Preview {
    SplashView()
}
