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
        var counter: Counter.State?
        var isActivityIndicatorVisible = false
    }

    enum Action {
        case counter(Counter.Action)
        case counterButtonTapped(Bool)
        case counterPresentationDelayCompleted
    }

    @Dependency(\.continuousClock) var clock

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .counter:
                return .none
            case .counterButtonTapped(isPresented: true):
                state.isActivityIndicatorVisible = true
                return .run { send in
                    try await self.clock.sleep(for: .seconds(1))
                    await send(.counterPresentationDelayCompleted)
                }
            case .counterButtonTapped(isPresented: false):
                state.isActivityIndicatorVisible = false
                state.counter = nil
                return .none
            case .counterPresentationDelayCompleted:
                state.counter = Counter.State()
                return .none
            }
        }
        .ifLet(\.counter, action: \.counter) {
            Counter()
        }
    }
}
