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
    @Environment(\.dismiss) private var dismiss
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
    @State private var baseDate = [80, 1, 1]
    private var id: Int?
    private var type: CreationViewType
    private var isKeyboardVisible: Bool {
        keyboardHeight > 0
    }
    @State private var showConfirmView = false
    @State private var alertType: AlertType = .cancelCreating

    // MARK: - LifeCycle
    
    init(
        viewModel: CreationViewModel,
        id: Int?,
        type: CreationViewType
    ) {
        self.viewModel = viewModel
        self.type = type
        switch type {
        case .create:
            break
        case .edit:
            self.id = id
        }
        configure()
    }
    
    // MARK: - View
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                if showConfirmView {
                    ConfirmView(
                        viewModel: viewModel,
                        alertType: alertType,
                        isPresentend: $showConfirmView,
                        dismiss: dismiss
                    )
                    .zIndex(1)
                }
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
                                selectedDay: $baseDate[2], 
                                selectedMonth: $baseDate[1],
                                selectedYear: $baseDate[0],
                                selectedSegment: $baseType,
                                requestDate: $requestDate,
                                calendarType: $calendarType,
                                viewModel: viewModel
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
                            .padding(.bottom, 140)
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
                .padding(.top)
                .navigationBarTitle("기념일 만들기", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            switch type {
                            case .create:
                                self.alertType = .cancelCreating
                            case .edit:
                                self.alertType = .cancelEditing
                            }
                            showConfirmView = true
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
                                    if !name.isEmpty {
                                        viewModel.action(.registerAnniversary(parameters: request))
                                        dismiss()
                                    }
                                case .edit:
                                    let request = RegisterAnniversaryRequest(
                                        title: name,
                                        date: requestDate,
                                        content: memo,
                                        calendarType: calendarType,
                                        cardType: viewModel.anniversaryDetail?.cardType ?? randomCardType(),
                                        alarmSchedule: strAlarmAry
                                    )
                                    if !name.isEmpty {
                                        viewModel.action(.editAnniversary(parameters: request, id: id!))
                                        dismiss()
                                    }
                                }
                            }
                        } label: {
                            Text(focusField == .eventName ? "다음" : "완료")
                                .foregroundColor(.white)
                                .padding()
                                .frame(height: 72)
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
                    self.selectedAlarmIndexes = Set([AlarmPeriod.dDay.schedule])
                    focusField = .eventName
                case .edit:
                    viewModel.fetchAnniversaryDetail(id: id!)
                    viewModel.$anniversaryDetail
                        .receive(on: DispatchQueue.main)
                        .sink {  res in
                            self.name = res?.title ?? ""
                            self.memo = res?.content ?? ""
                            self.selectedAlarmIndexes = Set(res?.alarmSchedule ?? [])
                            self.baseType = res?.baseType == ConvertDate.solar.title ? 1 : 0
                            if let date = res?.baseDate {
                                self.baseDate = self.extractYearMonthDay(from: date)!
                            }
                        }
                        .store(in: &cancellables)
                }
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
        .navigationBarHidden(true)
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
            print("=== DEBUG: Invalid date format")
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
        let cardType = [
            CardType.lunar.rawValue,
            CardType.tail.rawValue,
            CardType.arm.rawValue,
            CardType.face.rawValue,
            CardType.forest.rawValue
        ]
        return cardType.randomElement()!
    }
}
