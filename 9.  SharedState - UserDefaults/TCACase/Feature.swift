//
//  Feature.swift
//  TCACase
//
//  Created by Jeong Deokho on 2024/05/07.
//

import Foundation
import ComposableArchitecture

enum Tab {
    case main
    case profile
}

@Reducer
struct Feature {
    @ObservableState
    struct State: Equatable {
        var currentTab = Tab.main
        var main = MainTap.State()
        var profile = ProfileTap.State()
    }

    enum Action {
        case main(MainTap.Action)
        case profile(ProfileTap.Action)
        case selectTab(Tab)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.main, action: \.main) {
          MainTap()
        }

        Scope(state: \.profile, action: \.profile) {
          ProfileTap()
        }

        Reduce { state, action in
            switch action {
            case .main, .profile:
              return .none
            case let .selectTab(tab):
              state.currentTab = tab
              return .none
            }
        }
    }
}

extension Feature {
    @Reducer
    struct MainTap {
        @ObservableState
        struct State: Equatable {
            @Shared(.isLogin) var isLogin = false
        }

        enum Action {
            case loginButtonTap
            case logoutButtonTap
        }

        var body: some ReducerOf<Self> {
            Reduce { state, action in
                switch action {
                case .loginButtonTap:
                    state.isLogin = true
                case .logoutButtonTap:
                    state.isLogin = false
                }
                return .none
            }
        }
    }

    @Reducer
    struct ProfileTap {
        @ObservableState
        struct State: Equatable {
            @Shared(.isLogin) var isLogin = false
        }

        enum Action {
            case loginButtonTap
            case logoutButtonTap
        }

        var body: some ReducerOf<Self> {
            Reduce { state, action in
                switch action {
                case .loginButtonTap:
                    state.isLogin = true
                case .logoutButtonTap:
                    state.isLogin = false
                }
                return .none
            }
        }
    }
}

extension PersistenceReaderKey where Self == AppStorageKey<Bool> {
  fileprivate static var isLogin: Self {
    appStorage("sharedStateIsLogin")
  }
}
