//
//  GridView.swift
//  DontForget
//
//  Created by 제나 on 1/23/24.
//

import SwiftUI

struct GridView: View {
    
    let cardType: Int
    let anniversary: Anniversary
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(anniversary.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(cardType == 2 ? Color.gray900: .gray50)
                Text("D-81")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle([0, 1, 2].contains(cardType) ? Color.primary500 : cardType == 3 ? .gray50 : .yellow500)
                Spacer(minLength: 30)
                Text("24.2.13")
                    .font(.system(size: 16))
                    .foregroundStyle(cardType == 2 ? Color.primary700 : .white)
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
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                switch cardType {
                case 1:
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.primary500, lineWidth: 1.5)
                case 2:
                    Color(hex: 0xD3E3F0)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    VStack {
                        Spacer()
                        Image(.cardType1Background)
                            .resizable()
                            .scaledToFit()
                    }
                case 3:
                    Color.primary600
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                case 4:
                    HStack {
                        Spacer()
                        Image(.cardType3Background)
                    }
                default:
                    Color.clear
                }
            }
        )
    }
}

#Preview {
    GridView(
        cardType: 4,
        anniversary: Anniversary.dummy
    )
}
