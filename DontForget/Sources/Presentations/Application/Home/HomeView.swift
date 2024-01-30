//
//  HomeView.swift
//  DontForget
//
//  Created by 제나 on 1/17/24.
//

import SwiftUI

struct HomeView: View {
    
    private let anniversaryCount = 5
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ZStack {
                        /* Background */
                        Image(anniversaryCount == 0 ? .homeBackground : .homeBackgroundHalf)
                            .resizable()
                            .scaledToFill()
                        
                        VStack {
                            /* Main Anniversary */
                            if anniversaryCount == 0 {
                                LazyVGrid(columns: columns, content: {
                                    AddNewAnniversaryView()
                                        .frame(height: 183)
                                        .padding(.leading, 24)
                                        .padding(.bottom, 510)
                                })
                            } else {
                                MainAnniversaryCardView(mainAnniversary: Anniversary.dummy)
                            }
                        }
                        .padding(.top, Constants.topLayout)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 32))
                    
                    Spacer()
                    
                    LazyVGrid(
                        columns: columns,
                        spacing: 20
                    ) {
                        ForEach(1..<anniversaryCount + 1) { index in
                            if anniversaryCount > 0 {
                                if index == anniversaryCount {
                                    NavigationLink {
                                        CreationUIView()
                                    } label: {
                                        AddNewAnniversaryView()
                                            .frame(height: 173)
                                    }
                                } else {
                                    NavigationLink {
                                        AnniversaryDetailView()
                                    } label: {
                                        GridView(
                                            cardType: index % 5,
                                            anniversary: Anniversary.dummy
                                        )
                                        .frame(height: 173)
                                    }
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
}

#Preview {
    HomeView()
}

struct AddNewAnniversaryView: View {
    var body: some View {
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

struct MainAnniversaryCardView: View {
    let mainAnniversary: Anniversary
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
                    Text(mainAnniversary.title)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                    Text(mainAnniversary.note)
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
