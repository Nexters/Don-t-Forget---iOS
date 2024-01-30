//
//  HomeView.swift
//  DontForget
//
//  Created by 제나 on 1/17/24.
//

import SwiftUI

struct HomeView: View {
    
    private let anniversaryCount = 7
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
                        Image(anniversaryCount == 0 ? .homeBackgroundFull : .homeBackgroundHalf)
                            .resizable()
                            .scaledToFill()
                        
                        VStack {
                            /* Main Anniversary */
                            if anniversaryCount == 0 {
                                LazyVGrid(columns: columns, content: {
                                    AddNewAnniversaryView()
                                        .padding(.leading, 24)
                                        .padding(.bottom, 510)
                                })
                            } else {
                                NavigationLink {
                                    AnniversaryDetailView(anniversary: Anniversary.dummy)
                                } label: {
                                    AnniversaryContentView(anniversary: Anniversary.dummy)
                                }
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
                                    }
                                } else {
                                    NavigationLink {
                                        AnniversaryDetailView(anniversary: Anniversary.dummy)
                                    } label: {
                                        GridView(
                                            cardType: index % 5,
                                            anniversary: Anniversary.dummy
                                        )
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
                Image(.calendarAddOnIcon)
                    .resizable()
                    .frame(width: 56, height: 56)
                    .foregroundStyle(Color.gray500)
                Text("기념일 만들기")
                    .foregroundStyle(Color.gray400)
            }
            .padding(.horizontal, 20)
        }
        .frame(minHeight: 170)
    }
}
