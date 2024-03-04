//
//  GridView.swift
//  DontForget
//
//  Created by 제나 on 1/23/24.
//

import SwiftUI

struct GridView: View {
    
    let gridWidth = (UIScreen.width - 60) / 2
    let anniversary: AnniversaryDTO
    @State private var scale = 1.0
    private var solarDate: String {
        let solarDate = anniversary.solarDate.replacingOccurrences(of: "-", with: ".")
        return String(solarDate[solarDate.index(solarDate.startIndex, offsetBy: 2)..<solarDate.endIndex])
    }
    private var dday: String {
        let dday = Constants.getDDay(anniversary.solarDate)
        if dday == 0 {
            return "D-DAY"
        } else if dday > 0 {
            return "D+\(dday)"
        } else {
            return "D\(dday)"
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(anniversary.title)
                    .font(.pretendard(.semiBold, size: 16))
                    .foregroundStyle(anniversary.cardType == CardType.face.rawValue ? Color.gray900: .gray50)
                    .lineLimit(1)
                Text(dday)
                    .font(.pretendard(.bold, size: 34))
                    .foregroundStyle(
                        [
                            CardType.lunar.rawValue,
                            CardType.face.rawValue,
                            CardType.forest.rawValue
                        ].contains(anniversary.cardType) ? Color.primary500 :
                            anniversary.cardType == CardType.arm.rawValue ? .gray50 : .yellow500
                    )
                Spacer(minLength: 30)
                Text(solarDate)
                    .font(.pretendard(.medium, size: 16))
                    .foregroundStyle(anniversary.cardType == CardType.face.rawValue ? Color.primary700 : .white)
                    .opacity(0.5)
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 20)
            Spacer()
        }
        .frame(width: gridWidth, height: gridWidth)
        .background(
            ZStack {
                Color(hex: 0x181E23)
                    .ignoresSafeArea()
                switch anniversary.cardType {
                case CardType.lunar.rawValue:
                    Image(.cardBackground1)
                        .resizable()
                        .scaledToFill()
                case CardType.face.rawValue:
                    Color(hex: 0xD3E3F0)
                    Image(.cardBackground2)
                        .resizable()
                        .scaledToFill()
                case CardType.arm.rawValue:
                    Color.primary500
                    Image(.cardBackground3)
                        .resizable()
                        .scaledToFill()
                case CardType.tail.rawValue:
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
