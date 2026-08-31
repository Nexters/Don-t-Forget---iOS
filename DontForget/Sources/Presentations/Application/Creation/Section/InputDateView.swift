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
    /// 현재 연도로부터 몇 해 뒤까지 고를 수 있게 할지. 두 자리 연도 창의 끝을 정합니다.
    private static let futureYearAllowance = 5
    var viewModel: CreationViewModel
    @State private var isPickerDisabled = false
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text.coloredText(
                "날짜 *",
                coloredPart: "*",
                color: .pink500
            )
            .font(.pretendard(.semiBold, size: 16))
            .padding(.leading, 16)
            .padding(.bottom, 32)
            .foregroundColor(.white)
            
            Picker(
                "",
                selection: $selectedSegment
            ) {
                ForEach(0..<2) { index in
                    Text(segments[index])
                        .tag(index)
                        .font(.pretendard(size: 15))
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
    /// 피커가 두 자리 연도를 쓰므로 100년 창 안에서만 연도를 표현할 수 있습니다.
    /// 창의 끝을 현재 연도보다 조금 뒤에 두어 다가오는 기념일도 등록할 수 있게 합니다.
    /// (2026년 기준 1932~2031년)
    private func convertToFullYear(twoDigitYear: Int) -> Int {
        let yearInCentury = twoDigitYear % 100
        let latestYear = Calendar.current.component(.year, from: Date()) + Self.futureYearAllowance
        let candidate = latestYear - (latestYear % 100) + yearInCentury
        return candidate <= latestYear ? candidate : candidate - 100
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
