//
//  CreationFeature.swift
//  DontForget
//
//  Created by 최지철 on 1/25/24.
//

import Foundation

import ComposableArchitecture

@Reducer
struct CreationFeature: Reducer {
    
    struct State: Equatable {
        enum FocusField {
            case inputName
            case datePicker
            case memo
        }
        @BindingState var textInput: String = ""
        var focusField: FocusField? = nil   
    }

    enum Action: BindableAction {
        // MARK: User Action
        case binding(BindingAction<State>)
        case setFocus(CreationFeature.State.FocusField?)

        // MARK: Inner Business Action
        case _onAppear

        // MARK: Inner SetState Action

        // MARK: Child Action
    }


    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce<State, Action> { state, action in
            switch action {
            case .binding:
                return .none
            case ._onAppear:
                return .none
            case .setFocus(let focusField):
                state.focusField = focusField
                return .none
            }
        }
    }
}
