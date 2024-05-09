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

    var store: TestStore<Feature.State, Feature.Action>!

    override func setUpWithError() throws {
        self.store = TestStore(initialState: Feature.State()) {
            Feature()
        }
    }

    override func tearDownWithError() throws {
        self.store = nil
    }

    func test_TextFeildAction() async {
        await store.send(\.textFeildEditing, "가나다라마바사") {
            $0.text = "가나다라마바사"
        }
    }

    func test_steeperAction() async {
        await store.send(\.stepperChanged, 10) {
            $0.stepCount = 10
            $0.sliderValue = .minimum($0.sliderValue, 10.0)
        }
    }

    func test_sliderAction() async {
        await store.send(\.sliderChanged, 10) {
            $0.sliderValue = 10
        }
    }

    func test_toggleAction() async {
        await store.send(\.toggleChnaged, true) {
            $0.toggleIsOn = true
            $0.opacity = 0.0
        }
    }

}
