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
    @Reducer(state: .equatable)
    enum Path {
        case screenA(ScreenFeatureA)
        case screenB(ScreenFeatureB)
        case screenC(ScreenFeatureC)
    }

    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
    }

    enum Action {
        case goBackToScreen(id: StackElementID)
        case goToABCButtonTapped
        case path(StackActionOf<Path>)
        case popToRoot
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .goBackToScreen(let id):
                state.path.pop(to: id)
                return .none
            case .goToABCButtonTapped:
                state.path.append(.screenA(ScreenFeatureA.State()))
                state.path.append(.screenB(ScreenFeatureB.State()))
                state.path.append(.screenC(ScreenFeatureC.State()))
                return .none
            case .path(let action):
                switch action {
                case .element(id: _, action: .screenA(.screenBButtonTapped)):
                    state.path.append(.screenB(ScreenFeatureB.State()))
                    return .none
                case .element(id: _, action: .screenB(.screenCButtonTapped)):
                    state.path.append(.screenC(ScreenFeatureC.State()))
                    return .none
                case .element(id: _, action: .screenC(.screenAButtonTapped)):
                    state.path.append(.screenA(ScreenFeatureA.State()))
                    return .none
                default: return .none
                }
            case .popToRoot:
                state.path.removeAll()
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
