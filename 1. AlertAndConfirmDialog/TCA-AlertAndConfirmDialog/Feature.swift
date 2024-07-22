//
//  Feature.swift
//  TCA-AlertAndConfirmDialog
//
//  Created by Jeong Deokho on 2024/05/03.
//

import Foundation
import ComposableArchitecture

@Reducer
struct Feature {
    @ObservableState
    struct State: Equatable {
        @Presents var destinationState: Destination.State?
        var count = 0
    }

    enum Action {
        case alertButtonTap
        case dialogButtonTap

        case destinationAction(PresentationAction<Destination.Action>)

        @CasePathable
        enum Alert {
            case incrementButtonTap
        }

        @CasePathable
        enum Dialog {
            case incrementButtonTap
            case decrementButtonTap
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .alertButtonTap:
                state.destinationState = .alert(.alert())
            case .dialogButtonTap:
                state.destinationState = .confirmDialog(.confirmationDialog())

            case .destinationAction(let action):
                if case .presented(.alert(.incrementButtonTap)) = action {
                    state.count += 1
                }
                if case .presented(.confirmDialog(.incrementButtonTap)) = action {
                    state.count += 1
                }
                if case .presented(.confirmDialog(.decrementButtonTap)) = action {
                    state.count -= 1
                }
                state.destinationState = nil
            }
            return .none
        }
        .ifLet(\.$destinationState, action: \.destinationAction)
    }
}

extension Feature {
    @Reducer(state: .equatable)
    enum Destination {
        case alert(AlertState<Feature.Action.Alert>)
        case confirmDialog(ConfirmationDialogState<Feature.Action.Dialog>)
    }
}

extension AlertState where Action == Feature.Action.Alert {
    static func alert() -> Self {
        AlertState(title: {
            TextState("Alert")
        }, actions: {
            ButtonState(role: .cancel) {
                TextState("취소")
            }
            ButtonState(action: .incrementButtonTap) {
                TextState("더하기")
            }
        })
    }
}

extension ConfirmationDialogState where Action == Feature.Action.Dialog {
    static func confirmationDialog() -> Self {
        ConfirmationDialogState(title: {
            TextState("Dialog")
        }, actions: {
            ButtonState(role: .cancel) {
                TextState("취소")
            }
            ButtonState(action: .incrementButtonTap) {
                TextState("더하기")
            }
            ButtonState(action: .decrementButtonTap) {
                TextState("빼기")
            }
        })
    }
}
