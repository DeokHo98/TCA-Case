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
    func testToggleCounterButtonTap() async {
        let store = TestStore(initialState: Feature.State()) {
            Feature()
        }

        await store.send(.toggleCounterButtonTap) {
            $0.counterState = Counter.State()
        }

        await store.send(.toggleCounterButtonTap) {
            $0.counterState = nil
        }
    }

}
