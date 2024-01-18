//
//  HomeView.swift
//  DontForget
//
//  Created by 제나 on 1/17/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(
                        width: UIScreen.width,
                        height: UIScreen.height * 0.7
                    )
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(
                                colors: [
                                    Color.primary1,
                                    Color.primary2
                                ]
                            ),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .padding(.horizontal, 20)
                VStack {
                    Image(.starBackground)
                    Spacer()
                }
                
                VStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 56, height: 56)
                        .foregroundStyle(.white.opacity(0.4))
                        .padding(.top, 75)
                    Text("사랑하는 엄마 생일")
                        .foregroundStyle(.white)
                        .font(.system(size: 24))
                    HStack {
                        Text("D-32")
                            .font(.system(size: 72, weight: .bold))
                            .foregroundStyle(.white)
                        Text("일")
                            .font(.system(size: 72, weight: .bold))
                            .foregroundStyle(.white.opacity(0.4))
                    }
                    Spacer()
                    HStack {
                        HStack {
                            Image(.moonIcon)
                            Text("24.2.13")
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 40)
                                .foregroundStyle(.black.opacity(0.2))
                        )
                        Spacer()
                        Button {
                            // TODO: -
                        } label: {
                            Image(systemName: "pencil")
                                .font(.system(size: 24))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 40)
                                        .foregroundStyle(.black.opacity(0.2))
                                )
                        }
                        Button {
                            // TODO: -
                        } label: {
                            Image(systemName: "trash.fill")
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 40)
                                        .foregroundStyle(.black.opacity(0.2))
                                )
                        }
                    }
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 32)
            }
            
            Spacer()
            
            LazyVGrid(
                columns: [GridItem(), GridItem()]
            ) {
                ForEach(0..<4) { _ in
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: 183, height: 183)
                        .foregroundStyle(Color.neutral1)
                        .padding(.bottom, 8)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 30)
        }
        .background(Color.black)
        .ignoresSafeArea()
    }
}

#Preview {
    HomeView()
}
