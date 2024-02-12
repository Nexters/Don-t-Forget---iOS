//
//  CreationView.swift
//  DontForget
//
//  Created by 최지철 on 1/20/24.
//

import SwiftUI
import Combine

struct CreationView: View {
    // MARK: - Properties
    
    private enum Field: Hashable {
        case eventName, date, alarm, memo
    }
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var memo = ""
    @State private var strDate  = ""
    @State private var keyboardHeight = CGFloat(0)
    @FocusState private var focusField: Field?
    @State private var scrollViewProxy: ScrollViewProxy?
    @State private var selectedAlarmIndexes: Set<String> = []
    @ObservedObject private var viewModel: CreationViewModel
    @State private var cancellables: Set<AnyCancellable> = []
    @State private var strAlarmAry = [String]()
    @State private var calendarType = "SOLAR"
    @State private var requestDate = "1980-01-01"
    @State private var baseType = 0
    @State private var baseDate = [80,1,1]
    private var type:  CreationVIewType
    private var isKeyboardVisible: Bool {
        keyboardHeight > 0
    }
    
    // MARK: - LifeCycle
    
    init(viewModel: CreationViewModel, id: Int?, type: CreationVIewType) {
        self.viewModel = viewModel
        self.type = type
        switch type {
        case .create:
            break
        case .edit:
            viewModel.fetchAnniversaryDetail(id: id!)
        }
        configure()
    }
    
    // MARK: - View
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color.gray900
                    .ignoresSafeArea(.all)
                ScrollView {
                    ScrollViewReader { _ in
                        VStack(alignment: .leading) {
                            InputNameView(
                                name: $name,
                                viewModel: viewModel
                            )
                            .focused($focusField, equals: .eventName)
                            .id(Field.eventName)
                            .padding(.bottom, 48)
                            InputDateView(
                                selectedDay: $baseDate[0], selectedMonth: $baseDate[1], selectedYear: $baseDate[2], selectedSegment: $baseType, requestDate: $requestDate, calendarType: $calendarType, viewModel: viewModel
                            )
                            .focused($focusField, equals: .date)
                            .id(Field.date)
                            .disableAutocorrection(true)
                            AlarmView(
                                selectedAlarmIndexes: $selectedAlarmIndexes,
                                strAlarmAry: $strAlarmAry,
                                alarmPeriods: viewModel.alarmPeriods,
                                viewModel: viewModel
                            )
                            .focused($focusField, equals: .alarm)
                            .id(Field.alarm)
                            .padding(.bottom, 48)
                            MemoView(
                                memo: $memo,
                                viewModel: viewModel
                            )
                            .focused($focusField, equals: .memo)
                            .id(Field.memo)
                            .padding(.bottom, 90)
                            .disableAutocorrection(true)
                        }
                        .background(
                            Color.gray900
                                .onTapGesture {
                                    hideKeyboard()
                                }
                        )
                    }
                }
                .navigationBarTitle("기념일 만들기", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("취소")
                                .foregroundColor(.gray600)
                        }
                    }
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            if focusField == .eventName {
                                hideKeyboard()
                            } else {
                                
                                switch type {
                                    
                                case .create:
                                    let request = RegisterAnniversaryRequest(
                                        title: name,
                                        date: requestDate,
                                        content: memo,
                                        calendarType: calendarType,
                                        cardType: randomCardType(),
                                        alarmSchedule: strAlarmAry
                                    )
                                    viewModel.action(.registerAnniversary(parameters: request))
                                case .edit:
                                    let request = RegisterAnniversaryRequest(
                                        title: name,
                                        date: requestDate,
                                        content: memo,
                                        calendarType: calendarType,
                                        cardType: randomCardType(),
                                        alarmSchedule: strAlarmAry
                                    )
                                    viewModel.action(.editAnniversary(parameters: request))
                                }
                            }
                        } label: {
                            Text(focusField == .eventName ? "다음" : "완료")
                                .foregroundColor(.white)
                                .padding()
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: isKeyboardVisible ? 0 : 8)
                                    .fill(Color.primary500))
                        }
                        .padding(.bottom, isKeyboardVisible  ? 0 : 16)
                        .padding(.leading, isKeyboardVisible ? -10 : 20)
                        .padding(.trailing, isKeyboardVisible ? 0 : 20)
                    }
                }
                .padding(.top, isKeyboardVisible && focusField == .memo ? keyboardHeight + 20 : 0)
                .animation(.default, value: keyboardHeight)
            }
            .onAppear {
                switch type {
                    
                case .create:
                    self.selectedAlarmIndexes = Set(["D_DAY"])
                case .edit:
                    viewModel.$anniversaryDetail
                        .receive(on: DispatchQueue.main)
                        .sink {  res in
                            self.name = res?.title ?? ""
                            self.memo = res?.content ?? ""
                            self.selectedAlarmIndexes = Set(res?.alarmSchedule ?? [])
                            self.baseType = res?.baseType == "SOLAR" ? 0 : 1
                            self.baseDate = self.extractYearMonthDay(from: res!.baseDate) ?? []
                        }
                        .store(in: &cancellables)
                }
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
                    .addObserver(
                        forName: UIResponder.keyboardWillHideNotification,
                        object: nil,
                        queue: .main
                    ) { _ in
                        keyboardHeight = 0
                    }
            }
            .onDisappear {
                NotificationCenter
                    .default
                    .removeObserver(
                        self,
                        name: UIResponder.keyboardWillShowNotification,
                        object: nil
                    )
                NotificationCenter
                    .default
                    .removeObserver(
                        self,
                        name: UIResponder.keyboardWillHideNotification,
                        object: nil
                    )
            }
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
            TextField(
                "",
                text: $name,
                prompt: Text("사랑하는 엄마에게").foregroundColor(.gray700)
            )
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
    @Binding var selectedDay: Int
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    @Binding var selectedSegment: Int
    @Binding var requestDate: String
    @Binding var calendarType: String
    private let segments = ["양력으로 입력", "음력으로 입력"]
    var viewModel: CreationViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text.coloredText(
                "날짜 *",
                coloredPart: "*",
                color: .red
            )
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
            .onChange(of: selectedSegment) {  _, _ in
                Task {
                    let dateType: ConvertDate = selectedSegment == 0 ? .lunar : .solar
                    let convertedDate = await viewModel.convertToLunarOrSolar(
                        type: dateType,
                        date: updateViewModelWithSelectedDate()
                    )
                    selectedYear = convertedDate[0]
                    selectedMonth = convertedDate[1]
                    selectedDay = convertedDate[2]
                    
                    updateRequestDate()
                    let strType: String = selectedSegment == 0 ? "SOLAR" : "LUNAR"
                    calendarType = strType
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            
            HStack {
                Spacer()
                CustomDatePicker(
                    selectedDay: $selectedDay,
                    selectedMonth: $selectedMonth,
                    selectedYear: $selectedYear
                )
                .onChange(of: [selectedDay, selectedMonth, selectedYear]) { _, _ in updateRequestDate() }
                .padding(.horizontal, 60)
                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }
}

struct AlarmView: View {
    @Binding var selectedAlarmIndexes: Set<String>
    @Binding var strAlarmAry: [String]
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
                            .fill(selectedAlarmIndexes.contains(alarmPeriod.schedule) ? Color.primary500 : Color.gray700)
                            .frame(width: 74, height: 40)
                            .cornerRadius(50)
                            .overlay(
                                Text(alarmPeriod.title)
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

struct MemoView: View {
    
    @Binding var memo: String
    @FocusState private var isMemoFieldFocused: Bool
    var viewModel: CreationViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("간단 메모")
                .padding(.leading, 16)
                .padding(.bottom, 32)
                .foregroundColor(.white)
            TextField(
                "", text: $memo,
                prompt: Text("가족여행 미리 계획하기").foregroundColor(.gray700)
            )
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
            .frame(height: 46)
            .focused($isMemoFieldFocused)
            .foregroundColor(.white)
            Rectangle()
                .padding(.horizontal, 20)
                .frame(height: 1)
                .foregroundColor(isMemoFieldFocused ? Color.primary500 : Color.gray800)
        }
    }
}

// MARK: - Extension

extension CreationView {
    private func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
    
    private func extractYearMonthDay(from dateString: String) -> [Int]? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = dateFormatter.date(from: dateString) else {
            print("Invalid date format")
            return nil
        }

        let calendar = Calendar.current

        let year = calendar.component(.year, from: date) % 100
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)

        return [year, month, day]
    }
    
    private func configure() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.gray900)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.gray500)], for: .normal)
        UISegmentedControl.appearance().backgroundColor = UIColor(Color.gray800)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.gray900)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    private func randomCardType() -> String {
        let cardType = ["LUNAR", "TAIL", "ARM", "FACE", "FOREST"]
        return cardType.randomElement()!
    }
}

extension InputDateView {
    private func convertToFullYear(twoDigitYear: Int) -> Int {
        if twoDigitYear >= 25 && twoDigitYear <= 99 {
            return 1900 + twoDigitYear
        } else if twoDigitYear >= 0 && twoDigitYear <= 24 {
            return 2000 + twoDigitYear
        } else {
            return twoDigitYear
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
}
