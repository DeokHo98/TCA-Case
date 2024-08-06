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
    func testAddRow() async {
        let store = TestStore(initialState: Feature.State()) {
            Feature()
        } withDependencies: {
            $0.uuid = .incrementing
        }

        await store.send(.addRowButtonTapped) {
            $0.rows.append(Feature.State(id: UUID(0)))
        }

        await store.send(\.rows[id: UUID(0)].addRowButtonTapped) {
            $0.rows[id: UUID(0)]?.rows.append(Feature.State(id: UUID(1)))
        }
    }

    @MainActor
    func testChangeName() async {
        let store = TestStore(initialState: Feature.State()) {
            Feature()
        }

        await store.send(.nameTextFieldChanged("가나다라")) {
            $0.name = "가나다라"
        }
    }

    @MainActor
    func testDeleteRow() async {
        let store = TestStore(initialState: Feature.State(id: UUID(), rows: [Feature.State(id: UUID(0)),
                                                                             Feature.State(id: UUID(1))])) {
            Feature()
        }

        await store.send(.onDelete(IndexSet(integer: 1))) {
            $0.rows.remove(id: UUID(1))
        }
    }

}
