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
        var rows: IdentifiedArrayOf<Row> = []
        var selection: Row?

        struct Row: Equatable, Identifiable {
            var num: Int
            let id: UUID
        }
    }

    enum Action {
        case addRow
        case setSelection(State.Row?)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addRow:
                let num = state.rows.count + 1
                let row = State.Row(num: num, id: UUID())
                state.rows.append(row)
                return .none
            case .setSelection(let row):
                state.selection = row
                return .none
            }
        }
    }
}
