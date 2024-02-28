//
//  GridView.swift
//  DontForget
//
//  Created by 제나 on 1/23/24.
//

import SwiftUI

struct GridView: View {
    
    let anniversary: AnniversaryDTO
    @State private var scale = 1.0
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(anniversary.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(anniversary.cardType == Anniversary.CardType.face.rawValue ? Color.gray900: .gray50)
                    .lineLimit(1)
                Text("D\(Constants.getDDay(anniversary.solarDate))")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(
                        [
                            Anniversary.CardType.lunar.rawValue,
                            Anniversary.CardType.face.rawValue,
                            Anniversary.CardType.forest.rawValue
                        ].contains(anniversary.cardType) ? Color.primary500 :
                            anniversary.cardType == Anniversary.CardType.arm.rawValue ? .gray50 : .yellow500
                    )
                Spacer(minLength: 30)
                Text(anniversary.solarDate.replacingOccurrences(of: "-", with: "."))
                    .font(.system(size: 16))
                    .foregroundStyle(anniversary.cardType == Anniversary.CardType.face.rawValue ? Color.primary700 : .white)
                    .opacity(0.5)
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 20)
            Spacer()
        }
        .frame(height: 183)
        .background(
            ZStack {
                Color(hex: 0x181E23)
                    .ignoresSafeArea()
                switch anniversary.cardType {
                case Anniversary.CardType.lunar.rawValue:
                    Image(.cardBackground1)
                        .resizable()
                        .scaledToFill()
                case Anniversary.CardType.face.rawValue:
                    Color(hex: 0xD3E3F0)
                    Image(.cardBackground2)
                        .resizable()
                        .scaledToFill()
                case Anniversary.CardType.arm.rawValue:
                    Color.primary500
                    Image(.cardBackground3)
                        .resizable()
                        .scaledToFill()
                case Anniversary.CardType.tail.rawValue:
                    Image(.cardBackground4)
                        .resizable()
                        .scaledToFill()
                default:
                    Image(.cardBackground5)
                        .resizable()
                        .scaledToFill()
                }
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .gesture(
            TapGesture()
                .onEnded({ _ in
                    withAnimation(.easeIn(duration: 0.1)) {
                        scale = 0.96
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            scale = 1.0
                        }
                    }
                })
        )
        .scaleEffect(scale)
    }
}
