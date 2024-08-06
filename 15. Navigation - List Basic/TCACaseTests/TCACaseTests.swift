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
    func testSetSelection() async {
         let row1 = Feature.State.Row(num: 1, id: UUID())
         let row2 = Feature.State.Row(num: 2, id: UUID())

         let initialState = Feature.State(
             rows: [row1, row2],
             selection: nil
         )

        let store = TestStore(initialState: initialState) {
            Feature()
        }
         // Test selecting the first row
         await store.send(.setSelection(row1)) {
             $0.selection = row1
         }

         // Test selecting the second row
         await store.send(.setSelection(row2)) {
             $0.selection = row2
         }

         // Test deselecting the row
         await store.send(.setSelection(nil)) {
             $0.selection = nil
         }
     }

}
