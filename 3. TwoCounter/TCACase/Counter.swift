//
//  Counter.swift
//  TCACase
//
//  Created by Jeong Deokho on 5/21/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct Counter {
    @ObservableState
    struct State: Equatable {
        var count = 0
    }

    enum Action {
        case plushButtonTap
        case minusButtonTap
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .plushButtonTap:
                state.count += 1
            case .minusButtonTap:
                state.count -= 1
            }
            return .none
        }
    }
}
