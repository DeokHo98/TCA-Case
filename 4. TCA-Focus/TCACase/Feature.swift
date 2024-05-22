//
//  Feature.swift
//  TCACase
//
//  Created by Jeong Deokho on 2024/05/07.
//

import Foundation
import ComposableArchitecture

@Reducer
struct Feature {
    @ObservableState
    struct State: Equatable {
        var focusedField: Field?
        var password: String = ""
        var username: String = ""

        enum Field: String, Hashable {
            case username, password
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case userNameTextFieldEnterTap
        case passwordTextFieldEnterTap
        case signInButtonTap
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .userNameTextFieldEnterTap:
                state.focusedField = .password
            case .passwordTextFieldEnterTap:
                state.focusedField = nil
            case .signInButtonTap:
                if state.username.isEmpty {
                    state.focusedField = .username
                } else if state.password.isEmpty {
                    state.focusedField = .password
                }
            case .binding:
                return .none
            }
            return .none
        }
    }
}
