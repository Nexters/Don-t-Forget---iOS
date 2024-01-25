//
//  CreationUIView.swift
//  DontForget
//
//  Created by 최지철 on 1/20/24.
//

import SwiftUI

import ComposableArchitecture

struct CreationUIView: View {
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading) {
                    InputNameView(name: "")
                        .padding(.bottom, 48)
                    InputDateView()
                    AlarmView()
                        .padding(.bottom, 48)
                    MemoView()
                        .padding(.bottom, 90)
                }
                .background(
                    Color.white
                        .onTapGesture {
                            hideKeyboard()
                        }
                )
            }
            VStack {
                Spacer()

                HStack {
                    Spacer()
                    Button(action: {
                        print("다음")
                    }) {
                        Text("다음")
                            .foregroundColor(.white)
                            .padding()
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.black))
                    }
                    .padding()
                }
            }
            .padding(.top, keyboardHeight)
            .animation(.default, value: keyboardHeight)
        }
        .onAppear {
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

private func hideKeyboard() {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }

struct InputNameView: View {
    
    @State var name: String = ""

    var body: some View {
        VStack(alignment: .leading,
               spacing: 0) {
            Text.coloredText("기념일 이름 *",
                             coloredPart: "*",
                             color: .red)
                .padding(.leading, 16)
                .padding(.bottom, 32)
            
            
            TextField("기념일을 입력해주세요.",
                      text: $name)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
            .frame(height: 46)
            Rectangle()
            .padding(.horizontal, 20)
            .frame(height: 1)
            .foregroundColor(Color.gray)
        }
    }
}

struct InputDateView: View {
    @State private var selectedDate = Date()
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

            Picker("",
                   selection:$selectedSegment) {
                ForEach(0..<2) { index in
                    Text(segments[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 16)
            .padding(.bottom, 16)

            HStack {
                Spacer()
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                Spacer()
            }
        }
    }
}

struct AlarmView: View {
    @State private var selectedAlarmIndexes: Set<Int> = []

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("미리 알림")
                .padding(.leading, 16)
                .padding(.bottom, 32)
            HStack {
                LazyHGrid(rows: [GridItem(.flexible())], spacing: 8) {
                    ForEach(0..<5) { index in
                        Rectangle()
                            .fill(selectedAlarmIndexes.contains(index) ? Color.blue : Color.white)
                            .border(.gray, width: 1)
                            .frame(width: 74, height: 40)
                            .cornerRadius(50)
                            .overlay(
                            RoundedRectangle(cornerRadius: 50)
                            .inset(by: 0.5)
                            .stroke(Color(red: 0.91,
                                          green: 0.91,
                                          blue: 0.9),
                                    lineWidth: 1)
                            )                            .onTapGesture {
                                if selectedAlarmIndexes.contains(index) {
                                    selectedAlarmIndexes.remove(index)
                                } else {
                                    selectedAlarmIndexes.insert(index)
                                }
                        }
                    }
                }
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
            TextField("간단한 메모를 하세요.(최대 30자)",
                      text: $memo)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
            .frame(height: 46)
            Rectangle()
            .padding(.horizontal, 20)
            .frame(height: 1)
            .foregroundColor(Color.gray)
        }
    }
}

#Preview {
    CreationUIView()
}
