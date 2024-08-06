//
//  TCACaseTests.swift
//  TCACaseTests
//
//  Created by Jeong Deokho on 2024/05/07.
//

import XCTest
import ComposableArchitecture
@testable import TCACase

final class TCACaseTests: XCTestCase {

    @MainActor
    func testHappyPath() async {
        let store = TestStore(initialState: Feature.State()) {
            Feature()
        } withDependencies: {
            $0.factClient.fetch = { "\($0) is good number." }
        }

        await store.send(.incrementButtonTap) {
            $0.count = 1
        }
        await store.send(.refresh)
        await store.receive(\.factResponse.success) {
            $0.fact = "1 is good number."
        }
    }

    @MainActor
    func testCancellation() async {
      let store = TestStore(initialState: Feature.State()) {
          Feature()
      } withDependencies: {
        $0.factClient.fetch = {
          try await Task.sleep(for: .seconds(1))
          return "\($0) is a good number."
        }
        $0.continuousClock = ImmediateClock()
      }

        await store.send(.incrementButtonTap) {
        $0.count = 1
      }
      await store.send(.refresh)
      await store.send(.cancelButtonTap)
    }

}
