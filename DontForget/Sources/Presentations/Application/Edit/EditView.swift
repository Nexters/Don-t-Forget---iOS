//
//  EditView.swift
//  DontForget
//
//  Created by 최지철 on 2/9/24.
//

import SwiftUI

struct EditView: View {
    var body: some View {
        CreationView(viewModel: CreationViewModel(creationUseCase: CreationUseCase(creationRepository: CreationRepository(service: AnniversaryService()))))
    }
}

#Preview {
    EditView()
}
