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
    /// 기념일 만들기에서는 제목을 입력하는 동안 "다음"으로 키보드를 내리는 단계를 둡니다.
    /// 편집 화면은 값이 이미 채워져 있어 이 단계 없이 바로 완료됩니다.
    private var isNameInputStep: Bool {
        type == .create && focusField == .eventName
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
        if let id = id {
            self.id = id
        }
        configure()
    }
    
    // MARK: - View
    
    var body: some View {
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
            .navigationTitle("기념일 만들기")
            .navigationBarTitleDisplayMode(.inline)
            /// 뒤로가기 대신 취소 버튼으로 확인 절차를 거칩니다.
            .navigationBarBackButtonHidden(true)
            .toolbarBackground(Color.gray900, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
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
                            .font(.pretendard(.semiBold, size: 16))
                    }
                    .disabled(showConfirmView)
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        if isNameInputStep {
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
                                }
                            }
                        }
                    } label: {
                        Text(isNameInputStep ? "다음" : "완료")
                            .font(.pretendard(.semiBold, size: 20))
                            .foregroundColor(.white)
                            .padding()
                            .frame(height: 72)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: isKeyboardVisible ? 0 : 8)
                                    .fill(name.isEmpty ? Color.gray400 : Color.primary500))
                    }
                    .padding(.bottom, isKeyboardVisible  ? 0 : 16)
                    .padding(.leading, isKeyboardVisible ? -10 : 20)
                    .padding(.trailing, isKeyboardVisible ? 0 : 20)
                    .disabled(name.isEmpty)
                }
            }
            .padding(.top, isKeyboardVisible && focusField == .memo ? keyboardHeight + 20 : 0)
            .animation(.default, value: keyboardHeight)
        }
        .onAppear(perform: actionsOnAppear)
        .onDisappear(perform: actionOnDisappear)
        .onReceive(viewModel.viewDismissalModePublisher) { shouldDismiss in
            if shouldDismiss {
                withAnimation {
                    dismiss()
                }
            }
        }
        .onChange(of: showConfirmView) { _, showed in
            if showed {
                hideKeyboard()
            }
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
        let date = dateFormatter.date(from: dateString)!
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date) % 100
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        return [year, month, day]
    }
    
    /// 네비게이션 바는 SwiftUI의 toolbar 모디파이어로 처리합니다.
    /// 세그먼트 컨트롤은 SwiftUI에 대응 API가 없어 appearance로 남겨둡니다.
    private func configure() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.gray900)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.gray500)], for: .normal)
        UISegmentedControl.appearance().backgroundColor = UIColor(Color.gray800)
    }
    
    private func randomCardType() -> String {
        return CardType.allCases.randomElement()!.rawValue
    }
    
    private func actionsOnAppear() {
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
    
    private func actionOnDisappear() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
}
