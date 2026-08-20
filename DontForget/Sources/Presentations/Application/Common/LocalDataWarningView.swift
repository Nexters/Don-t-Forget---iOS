//
//  LocalDataWarningView.swift
//  DontForget
//
//  Created by 제나 on 8/20/24.
//

import SwiftUI

struct LocalDataWarningView: View {
    @Environment(\.dismiss) var dismiss
    var onDismissed: (() -> Void)?

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "exclamationmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.orange)

                        Text("로컬 저장소 알림")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)

                        Spacer()
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("데이터가 기기의 로컬 저장소에만 저장됩니다.")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.gray)

                        VStack(alignment: .leading, spacing: 6) {
                            warningItem("앱 재설치", "데이터가 삭제됩니다")
                            warningItem("기기 변경", "데이터를 이전할 수 없습니다")
                            warningItem("자동 백업", "지원하지 않습니다")
                        }
                        .padding(.top, 8)
                    }
                }
                .padding(16)

                Divider()
                    .background(Color.gray.opacity(0.3))

                HStack(spacing: 12) {
                    Button {
                        UserDefaults.standard.set(true, forKey: "localDataWarningDismissed")
                        dismiss()
                        onDismissed?()
                    } label: {
                        Text("다시 보지 않기")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(height: 44)

                    Button {
                        dismiss()
                        onDismissed?()
                    } label: {
                        Text("확인")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(height: 44)
                }
                .padding(16)
            }
            .background(Color(red: 0.1, green: 0.1, blue: 0.1))
            .cornerRadius(12)
            .padding(20)
        }
    }

    private func warningItem(_ title: String, _ description: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 12))
                .foregroundColor(.gray)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)

                Text(description)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.gray)
            }

            Spacer()
        }
    }
}

#Preview {
    LocalDataWarningView()
}
