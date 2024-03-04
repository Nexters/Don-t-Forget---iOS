//
//  AnniversaryContentView.swift
//  DontForget
//
//  Created by 제나 on 1/30/24.
//

import SwiftUI

struct AnniversaryContentView: View {
    
    let anniversary: AnniversaryDetailDTO
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
            VStack(alignment: .leading) {
                Text(anniversary.solarDate.replacingOccurrences(of: "-", with: "."))
                    .foregroundStyle(Color.gray600)
                    .font(.system(size: 18))
                Text(dday)
                    .font(.system(size: 72, weight: .bold))
                    .foregroundStyle(Color.primary500)
                Spacer()
                    .frame(height: 20)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(anniversary.title)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                    if !anniversary.content.isEmpty {
                        Text(anniversary.content)
                            .font(.system(size: 16))
                            .foregroundStyle(Color.gray600)
                    }
                }
                .padding(.horizontal, 16)
                .overlay(
                    Rectangle()
                        .frame(
                            width: 2.5,
                            height: nil
                        )
                        .foregroundStyle(Color.primary500),
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
