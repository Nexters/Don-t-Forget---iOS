//
//  DontForgetApp.swift
//  DontForget
//
//  Created by 제나 on 1/17/24.
//

import SwiftUI
@main
struct DontForgetApp: App {
    var body: some Scene {
        WindowGroup {
            CreationUIView(viewModel: CreationViewModel(creationUseCse: CreationUseCase(creationRepository: CreationRepository(service: AnniversaryService()))))
        }
    }
}
