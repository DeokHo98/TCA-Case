//
//  Counter.swift
//  TCACase
//
//  Created by Jeong Deokho on 7/29/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct Counter {
    @ObservableState
    struct State: Equatable {
        var count = 0
    }

    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                return .none
            case .incrementButtonTapped:
                state.count += 1
                return .none
            }
        }
    }
}

struct CounterView: View {
    let store: StoreOf<Counter>

    var body: some View {
        HStack {
            Button {
                store.send(.decrementButtonTapped)
            } label: {
                Image(systemName: "minus")
            }

            Text("\(store.count)")
                .monospacedDigit()

            Button {
                store.send(.incrementButtonTapped)
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}
