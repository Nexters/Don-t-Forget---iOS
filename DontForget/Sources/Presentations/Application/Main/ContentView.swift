//
//  ContentView.swift
//  DontForget
//
//  Created by 제나 on 1/17/24.
//

import SwiftUI

struct ContentView: View {

    @State private var showingSplash = true
    @State private var showingLocalDataWarning = false

    var body: some View {
        ZStack {
            Color.bgColor
            HomeView()
            if showingSplash {
                SplashView()
                    .onAppear(perform: actionWhileShowingSplash)
            }
            if showingLocalDataWarning {
                LocalDataWarningView(onDismissed: {
                    showingLocalDataWarning = false
                })
            }
        }
        .ignoresSafeArea()
    }

    private func actionWhileShowingSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            withAnimation {
                showingSplash = false
            }
            checkLocalDataWarning()
        }
    }

    private func checkLocalDataWarning() {
        let defaults = UserDefaults.standard
        let isDismissed = defaults.bool(forKey: "localDataWarningDismissed")
        let appVersion = Bundle.main.appVersion
        let lastSeenVersion = defaults.string(forKey: "localDataWarningLastVersion") ?? ""

        if !isDismissed || lastSeenVersion != appVersion {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    showingLocalDataWarning = true
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
