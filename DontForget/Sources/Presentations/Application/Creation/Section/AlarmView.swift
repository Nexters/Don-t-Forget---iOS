//
//  AlarmView.swift
//  DontForget
//
//  Created by 제나 on 2/14/24.
//

import SwiftUI

struct AlarmView: View {
    
    @Binding var selectedAlarmIndexes: Set<String>
    @Binding var strAlarmAry: [String]
    var alarmPeriods: [AlarmPeriod]
    var viewModel: CreationViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("알림")
                .font(.pretendard(.semiBold, size: 16))
                .padding(.leading, 16)
                .padding(.bottom, 32)
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.fixed(74))], spacing: 8) {
                    ForEach(alarmPeriods, id: \.self) { alarmPeriod in
                        Rectangle()
                            .fill(selectedAlarmIndexes.contains(alarmPeriod.schedule) ? Color.primary500 : Color.gray700)
                            .frame(width: 74, height: 40)
                            .cornerRadius(50)
                            .overlay(
                                Text(alarmPeriod.title)
                                    .font(.pretendard(size: 15))
                                    .foregroundColor(selectedAlarmIndexes.contains(alarmPeriod.schedule) ? Color.white : Color.gray400)
                            )
                            .onTapGesture {
                                if selectedAlarmIndexes.contains(alarmPeriod.schedule) {
                                    selectedAlarmIndexes.remove(alarmPeriod.schedule)
                                } else {
                                    selectedAlarmIndexes.insert(alarmPeriod.schedule)
                                }
                            }
                    }
                }
                .onChange(of: selectedAlarmIndexes, { _, alarm in
                    strAlarmAry = Array(alarm)
                })
                .padding(.horizontal, 16)
            }
        }
    }
}
