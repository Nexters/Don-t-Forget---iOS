//
//  CustomDatePicker.swift
//  DontForget
//
//  Created by 최지철 on 1/23/24.
//

import SwiftUI

struct CustomDatePicker: View {
    @Binding var selectedDay: Int
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    @Binding var type: ConvertDate

    private let months = 1...12
    private let years = Array(0...99) + Array(100...199) + Array(200...299)

    var body: some View {
        HStack(spacing: 20) {
            HStack(spacing: 10) {
                DatePickerColumn(values: Array(years), selection: $selectedYear)
                    .frame(width: 32)
                Text("년")
                    .foregroundColor(.gray)
                    .font(.pretendard(size: 15))
            }

            HStack(spacing: 10) {
                DatePickerColumn(values: Array(months), selection: $selectedMonth)
                    .frame(width: 32)
                Text("월")
                    .foregroundColor(.gray)
                    .font(.pretendard(size: 15))
            }

            HStack(spacing: 10) {
                DatePickerColumn(values: daysInMonth(for: type), selection: $selectedDay)
                    .frame(width: 32)
                Text("일")
                    .foregroundColor(.gray)
                    .font(.pretendard(size: 15))
            }
        }
        .padding(.horizontal, 20)
    }

    private func daysInMonth(for type: ConvertDate) -> [Int] {
        switch type {
        case .solar:
            return Array(1...31)
        case .lunar:
            return Array(1...30)
        }
    }
}

/// 년/월/일 각각을 담당하는 스크롤 컬럼입니다.
/// 스크롤 잠금 상태를 컬럼마다 따로 들고 있어야 한 칼럼의 이동이 다른 칼럼을 막지 않습니다.
private struct DatePickerColumn: View {

    let values: [Int]
    @Binding var selection: Int

    /// 코드가 스크롤을 옮기는 동안에는 그 움직임을 사용자 스크롤로 오인하지 않도록 잠급니다.
    @State private var isProgrammaticScroll = false
    /// 사용자가 스크롤해서 고른 값. 이미 그 위치에 있으므로 다시 스크롤할 필요가 없습니다.
    @State private var userSelectedValue: Int?

    var body: some View {
        VStack {
            GeometryReader { fullView in
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack {
                            Spacer(minLength: fullView.size.height / 2 - 25)
                            LazyVGrid(columns: [GridItem(.fixed(32))], spacing: 0) {
                                ForEach(values, id: \.self) { value in
                                    Text("\(String(format: "%02d", value % 100))")
                                        .font(.pretendard(size: 24))
                                        .foregroundColor(selection == value ? .blue : .gray)
                                        .frame(width: 60, height: 63)
                                        .id(value)
                                        .anchorPreference(key: CenterPreferenceKey.self, value: .bounds) { anchor in
                                            [value: fullView[anchor].midY - (fullView.size.height / 2)]
                                        }
                                }
                            }
                            Spacer(minLength: fullView.size.height / 2 - 25)
                        }
                    }
                    .onAppear {
                        scroll(to: selection, with: proxy)
                    }
                    .onChange(of: selection) { _, newValue in
                        /// 사용자가 스크롤해서 바뀐 값이면 화면은 이미 그 위치입니다.
                        /// 여기서 다시 스크롤하면 잠금이 걸려 이어지는 스크롤이 먹지 않습니다.
                        guard newValue != userSelectedValue else { return }
                        scroll(to: newValue, with: proxy)
                    }
                    .onPreferenceChange(CenterPreferenceKey.self) { centers in
                        DispatchQueue.main.async {
                            guard !isProgrammaticScroll,
                                  let closest = centers.min(by: { abs($0.value) < abs($1.value) }),
                                  selection != closest.key else { return }
                            userSelectedValue = closest.key
                            withAnimation {
                                proxy.scrollTo(closest.key, anchor: .center)
                                selection = closest.key
                            }
                        }
                    }
                }
            }
            .frame(height: 200)
        }
    }

    private func scroll(to value: Int, with proxy: ScrollViewProxy) {
        isProgrammaticScroll = true
        withAnimation {
            proxy.scrollTo(value, anchor: .center)
        }
        /// 애니메이션이 끝날 만큼만 잠급니다. 길게 잡으면 그 사이 사용자 스크롤이 통째로 무시됩니다.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            isProgrammaticScroll = false
        }
    }
}

private struct CenterPreferenceKey: PreferenceKey {
    static var defaultValue = [Int: CGFloat]()

    static func reduce(value: inout [Int: CGFloat], nextValue: () -> [Int: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

#Preview {
    CustomDatePicker(
        selectedDay: .constant(1),
        selectedMonth: .constant(1),
        selectedYear: .constant(80),
        type: .constant(.solar)
    )
}
