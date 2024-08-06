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
    func test_Reqeust_성공_테스트() async {
        let store = TestStore(initialState: Feature.State()) {
            Feature()
        } withDependencies: {
            $0.factClient.fetch = { "\($0) is a good number" }
        }

        await store.send(.stepperChanged(1)) {
            $0.count = 1
        }

        await store.send(.factButtonTap) {
            $0.isFactRequestInFlight = true
        }

        await store.receive(\.factResponse.success) {
            $0.currentFact = "1 is a good number"
            $0.isFactRequestInFlight = false
        }
    }

    @MainActor
    func test_Request_실패_테스트() async {
        struct FactError: Equatable, Error {
        }

        let store = TestStore(initialState: Feature.State()) {
            Feature()
        } withDependencies: {
            $0.factClient.fetch = { _ in throw FactError() }
        }

        await store.send(.factButtonTap) {
            $0.isFactRequestInFlight = true
        }

        await store.receive(\.factResponse.failure) {
            $0.currentFact = FactError().localizedDescription
            $0.isFactRequestInFlight = false
        }
    }

    @MainActor
    func test_CancelButton_클릭시_Request가_취소되는지() async {
        let store = TestStore(initialState: Feature.State()) {
            Feature()
        } withDependencies: {
            $0.factClient.fetch = { _ in try await Task.never() }
        }

        await store.send(.factButtonTap) {
            $0.isFactRequestInFlight = true
        }

        await store.send(.cancelButtonTap) {
            $0.isFactRequestInFlight = false
        }
    }

}
