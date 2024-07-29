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
    func testCountDown() async {
        let store = TestStore(initialState: Feature.State()) {
            Feature()
        } withDependencies: {
            $0.continuousClock = ImmediateClock()
        }

        await store.send(.incrementButtonTap) {
            $0.count = 1
        }
        await store.send(.decrementButtonTap) {
            $0.count = 0
        }
    }

    @MainActor
    func testNumberFact() async {
        let store = TestStore(initialState: Feature.State()) {
            Feature()
        } withDependencies: {
            $0.factClient.fetch = { "\($0) is a good number Brent" }
            $0.continuousClock = ImmediateClock()
        }

        await store.send(.incrementButtonTap) {
            $0.count = 1
        }
        await store.send(.numberFactButtonTap) {
          $0.isNumberFactRequestInFlight = true
        }
        await store.receive(\.numberFactResponse.success) {
            $0.isNumberFactRequestInFlight = false
            $0.numberFact = "1 is a good number Brent"
        }
    }

    @MainActor
    func testDecrement() async {
        let store = TestStore(initialState: Feature.State()) {
            Feature()
        } withDependencies: {
            $0.continuousClock = ImmediateClock()
        }

        await store.send(.decrementButtonTap) {
            $0.count = -1
        }
        await store.receive(\.decrementDelayResponse) {
            $0.count = 0
        }
    }

    @MainActor
    func testDecrementCancellation() async {
        let store = TestStore(initialState: Feature.State()) {
            Feature()
        } withDependencies: {
            $0.continuousClock = TestClock()
        }

        await store.send(.decrementButtonTap) {
            $0.count = -1
        }
        await store.send(.incrementButtonTap) {
            $0.count = 0
        }
    }


}
