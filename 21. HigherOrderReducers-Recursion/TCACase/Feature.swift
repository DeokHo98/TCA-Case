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
    struct State: Equatable, Identifiable {
        let id: UUID
        var name: String = ""
        var rows: IdentifiedArrayOf<State> = []

        init(id: UUID? = nil, name: String = "", rows: IdentifiedArrayOf<State> = []) {
            self.id = id ?? UUID()
            self.name = name
            self.rows = rows
        }
    }

    @Dependency(\.uuid) var uuid

    enum Action {
        case addRowButtonTapped
        case nameTextFieldChanged(String)
        case onDelete(IndexSet)
        indirect case rows(IdentifiedActionOf<Feature>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addRowButtonTapped:
                state.rows.append(State(id: self.uuid()))
                return .none
            case .nameTextFieldChanged(let text):
                state.name = text
                return .none
            case .onDelete(let index):
                state.rows.remove(atOffsets: index)
                return .none
            case .rows:
                return .none
            }
        }
        .forEach(\.rows, action: \.rows) {
            Self()
        }
    }
}
