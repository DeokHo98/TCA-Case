//
//  Feature.swift
//  TCACase
//
//  Created by Jeong Deokho on 2024/05/07.
//

import ComposableArchitecture
import Foundation

@Reducer
struct Feature {
    @ObservableState
    struct State: Equatable {
        var counter1State = Counter.State()
        var counter2State = Counter.State()
    }

    enum Action {
        case plusButtonTap
        case minusButtonTap
        case counter1Action(Counter.Action)
        case counter2Action(Counter.Action)
    }


    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .plusButtonTap:
                state.counter1State.count += 1
                state.counter2State.count += 1
            case .minusButtonTap:
                state.counter1State.count -= 1
                state.counter2State.count -= 1
            case .counter1Action:
                return .none
            case .counter2Action:
                return .none
            }
            return .none
        }
        Scope(state: \.counter1State, action: \.counter1Action) {
            Counter()
        }
        Scope(state: \.counter2State, action: \.counter2Action) {
            Counter()
        }
    }
}

