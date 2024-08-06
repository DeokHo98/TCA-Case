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
    func testStart() async {
        let clock = TestClock()

        let store = TestStore(initialState: Feature.State()) {
            Feature()
        } withDependencies: {
            $0.continuousClock = clock
        }

        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerActive = true
        }

        await clock.advance(by: .seconds(1))
        await store.receive(\.timerTicked) {
            $0.secondsElapsed = 1
        }

        await clock.advance(by: .seconds(5))
        await store.receive(\.timerTicked) {
          $0.secondsElapsed = 2
        }
        await store.receive(\.timerTicked) {
          $0.secondsElapsed = 3
        }
        await store.receive(\.timerTicked) {
          $0.secondsElapsed = 4
        }
        await store.receive(\.timerTicked) {
          $0.secondsElapsed = 5
        }
        await store.receive(\.timerTicked) {
          $0.secondsElapsed = 6
        }

        await store.send(.toggleTimerButtonTapped) {
          $0.isTimerActive = false
        }
    }

}
