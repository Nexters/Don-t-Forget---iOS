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
    @State private var dragOffset: CGFloat = 0
    @State private var scrollViewProxy: ScrollViewProxy?
    
    @State private var yearProxy: ScrollViewProxy?
    @State private var monthProxy: ScrollViewProxy?
    @State private var dayProxy: ScrollViewProxy?
    @State private var isProgrammaticScroll = false
    private let infiniteScrollMultiplier = 100
    
    private let days = 1...31
    private let months = 1...12
    private let years = Array(0...99) + Array(100...199) + Array(200...299)
    
    var body: some View {
        HStack(spacing: 20) {
            HStack(spacing: 10) {
                datePickerComponent(
                    values: Array(years),
                    selection: $selectedYear,
                    proxy: $yearProxy
                )
                .frame(width: 32)
                Text("년")
                    .foregroundColor(.gray)
            }

            HStack(spacing: 10) {
                datePickerComponent(
                    values: Array(months),
                    selection: $selectedMonth,
                    proxy: $monthProxy
                )
                .frame(width: 32)
                Text("월").foregroundColor(.gray)
            }

            HStack(spacing: 10) {
                datePickerComponent(
                    values: Array(days),
                    selection: $selectedDay,
                    proxy: $dayProxy
                )
                .frame(width: 32)
                Text("일").foregroundColor(.gray)
            }
        }
        .onChange(of: selectedYear) { _, newValue in
            scrollToComponent(value: newValue, proxy: yearProxy)
        }
        .onChange(of: selectedMonth) { _, newValue in
            scrollToComponent(value: newValue, proxy: monthProxy)
        }
        .onChange(of: selectedDay) { _, newValue in
            scrollToComponent(value: newValue, proxy: dayProxy)
        }
        .padding(.horizontal, 20)
    }
    
    private func datePickerComponent(
        values: [Int],
        selection: Binding<Int>,
        proxy: Binding<ScrollViewProxy?>
    ) -> some View {
        VStack {
            GeometryReader { fullView in
                ScrollViewReader { scrollViewProxy in
                    ScrollView(showsIndicators: false) {
                        VStack {
                            Spacer(minLength: fullView.size.height / 2 - 25)
                            LazyVGrid(columns: [GridItem(.fixed(32))], spacing: 0) {
                                ForEach(values, id: \.self) { value in
                                    let displayValue = value % 100
                                    Text("\(String(format: "%02d", displayValue))")
                                        .foregroundColor(selection.wrappedValue == value ? .blue : .gray)
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
                        proxy.wrappedValue = scrollViewProxy
                        scrollToComponent(value: selection.wrappedValue, proxy: scrollViewProxy)
                    }
                    .onPreferenceChange(CenterPreferenceKey.self) { centers in
                        DispatchQueue.main.async {
                            if !isProgrammaticScroll,
                                let closest = centers.min(by: { abs($0.value) < abs($1.value) }),
                               selection.wrappedValue != closest.key {
                                withAnimation {
                                    scrollViewProxy.scrollTo(closest.key, anchor: .center)
                                    selection.wrappedValue = closest.key
                                }
                            }
                        }
                    }
                }
            }
            .frame(height: 200)
        }
    }
    
    private struct CenterPreferenceKey: PreferenceKey {
        static var defaultValue = [Int: CGFloat]()
        
        static func reduce(value: inout [Int: CGFloat], nextValue: () -> [Int: CGFloat]) {
            value.merge(nextValue(), uniquingKeysWith: { $1 })
        }
    }
    
    private func scrollToComponent(value: Int, proxy: ScrollViewProxy?) {
        isProgrammaticScroll = true
        withAnimation {
            proxy?.scrollTo(value, anchor: .center)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isProgrammaticScroll = false
        }
    }
}

struct CustomDatePicker_Previews: PreviewProvider {
    @State static var selectedDay = 1
    @State static var selectedMonth = 1
    @State static var selectedYear = 80
    
    static var previews: some View {
        CustomDatePicker(
            selectedDay: $selectedDay,
            selectedMonth: $selectedMonth,
            selectedYear: $selectedYear
        )
    }
}
