//
//  GridView.swift
//  DontForget
//
//  Created by 제나 on 1/23/24.
//

import SwiftUI

struct GridView: View {
    
    let anniversary: Anniversary
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(anniversary.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(anniversary.cardType == 2 ? Color.gray900: .gray50)
                Text("D-81")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle([0, 1, 2].contains(anniversary.cardType) ? Color.primary500 : anniversary.cardType == 3 ? .gray50 : .yellow500)
                Spacer(minLength: 30)
                Text("24.2.13")
                    .font(.system(size: 16))
                    .foregroundStyle(anniversary.cardType == 2 ? Color.primary700 : .white)
                    .opacity(0.5)
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 20)
            Spacer()
        }
        .background(
            ZStack {
                Color(hex: 0x181E23)
                    .ignoresSafeArea()
                switch anniversary.cardType {
                case 1:
                    Image(.cardBackground1)
                        .resizable()
                        .scaledToFill()
                case 2:
                    Color(hex: 0xD3E3F0)
                    Image(.cardBackground2)
                        .resizable()
                        .scaledToFill()
                case 3:
                    Color.primary500
                    Image(.cardBackground3)
                        .resizable()
                        .scaledToFill()
                case 4:
                    Image(.cardBackground4)
                        .resizable()
                        .scaledToFill()
                default:
                    Image(.cardBackground5)
                        .resizable()
                        .scaledToFill()
                }
            }
                .clipShape(RoundedRectangle(cornerRadius: 16))
        )
    }
}

#Preview {
    GridView(
        anniversary: Anniversary.dummy.first!
    )
    .frame(width: 183, height: 183)
}
