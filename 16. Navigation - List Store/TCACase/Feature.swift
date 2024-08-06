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
        var counters: IdentifiedArrayOf<Row> = []
        var selection: Identified<Row.ID, Counter.State?>?

        struct Row: Equatable, Identifiable {
            var count: Int
            let id: UUID
        }
    }

    enum Action {
        case addCounter
        case counter(Counter.Action)
        case setSelection(UUID?)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .counter:
                return .none
            case .addCounter:
                state.counters.append(.init(count: 0, id: UUID()))
                return .none
            case .setSelection(.none):
                if let selection = state.selection, let count = selection.value?.count {
                  state.counters[id: selection.id]?.count = count
                }
                state.selection = nil
                return .none
            case .setSelection(.some(let id)):
                let count = state.counters[id: id]?.count ?? 0
                state.selection = Identified(Counter.State(count: count), id: id)
                return .none
            }
        }
        .ifLet(\.selection, action: \.counter) {
          EmptyReducer()
            .ifLet(\.value, action: \.self) {
              Counter()
            }
        }

    }
}
