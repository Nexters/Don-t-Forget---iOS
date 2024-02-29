//
//  InputDateView.swift
//  DontForget
//
//  Created by 제나 on 2/14/24.
//

import SwiftUI

struct InputDateView: View {
    @Binding var selectedDay: Int
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    @Binding var selectedSegment: Int
    @Binding var requestDate: String
    @Binding var calendarType: String
    @State private var type: ConvertDate = .solar
    private let segments = ["양력으로 입력", "음력으로 입력"]
    var viewModel: CreationViewModel
    @State private var isPickerDisabled = false
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text.coloredText(
                "날짜 *",
                coloredPart: "*",
                color: .pink
            )
            .font(.system(size: 19, weight: .semibold))
            .padding(.leading, 16)
            .padding(.bottom, 32)
            .foregroundColor(.white)
            
            Picker(
                "",
                selection: $selectedSegment
            ) {
                ForEach(0..<2) { index in
                    Text(segments[index]).tag(index)
                }
            }
            .disabled(isPickerDisabled) 
            .frame(height: 52)
            .onChange(of: selectedSegment) {  _, _ in
                temporarilyDisablePicker()
                self.type =  selectedSegment == 0 ? .solar : .lunar
                Task {
                    let dateType: ConvertDate = selectedSegment == 0 ? .solar : .lunar
                    let convertedDate = await viewModel.convertToLunarOrSolar(
                        type: dateType,
                        date: updateViewModelWithSelectedDate()
                    )
                    selectedYear = convertedDate[0]
                    selectedMonth = convertedDate[1]
                    selectedDay = convertedDate[2]
                    updateRequestDate()
                    calendarType = dateType.title
                }
                .cancel()
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            
            HStack {
                Spacer()
                CustomDatePicker(
                    selectedDay: $selectedDay,
                    selectedMonth: $selectedMonth,
                    selectedYear: $selectedYear, 
                    type: $type
                )
                .onChange(of: [selectedDay, selectedMonth, selectedYear]) { _, _ in updateRequestDate() }
                .padding(.horizontal, 20)
                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }
}

extension InputDateView {
    private func convertToFullYear(twoDigitYear: Int) -> Int {
        let getTwoDigitYear = twoDigitYear % 100
        if getTwoDigitYear >= 25 && getTwoDigitYear <= 99 {
            return 1900 + getTwoDigitYear
        } else if getTwoDigitYear >= 0 && getTwoDigitYear <= 24 {
            return 2000 + getTwoDigitYear
        } else {
            return getTwoDigitYear
        }
    }
    
    private func updateRequestDate() {
        let fullYear = convertToFullYear(twoDigitYear: selectedYear)
        let fullMonth = String(format: "%02d", selectedMonth)
        let fullDay = String(format: "%02d", selectedDay)
        self.requestDate = "\(fullYear)-\(fullMonth)-\(fullDay)"
    }
    
    private func updateViewModelWithSelectedDate() -> Date {
        let fullYear = convertToFullYear(twoDigitYear: selectedYear)
        return viewModel.updateConvertedDate(
            day: selectedDay,
            month: selectedMonth,
            year: fullYear
        )
    }
    private func temporarilyDisablePicker() {
        isPickerDisabled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isPickerDisabled = false
        }
    }
}
