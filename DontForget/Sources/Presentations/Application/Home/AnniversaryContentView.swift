//
//  AnniversaryContentView.swift
//  DontForget
//
//  Created by 제나 on 1/30/24.
//

import SwiftUI

struct AnniversaryContentView: View {
    
    let anniversary: Anniversary
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("2024.2.24")
                    .foregroundStyle(Color.gray600)
                    .font(.system(size: 18))
                Text("D-31")
                    .font(.system(size: 72, weight: .bold))
                    .foregroundStyle(Color.primary500)
                Spacer()
                    .frame(height: 20)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(anniversary.title)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                    Text(anniversary.note)
                        .font(.system(size: 16))
                        .foregroundStyle(Color.gray600)
                }
                .padding(.horizontal, 16)
                .overlay(
                    Rectangle()
                        .frame(
                            width: 2.5,
                            height: nil
                        )
                        .foregroundColor(Color.primary500),
                    alignment: .leading
                )
                .padding(.leading, 4)
            }
            Spacer()
        }
        .padding(.horizontal, 36)
        .padding(.bottom, 259)
    }
}

#Preview {
    AnniversaryContentView(anniversary: Anniversary.dummy)
}
