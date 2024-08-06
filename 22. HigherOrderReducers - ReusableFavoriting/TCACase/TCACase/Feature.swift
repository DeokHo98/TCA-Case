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
        @Presents var alert: AlertState<Action.Alert>?
        var id: UUID
        var isFavorite: Bool

        init(id: UUID?, isFavorite: Bool) {
            @Dependency(\.uuid) var uuid
            self.id = id ?? uuid()
            self.isFavorite = isFavorite
        }
    }

    enum Action {
        case alert(PresentationAction<Alert>)
        case buttonTap


        enum Alert: Equatable { }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .alert(.dismiss):
                state.alert = nil
                state.isFavorite.toggle()
            case .buttonTap:
                let random = Bool.random()
                state.isFavorite.toggle()
                state.alert = random ? AlertState { TextState("에러") } : nil
            }
            return .none
        }
    }
}
