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

    let days = 1...31
    let months = 1...12
    let years = 00...99

    var body: some View {
//        ScrollViewReader { proxy in
            
            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    datePickerComponent(values: Array(years), selection: $selectedYear, proxy: $yearProxy)
                        .onChange(of: selectedYear) { old, new in
                                       }
                    Text("년")
                        .foregroundColor(.gray)
                }
                HStack(spacing: 0) {
                    datePickerComponent(values: Array(months), selection: $selectedMonth, proxy: $monthProxy)
                        .onChange(of: selectedMonth) { old, new in
                                       }
                    Text("월").foregroundColor(.gray)
                }
                HStack(spacing: 0) {
                    datePickerComponent(values: Array(days), selection: $selectedDay, proxy: $dayProxy)
                        .onChange(of: selectedDay) { old, new in
       
                                       }
                    Text("일").foregroundColor(.gray)
                }
            }
            .onChange(of: selectedYear) { newValue in
                 scrollToComponent(value: newValue, proxy: yearProxy)
             }
             .onChange(of: selectedMonth) { newValue in
                 scrollToComponent(value: newValue, proxy: monthProxy)
             }
             .onChange(of: selectedDay) { newValue in
                 scrollToComponent(value: newValue, proxy: dayProxy)
             }
            .padding(.horizontal, 20)
    }

    private func datePickerComponent(values: [Int], selection: Binding<Int>, proxy: Binding<ScrollViewProxy?>) -> some View {
        VStack {
            GeometryReader { fullView in
                ScrollViewReader { scrollViewProxy in
                    
                    ScrollView(showsIndicators: false) {
                        VStack {
                            Spacer(minLength: fullView.size.height / 2 - 31.5)
                            LazyVGrid(columns: [GridItem(.fixed(32))], spacing: 0) {
                                ForEach(values, id: \.self) { value in
                                    Text(String(format: "%02d", value))
                                        .foregroundColor(selection.wrappedValue == value ? .blue : .gray)
                                        .frame(height: 63)
                                        .id(value)
                                        .anchorPreference(key: CenterPreferenceKey.self, value: .bounds) { anchor in
                                            [value: fullView[anchor].midY - (fullView.size.height / 2)]
                                        }
                                }
                            }
                            Spacer(minLength: fullView.size.height / 2 - 31.5)
                        }
                    }
                    .onAppear {
                        proxy.wrappedValue = scrollViewProxy
                    }
                    .onPreferenceChange(CenterPreferenceKey.self) { centers in
                        if !isProgrammaticScroll, let closest = centers.min(by: { abs($0.value) < abs($1.value) }) {
                            DispatchQueue.main.async {
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
        typealias Value = [Int: CGFloat]
        static var defaultValue: [Int: CGFloat] = [:]

        static func reduce(value: inout [Int: CGFloat], nextValue: () -> [Int: CGFloat]) {
            value.merge(nextValue(), uniquingKeysWith: { $1 })
        }
    }
    
    
    private func scrollToComponent(value: Int, proxy: ScrollViewProxy?) {
        isProgrammaticScroll = true
        withAnimation {
            proxy?.scrollTo(value, anchor: .center)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isProgrammaticScroll = false
        }
    }}

struct CustomDatePicker_Previews: PreviewProvider {
    @State static var selectedDay = 1
    @State static var selectedMonth = 1
    @State static var selectedYear = 00
    
    static var previews: some View {
        CustomDatePicker(selectedDay: $selectedDay, selectedMonth: $selectedMonth, selectedYear: $selectedYear)
    }
}
