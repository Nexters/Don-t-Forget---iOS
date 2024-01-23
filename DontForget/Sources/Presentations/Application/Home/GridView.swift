//
//  GridView.swift
//  DontForget
//
//  Created by 제나 on 1/23/24.
//

import SwiftUI

struct GridView: View {
    
    let isEven: Bool
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("할머니 생신")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(isEven ? Color.neutral2: Color.white)
                HStack {
                    Text("D-81")
                        .font(.system(size: 36, weight: .heavy))
                        .foregroundStyle(isEven ? Color.primary1 : .white)
                    Text("일")
                        .font(.system(size: 36, weight: .heavy))
                        .foregroundStyle(isEven ? Color.primary1 : .white)
                        .opacity(0.4)
                }
                Spacer()
                HStack {
                    Image(.moonIcon)
                    
                    Text("24.2.13")
                        .font(.system(size: 14))
                        .foregroundStyle(isEven ? Color.neutral2: Color.white)
                }
            }
            .padding(.leading, 20)
            .padding(.top, 32)
            .padding(.bottom, 22)
            Spacer()
        }
        .frame(width: 183, height: 183)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(isEven ? Color.neutral1 : .primary1)
                    .padding(.bottom, 8)
                Image(isEven ? String.starInGrid1 : .starInGrid2)
                    .resizable()
                    .scaleEffect(0.85)
            }
        )
    }
}

#Preview {
    GridView(isEven: false)
}
