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
    func testShared() async {
        let counterStore = TestStore(initialState: CounterTab.State()) {
            CounterTab()
        }
        let profileStore = TestStore(initialState: ProfileTab.State()) {
            ProfileTab()
        }

        await counterStore.send(\.incrementButtonTapped) {
            let equalStats = Stats(count: 1, maxCount: 1, numberOfCounts: 1)
            $0.stats = equalStats
            XCTAssertEqual(profileStore.state.stats, equalStats)

        }
    }
}
