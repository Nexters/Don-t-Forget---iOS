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
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(hex: 0x212529),
                        Color(hex: 0x0E1317)
                    ],
                    startPoint: .top,
                    endPoint: .center
                )
                if showingSplash {
                    SplashView()
                        .onAppear(perform: actionWhileShowingSplash)
                } else {
                    HomeView()
                }
            }
            .ignoresSafeArea()
        }
    }
    
    private func actionWhileShowingSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring) {
                showingSplash = false
            }
        }
    }
}

#Preview {
    ContentView()
}
