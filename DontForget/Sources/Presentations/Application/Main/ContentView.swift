//
//  ContentView.swift
//  DontForget
//
//  Created by 제나 on 1/17/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showingSplash = true
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(hex: 0x212529),
                    Color(hex: 0x0E1317)
                ],
                startPoint: .top,
                endPoint: .center
            )
            HomeView()
            if showingSplash {
                SplashView()
                    .onAppear(perform: actionWhileShowingSplash)
            }
        }
        .ignoresSafeArea()
    }
    
    private func actionWhileShowingSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            withAnimation {
                showingSplash = false
            }
        }
    }
}

#Preview {
    ContentView()
}
