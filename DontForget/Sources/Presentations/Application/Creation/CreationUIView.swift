//
//  CreationUIView.swift
//  DontForget
//
//  Created by 최지철 on 1/20/24.
//

import SwiftUI

struct CreationUIView: View {
    // MARK: - Properties
    
    enum Field: Hashable {
      case eventName, date, alarm, memo
    }
    
    @State private var keyboardHeight: CGFloat = 0
    @FocusState private var focusField: Field?
    @State private var scrollViewProxy: ScrollViewProxy?
    @State private var selectedAlarmIndexes: Set<AlarmPeriod> = []
    private let viewModel: CreationViewModel

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
                        InputNameView(name: "")
                            .focused($focusField, equals: .eventName)
                            .id(Field.eventName)
                            .padding(.bottom, 48)
                        InputDateView()
                        
                            .focused($focusField, equals: .date)
                            .id(Field.date)
                        AlarmView(selectedAlarmIndexes: $selectedAlarmIndexes, alarmPeriods: viewModel.alarmPeriods)
                            .focused($focusField, equals: .alarm)
                            .id(Field.alarm)
                            .padding(.bottom, 48)
                        MemoView()
                            .focused($focusField, equals: .memo)
                            .id(Field.memo)
                            .padding(.bottom, 90)
                    }
                    .onReceive(focusField.publisher) { field in
                        withAnimation {
                            scrollViewProxy.scrollTo(field, anchor: .bottom)                       }
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
                            focusField = .alarm
                        }) {
                            Text(focusField == .memo ? "완료" : "다음")
                                .foregroundColor(.white)
                                .padding()
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.primary500))
                        }
                        .padding()
                    }
                }
                .padding(.top, keyboardHeight)
                .animation(.default, value: keyboardHeight)
            }
            .onAppear {
                focusField = .eventName
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                                       object: nil,
                                                       queue: .main) { noti in
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
    @State var name: String = ""
    @FocusState private var isNameFieldFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text.coloredText("기념일 이름 *", coloredPart: "*", color: .red)
                .padding(.leading, 16)
                .padding(.bottom, 32)
                .foregroundColor(.white)

            TextField("사랑하는 엄마에게", text: $name)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .frame(height: 46)
                .focused($isNameFieldFocused)

            Rectangle()
                .padding(.horizontal, 20)
                .frame(height: 1)
                .foregroundColor(isNameFieldFocused ? Color.primary500 : Color.gray800)
        }
    }
}

struct InputDateView: View {
    @State private var selectedDay = 1
    @State private var selectedMonth = 1
    @State private var selectedYear = 2022
    @State private var selectedSegment = 0
    let segments = ["양력으로 입력", "음력으로 입력"]

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
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 16)
            .padding(.bottom, 16)

            HStack {
                Spacer()
                CustomDatePicker(selectedDay: $selectedDay, selectedMonth: $selectedMonth, selectedYear: $selectedYear)
                    .onChange(of: selectedDay) { _ in }
                    .onChange(of: selectedMonth) { _ in }
                    .onChange(of: selectedYear) { _ in }
                    .padding(.horizontal, 30)                    .padding(.horizontal, 30)

                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }

}

struct AlarmView: View {
    @Binding var selectedAlarmIndexes: Set<AlarmPeriod>
    var alarmPeriods: [AlarmPeriod]

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
                .padding(.horizontal, 16)
            }
        }
    }
}

struct MemoView: View {
    
    @State var memo: String = ""

    var body: some View {
        VStack(alignment: .leading,
               spacing: 0) {
            Text("간단 메모")
                .padding(.leading, 16)
                .padding(.bottom, 32)
                .foregroundColor(.white)

            TextField("간단한 메모를 하세요.(최대 30자)",
                      text: $memo)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
            .frame(height: 46)
            Rectangle()
            .padding(.horizontal, 20)
            .frame(height: 1)
            .foregroundColor(Color.white)
        }
    }
}
// MARK: - Preview

#Preview {
    CreationUIView(viewModel: CreationViewModel(creationUseCse: CreationUseCase(creationRepository: CreationRepository(service: AnniversaryService()))))
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
