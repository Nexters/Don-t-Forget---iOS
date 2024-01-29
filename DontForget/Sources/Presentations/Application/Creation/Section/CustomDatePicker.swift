//
//  CustomDatePicker.swift
//  DontForget
//
//  Created by 최지철 on 1/23/24.
//

import SwiftUI

struct CustomDatePicker: View {
    @State private var selectedDay = 1
    @State private var selectedMonth = 1
    @State private var selectedYear = 2022

    let days = 1...31
    let months = 1...12
    let years = 00...99

    var body: some View {

            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    datePickerComponent(values: Array(years), selection: $selectedYear)
                    Text("년")
                        .foregroundColor(.gray)

                }
                HStack(spacing: 0) {
                    datePickerComponent(values: Array(months), selection: $selectedMonth)
                    Text("월").foregroundColor(.gray)
                }
                HStack(spacing: 0) {
                    datePickerComponent(values: Array(days), selection: $selectedDay)
                    Text("일").foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 20)
    }

    private func datePickerComponent(values: [Int], selection: Binding<Int>) -> some View {
        VStack {
            GeometryReader { fullView in
                ScrollView(showsIndicators: false) {
                    VStack {
                        Spacer(minLength: fullView.size.height / 2 - 31.5) 
                        LazyVGrid(columns: [GridItem(.fixed(32))], spacing: 0) {
                            ForEach(values, id: \.self) { value in
                                Text(String(format: "%02d", value)) 
                                    .foregroundColor(selection.wrappedValue == value ? .blue : .gray)
                                    .frame(height: 63)
                                    .onTapGesture {
                                        selection.wrappedValue = value
                                    }
                                    .anchorPreference(key: CenterPreferenceKey.self, value: .center) { anchor in
                                        [value: fullView[anchor].y - (fullView.size.height / 2)]
                                    }
                            }
                        }
                        Spacer(minLength: fullView.size.height / 2 - 31.5)
                    }
                }
                .onPreferenceChange(CenterPreferenceKey.self) { centers in
                    if let closest = centers.min(by: { abs($0.value) < abs($1.value) }) {
                        selection.wrappedValue = closest.key
                    }
                }
            }
            .frame(height: 200)
        }
    }
}

private struct CenterPreferenceKey: PreferenceKey {
    typealias Value = [Int: CGFloat]
    static var defaultValue: [Int: CGFloat] = [:]

    static func reduce(value: inout [Int: CGFloat], nextValue: () -> [Int: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomDatePicker()
    }
}
