//
//  HomeView.swift
//  DontForget
//
//  Created by 제나 on 1/17/24.
//

import SwiftUI

struct HomeView: View {
    private let anniversaryCount = 6
    var body: some View {
        ScrollView {
            VStack {
                ZStack {
                    /* Background */
                    Image(.background)
                        .resizable()
                        .scaledToFill()
                    
                    /* Main Anniversary */
                    if anniversaryCount == 0 {
                        AddNewAnniversaryButton()
                            .frame(height: 183)
                            .padding(.horizontal, 24)
                            .padding(.bottom, 190)
                    } else {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("사랑하는 엄마 생일")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 24))
                                Text("D-302")
                                    .font(.system(size: 72, weight: .bold))
                                    .foregroundStyle(Color.primary500)
                                Spacer()
                                    .frame(height: 32)
                                VStack(spacing: 12) {
                                    DateTypeBadge(isLunar: false)
                                    DateTypeBadge(isLunar: true)
                                }
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 36)
                        .padding(.bottom, 190)
                    }
                }
                .padding(.top, Constants.topLayout)
                
                Spacer()
                
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ],
                    spacing: 20
                ) {
                    ForEach(1..<anniversaryCount + 1) { index in
                        if anniversaryCount > 0 {
                            if index == anniversaryCount {
                                AddNewAnniversaryButton()
                                    .frame(height: 173)
                            } else {
                                GridView(
                                    cardType: index % 5,
                                    anniversary: Anniversary.dummy
                                )
                                .frame(height: 173)
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 28)
                
                Spacer()
                    .frame(height: 30)
            }
        }
        .background(
            LinearGradient(
                colors: [
                    Color(hex: 0x212529),
                    Color(hex: 0x0E1317)
                ],
                startPoint: .top,
                endPoint: .center
            )
        )
        .ignoresSafeArea()
    }
}

#Preview {
    HomeView()
}

struct AddNewAnniversaryButton: View {
    var body: some View {
        Button {
            // TODO: - 기념일 생성
        } label: {
            ZStack {
                Color(hex: 0x181E23)
                    .opacity(0.4)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray700, lineWidth: 1.0)
                VStack(spacing: 12) {
                    Image(.calendarAddOn)
                        .resizable()
                        .frame(width: 56, height: 56)
                        .foregroundStyle(Color.gray500)
                    Text("기념일 만들기")
                        .foregroundStyle(Color.gray400)
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct DateTypeBadge: View {
    let isLunar: Bool
    var body: some View {
        HStack(spacing: 10) {
            Text(isLunar ? "음력" : "양력")
                .font(.system(size: 17))
                .bold()
                .foregroundStyle(isLunar ? Color.white : .gray900)
                .padding(.horizontal, 6)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundStyle(isLunar ? Color.primary500 : .yellow500)
                )
            Text(isLunar ? "24.10.21" : "24.11.21")
                .foregroundStyle(Color.gray500)
        }
        .padding(.leading, 2)
    }
}
