//
//  Counter.swift
//  TCACase
//
//  Created by Jeong Deokho on 7/29/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct ScreenFeatureA {
    @ObservableState
    struct State: Equatable {

    }

    enum Action {
        case screenBButtonTapped
        case dismissButtonTapped
    }

    @Dependency(\.dismiss) var dismiss

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .screenBButtonTapped:
                return.none
            case .dismissButtonTapped:
                return .run { _ in
                    await self.dismiss()
                }
            }
        }
    }
}

@Reducer
struct ScreenFeatureB {
    @ObservableState
    struct State: Equatable {
    }

    enum Action {
        case screenCButtonTapped
        case dismissButtonTapped
    }

    @Dependency(\.dismiss) var dismiss

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .screenCButtonTapped:
                return .none
            case .dismissButtonTapped:
                return .run { _ in
                    await self.dismiss()
                }
            }
        }
    }
}


@Reducer
struct ScreenFeatureC {
    @ObservableState
    struct State: Equatable {
    }

    enum Action {
        case screenAButtonTapped
        case dismissButtonTapped
    }

    @Dependency(\.dismiss) var dismiss

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .screenAButtonTapped:
                return .none
            case .dismissButtonTapped:
                return .run { _ in
                    await self.dismiss()
                }
            }
        }
    }
}
