//
//  TCACaseTests.swift
//  TCACaseTests
//
//  Created by Jeong Deokho on 2024/05/07.
//

import ComposableArchitecture
import XCTest

@testable import TCACase

final class TCACaseUITests: XCTestCase {
    let store = TestStore(initialState: Feature.State()) {
        Feature()
    }

    func testFocus() async {
        await store.send(\.binding.username, "test_userName") {
            $0.username = "test_userName"
        }
        await store.send(\.binding.password, "test_pw") {
            $0.password = "test_pw"
        }
        await store.send(\.binding.password, "") {
            $0.password = ""
        }
        await store.send(.signInButtonTap) {
            $0.focusedField = .password
        }
        await store.send(\.binding.username, "") {
            $0.username = ""
        }
        await store.send(.signInButtonTap) {
            $0.focusedField = .username
        }
        await store.send(.userNameTextFieldEnterTap) {
            $0.focusedField = .password
        }
        await store.send(.passwordTextFieldEnterTap) {
            $0.focusedField = nil
        }
    }
}
