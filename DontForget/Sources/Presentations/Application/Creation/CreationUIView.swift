//
//  CreationUIView.swift
//  DontForget
//
//  Created by 최지철 on 1/20/24.
//

import SwiftUI
import Combine

struct CreationUIView: View {
    // MARK: - Properties
    
    enum Field: Hashable {
      case eventName, date, alarm, memo
    }
    
    @State private var name: String = ""
    @State private var keyboardHeight: CGFloat = 0
    @FocusState private var focusField: Field?
    @State private var scrollViewProxy: ScrollViewProxy?
    @State private var selectedAlarmIndexes: Set<AlarmPeriod> = []
    @ObservedObject private var viewModel: CreationViewModel
    private var isKeyboardVisible: Bool {
        keyboardHeight > 0
    }
    // MARK: - LifeCycle

    init(viewModel: CreationViewModel) {
        self.viewModel = viewModel
        configure()
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.gray900
                .ignoresSafeArea(.all)
            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    VStack(alignment: .leading) {
                        InputNameView(name: $name, viewModel: viewModel)
                            .focused($focusField, equals: .eventName)
                            .id(Field.eventName)
                            .padding(.bottom, 48)
                        InputDateView(viewModel: viewModel)
                            .focused($focusField, equals: .date)
                            .id(Field.date)
                            .disableAutocorrection(true)
                        AlarmView(selectedAlarmIndexes: $selectedAlarmIndexes, alarmPeriods: viewModel.alarmPeriods, viewModel: viewModel)
                            .focused($focusField, equals: .alarm)
                            .id(Field.alarm)
                            .padding(.bottom, 48)
                        MemoView(viewModel: viewModel)
                            .focused($focusField, equals: .memo)
                            .id(Field.memo)
                            .padding(.bottom, 90)
                            .disableAutocorrection(true)
                    }
                    .onReceive(focusField.publisher) { field in
                        withAnimation {
                            scrollViewProxy.scrollTo(
                                field,
                                anchor: .bottom
                            )
                        }
                    }
                    .background(
                        Color.gray900
                            .onTapGesture {
                                hideKeyboard()
                            }
                    )
                }
            }
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            
                        }) {
                            Text(focusField == .eventName ? "다음" : "완료")
                                .foregroundColor(.white)
                                .padding()
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: isKeyboardVisible ? 0 : 8)
                                    .fill(Color.primary500))
                        }
                        .padding(.bottom, isKeyboardVisible ? 0 : 16)
                        .padding(.leading, isKeyboardVisible ? -10 : 20)
                        .padding(.trailing, isKeyboardVisible ? 0 : 20)
                    }
                }
                .padding(.top, keyboardHeight)
                .animation(.default, value: keyboardHeight)
            }
            .onAppear {
                focusField = .eventName
                NotificationCenter.default.addObserver(
                    forName: UIResponder.keyboardWillShowNotification,
                    object: nil,
                    queue: .main
                ) { noti in
                    guard let keyboardFrame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                    keyboardHeight = keyboardFrame.height
                }
                
                NotificationCenter
                    .default
                    .addObserver(forName: UIResponder.keyboardWillHideNotification,
                                 object: nil,
                                 queue: .main) { _ in
                        keyboardHeight = 0
                    }
            }
            .onDisappear {
                NotificationCenter
                    .default
                    .removeObserver(self,
                                    name: UIResponder.keyboardWillShowNotification,
                                    object: nil)
                NotificationCenter
                    .default
                    .removeObserver(self,
                                    name: UIResponder.keyboardWillHideNotification,
                                    object: nil)
        }
    }
}

struct InputNameView: View {
    @Binding var name: String
    @FocusState private var isNameFieldFocused: Bool
    var viewModel: CreationViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text.coloredText("기념일 이름 *", coloredPart: "*", color: .red)
                .padding(.leading, 16)
                .padding(.bottom, 32)
                .foregroundColor(.white)

            TextField("", text: $name,
                      prompt: Text("사랑하는 엄마에게").foregroundColor(.gray700))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .frame(height: 46)
                .focused($isNameFieldFocused)
                .foregroundColor(.white)
            Rectangle()
                .padding(.horizontal, 20)
                .frame(height: 1)
                .foregroundColor(isNameFieldFocused ? Color.primary500 : Color.gray800)
                .onChange(of: name, { _, text in
                    self.viewModel.title = text
                })
        }
    }
}

struct InputDateView: View {
    @State private var selectedDay = 1
    @State private var selectedMonth = 1
    @State private var selectedYear = 2022
    @State private var selectedSegment = 0
    let segments = ["양력으로 입력", "음력으로 입력"]
    var viewModel: CreationViewModel
    
    var body: some View {
        VStack(alignment: .leading, 
               spacing: 0) {
            Text.coloredText("날짜 *",
                             coloredPart: "*",
                             color: .red)
                .padding(.leading, 16)
                .padding(.bottom, 32)
                .foregroundColor(.white)

            Picker("",
                   selection: $selectedSegment) {
                ForEach(0..<2) { index in
                    Text(segments[index]).tag(index)
                }
            }
            .onChange(of: selectedSegment) {  _, _ in
                Task {
                    let dateType: ConvertDate = selectedSegment == 0 ? .lunar : .solar
                    let convertedDate = await viewModel.convertToLunarOrSolar(type: dateType, date: updateViewModelWithSelectedDate())
                    selectedYear = convertedDate[0]
                    selectedMonth = convertedDate[1]
                    selectedDay = convertedDate[2]
                    let strType: String = selectedSegment == 0 ? "LUNAR" : "SOLAR"
                    self.viewModel.calendarType = strType
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 16)
            .padding(.bottom, 16)

            HStack {
                Spacer()
                CustomDatePicker(selectedDay: $selectedDay, selectedMonth: $selectedMonth, selectedYear: $selectedYear)
                    .padding(.horizontal, 30)
                    .padding(.horizontal, 30)
                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }
}

struct AlarmView: View {
    @Binding var selectedAlarmIndexes: Set<AlarmPeriod>
    var alarmPeriods: [AlarmPeriod]
    var viewModel: CreationViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("미리 알림")
                .padding(.leading, 16)
                .padding(.bottom, 32)
                .foregroundColor(.white)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.fixed(74))], spacing: 8) {
                    ForEach(alarmPeriods, id: \.self) { alarmPeriod in
                        Rectangle()
                            .fill(selectedAlarmIndexes.contains(alarmPeriod) ? Color.primary500 : Color.gray700)
                            .frame(width: 74, height: 40)
                            .cornerRadius(50)
                            .overlay(
                                Text(alarmPeriod.title)
                                    .foregroundColor(selectedAlarmIndexes.contains(alarmPeriod) ? Color.white : Color.gray400)
                            )
                            .onTapGesture {
                                if selectedAlarmIndexes.contains(alarmPeriod) {
                                    selectedAlarmIndexes.remove(alarmPeriod)
                                } else {
                                    selectedAlarmIndexes.insert(alarmPeriod)
                                }
                            }
                    }
                }
                .onChange(of: selectedAlarmIndexes, { _, alarm in
                    self.viewModel.alarmSchedule =  selectedAlarmIndexes.map { $0.schedule }
                })
                .padding(.horizontal, 16)
            }
        }
    }
}

struct MemoView: View {
    
    @State var memo: String = ""
    @FocusState private var isMemoFieldFocused: Bool
    var viewModel: CreationViewModel

    var body: some View {
        VStack(alignment: .leading,
               spacing: 0) {
            Text("간단 메모")
                .padding(.leading, 16)
                .padding(.bottom, 32)
                .foregroundColor(.white)
            
            TextField("", text: $memo,
                      prompt: Text("가족여행 미리 계획하기").foregroundColor(.gray700))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
            .frame(height: 46)
            .focused($isMemoFieldFocused)
            .foregroundColor(.white)
            .onChange(of: memo, { _, text in
                self.viewModel.content = text
            })
            Rectangle()
                .padding(.horizontal, 20)
                .frame(height: 1)
                .foregroundColor(isMemoFieldFocused ? Color.primary500 : Color.gray800)
        }
    }
}

// MARK: - Preview

#Preview {
    CreationUIView(viewModel: CreationViewModel(creationUseCase: CreationUseCase(creationRepository: CreationRepository(service: AnniversaryService()))))
}

// MARK: - Extension

extension CreationUIView {
    private func hideKeyboard() {
          UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
      }
    
    private func configure() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.gray900)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.gray500)], for: .normal)
        UISegmentedControl.appearance().backgroundColor = UIColor(Color.gray800)
    }
}

extension InputDateView {
    private func convertToFullYear(twoDigitYear: Int) -> Int {
        // 1925년부터 2024년 사이를 커버하는 로직
        if twoDigitYear >= 25 && twoDigitYear <= 99 {
            return 1900 + twoDigitYear
        } else if twoDigitYear >= 0 && twoDigitYear <= 24 {
            return 2000 + twoDigitYear
        } else {
            return twoDigitYear // 이미 네 자리 숫자인 경우 그대로 반환
        }
    }
    
    private func updateViewModelWithSelectedDate() -> Date {
        let fullYear = convertToFullYear(twoDigitYear: selectedYear)
        return viewModel.updateConvertedDate(day: selectedDay,
                                             month: selectedMonth,
                                             year: fullYear)
    }
}
