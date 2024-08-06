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
        var currentFact: String?
        var isFactRequestInFlight = false
    }

    enum Action {
        case cancelButtonTap
        case stepperChanged(Int)
        case factButtonTap
        case factResponse(Result<String, Error>)
    }

    @Dependency(\.factClient) var factClient
    private enum CancelID { case factRequest }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .cancelButtonTap:
                state.isFactRequestInFlight = false
                return .cancel(id: CancelID.factRequest)
            case .stepperChanged(let value):
                state.count = value
                state.currentFact = nil
                state.isFactRequestInFlight = false
                return .cancel(id: CancelID.factRequest)
            case .factButtonTap:
                state.currentFact = nil
                state.isFactRequestInFlight = true
                return .run { [state] send in
                    await send(.factResponse(Result { try await self.factClient.fetch(state.count) }))
                }
                .cancellable(id: CancelID.factRequest)
            case .factResponse(let result):
                switch result {
                case .success(let response):
                    state.isFactRequestInFlight = false
                    state.currentFact = response
                case .failure(let error):
                    state.isFactRequestInFlight = false
                    state.currentFact = error.localizedDescription
                }
            }
            return .none
        }
    }
}















@DependencyClient
struct FactClient {
  var fetch: @Sendable (Int) async throws -> String
}

extension DependencyValues {
  var factClient: FactClient {
    get { self[FactClient.self] }
    set { self[FactClient.self] = newValue }
  }
}

extension FactClient: DependencyKey {
  /// This is the "live" fact dependency that reaches into the outside world to fetch trivia.
  /// Typically this live implementation of the dependency would live in its own module so that the
  /// main feature doesn't need to compile it.
  static let liveValue = Self(
    fetch: { number in
      try await Task.sleep(for: .seconds(1))
      let (data, _) = try await URLSession.shared
        .data(from: URL(string: "https://picsum.photos/id/\(number)/200/300")!)
      return String(decoding: data, as: UTF8.self)
    }
  )

  /// This is the "unimplemented" fact dependency that is useful to plug into tests that you want
  /// to prove do not need the dependency.
  static let testValue = Self()
}
