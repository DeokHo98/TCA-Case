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
        var count = 0
        var isNumberFactRequestInFlight = false
        var numberFact: String?
    }

    enum Action {
        case decrementButtonTap
        case decrementDelayResponse
        case incrementButtonTap
        case numberFactButtonTap
        case numberFactResponse(Result<String, Error>)
    }

    @Dependency(\.continuousClock) var clock
    @Dependency(\.factClient) var factClient
    private enum CancelID { case delay }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTap:
                state.count -= 1
                state.numberFact = nil
                return state.count >= 0
                ? .none
                : .run(operation: { send in
                    try await self.clock.sleep(for: .seconds(1))
                    await send(.decrementDelayResponse)
                })
                .cancellable(id: CancelID.delay)
            case .decrementDelayResponse:
                if state.count < 0 {
                    state.count += 1
                }
                return .none
            case .incrementButtonTap:
                state.count += 1
                state.numberFact = nil
                return state.count >= 0
                ? .cancel(id: CancelID.delay)
                : .none
            case .numberFactButtonTap:
                state.isNumberFactRequestInFlight =  true
                state.numberFact = nil
                return .run { [state] send in
                    await send(.numberFactResponse(Result { try await self.factClient.fetch(state.count) }))
                }
            case .numberFactResponse(.success(let response)):
                state.isNumberFactRequestInFlight = false
                state.numberFact = response
                return .none
            case .numberFactResponse(.failure(let error)):
                state.isNumberFactRequestInFlight = false
                state.numberFact = error.localizedDescription
                return .none
            }
        }
    }
}
