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
        var counterState: Counter.State?
    }

    enum Action {
        case counterAction(Counter.Action)
        case toggleCounterButtonTap
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .toggleCounterButtonTap:
                state.counterState = state.counterState == nil ? Counter.State() : nil
            case .counterAction:
                return .none
            }
            return .none
        }
        .ifLet(\.counterState, action: \.counterAction) {
            Counter()
        }
    }
}
