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
        var isTimerActive = false
        var secondsElapsed = 0
    }

    enum Action {
        case onDisappear
        case timerTicked
        case toggleTimerButtonTapped
    }

    @Dependency(\.continuousClock) var clock
    private enum CancelID { case timer }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onDisappear:
                return .cancel(id: CancelID.timer)
            case .timerTicked:
                state.secondsElapsed += 1
                return .none
            case .toggleTimerButtonTapped:
                state.isTimerActive.toggle()
                return .run { [state] send in
                    guard state.isTimerActive else { return }
                    for await _ in self.clock.timer(interval: .seconds(1)) {
                        await send(.timerTicked, animation: .interpolatingSpring(stiffness: 200, damping: 20))
                    }
                }
                .cancellable(id: CancelID.timer, cancelInFlight: true)
            }
        }
    }
}
