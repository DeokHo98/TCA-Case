//
//  TCA_AlertAndConfirmDialogTests.swift
//  TCA-AlertAndConfirmDialogTests
//
//  Created by Jeong Deokho on 2024/05/03.
//

import XCTest
import ComposableArchitecture

@testable import TCA_AlertAndConfirmDialog

final class TCA_AlertAndConfirmDialogTests: XCTestCase {

    var store: TestStore<Feature.State, Feature.Action>!

    override func setUp() {
        store = TestStore(initialState: Feature.State()) {
            Feature()
        }
    }

    override func tearDown() {
        store = nil
    }

    func test_alert() async {
        await store.send(.alertButtonTap) {
            $0.destinationState = .alert(.alert())
        }

        await store.send(\.destinationAction.alert.incrementButtonTap) {
            $0.count = 1
            $0.destinationState = nil
        }
    }

    func test_confirmDialog_incrementButtonTap() async {
        await store.send(.dialogButtonTap) {
            $0.destinationState = .confirmDialog(.confirmationDialog())
        }

        await store.send(\.destinationAction.confirmDialog.incrementButtonTap) {
            $0.count = 1
            $0.destinationState = nil
        }
    }

    func test_confirmDialog_decrementButtonTap() async {
        await store.send(.dialogButtonTap) {
            $0.destinationState = .confirmDialog(.confirmationDialog())
        }

        await store.send(\.destinationAction.confirmDialog.decrementButtonTap) {
            $0.count = -1
            $0.destinationState = nil
        }
    }

}
