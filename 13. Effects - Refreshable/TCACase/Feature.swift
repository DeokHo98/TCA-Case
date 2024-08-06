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
        var fact: String?
    }

    enum Action {
        case cancelButtonTap
        case decrementButtonTap
        case incrementButtonTap
        case refresh
        case factResponse(Result<String, Error>)
    }

    @Dependency(\.factClient) var factClient
    private enum CancelID { case factRequest }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .cancelButtonTap:
                return .cancel(id: CancelID.factRequest)
            case .decrementButtonTap:
                state.count -= 1
            case .incrementButtonTap:
                state.count += 1
            case .refresh:
                state.fact = nil
                return .run { [state] send in
                    await send(.factResponse(Result { try await self.factClient.fetch(state.count) }),
                               animation: .default
                    )
                }
                .cancellable(id: CancelID.factRequest)
            case .factResponse(.success(let fact)):
                state.fact = fact
            case .factResponse(.failure(let error)):
                state.fact = error.localizedDescription
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
        .data(from: URL(string: "http://numbersapi.com/\(number)/trivia")!)
      return String(decoding: data, as: UTF8.self)
    }
  )

  /// This is the "unimplemented" fact dependency that is useful to plug into tests that you want
  /// to prove do not need the dependency.
  static let testValue = Self()
}
