//
//  CustomDatePicker.swift
//  DontForget
//
//  Created by 최지철 on 1/23/24.
//

import SwiftUI
// TODO: 문선생님한테 휠 픽커 물어보기

struct CustomDatePicker: View {
    @State private var selectedYear: Int
    @State private var selectedMonth: Int
    @State private var selectedDay: Int
    let years: [Int]
    let months: [Int] = Array(1...12)
    var days: [Int] {
        Array(1...numberOfDaysInMonth(year: selectedYear, month: selectedMonth))
    }

    init() {
        let currentYear = Calendar.current.component(.year, from: Date())
        self.years = Array((currentYear-10)...(currentYear+10))
        self._selectedYear = State(initialValue: currentYear)
        self._selectedMonth = State(initialValue: Calendar.current.component(.month, from: Date()))
        self._selectedDay = State(initialValue: Calendar.current.component(.day, from: Date()))
    }

    var body: some View {
        HStack {
            Picker("Year", selection: $selectedYear) {
                ForEach(years, id: \.self) { year in
                    Text("\(year)년").tag(year)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 80)
            .clipped()

            Picker("Month", selection: $selectedMonth) {
                ForEach(months, id: \.self) { month in
                    Text("\(month)월").tag(month)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 60)
            .clipped()
            .onChange(of: selectedYear) { _ in
                correctDaySelection()
            }

            Picker("Day", selection: $selectedDay) {
                ForEach(days, id: \.self) { day in
                    Text("\(day)일").tag(day)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 60)
            .clipped()
            .onChange(of: selectedMonth) { _ in
                correctDaySelection()
            }
        }
    }

    private func numberOfDaysInMonth(year: Int, month: Int) -> Int {
        var components = DateComponents()
        components.year = year
        components.month = month
        let calendar = Calendar.current
        if let date = calendar.date(from: components), let range = calendar.range(of: .day, in: .month, for: date) {
            return range.count
        }
        return 28
    }

    private func correctDaySelection() {
        let dayCount = numberOfDaysInMonth(year: selectedYear, month: selectedMonth)
        if selectedDay > dayCount {
            selectedDay = dayCount
        }
    }
}

struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomDatePicker()
    }
}
