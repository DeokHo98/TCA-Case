//
//  TCACaseTests.swift
//  TCACaseTests
//
//  Created by Jeong Deokho on 2024/05/07.
//

import XCTest
import ComposableArchitecture
@testable import TCACase

struct MockError: Error { }

extension MockError: LocalizedError {
    var errorDescription: String? {
        return "error"
    }
}

final class TCACaseTests: XCTestCase {

    @MainActor
    func test_text입력() async {
        let store = TestStore(initialState: SearchFeature.State()) {
            SearchFeature()
        }

        await store.send(.searchQueryChange("Seoul")) {
            $0.searchQuery = "Seoul"
        }
    }

    @MainActor
    func test_비어있는text_검색() async {
        let store = TestStore(initialState: SearchFeature.State()) {
            SearchFeature()
        }

        await store.send(.search) {
            $0.alertState = AlertState { TextState("Please enter") }
        }
    }

    @MainActor
    func test_검색_성공() async {
        let store = TestStore(initialState: SearchFeature.State()) {
            SearchFeature()
        } withDependencies: {
            $0.weatherClient.citySearch = { @Sendable _ in .mock }
        }

        await store.send(.searchQueryChange("Seoul")) {
            $0.searchQuery = "Seoul"
        }

        await store.send(.search) {
            $0.isLoading = true
        }

        await store.receive(\.searchResponse) {
            $0.isLoading = false
            $0.detailFeatureState = IdentifiedArrayOf(
                uniqueElements: CitySearchModel.mock.results.map {
                    WeatherDetailFeature.State(cityModel: $0, id: $0.id)
                }
            )
        }
    }

    @MainActor
    func test_검색_실패() async {
        let store = TestStore(initialState: SearchFeature.State()) {
            SearchFeature()
        } withDependencies: {
            $0.weatherClient.citySearch = { @Sendable _ in throw MockError() }
        }

        await store.send(.searchQueryChange("Seoul")) {
            $0.searchQuery = "Seoul"
        }

        await store.send(.search) {
            $0.isLoading = true
        }

        await store.receive(\.searchResponse) {
            $0.isLoading = false
            $0.detailFeatureState = []
            $0.alertState = AlertState { TextState("\(MockError().localizedDescription)") }
        }
    }

    @MainActor
    func test_날씨_데이터_응답_성공() async {
        let store = TestStore(
            initialState: WeatherDetailFeature.State(
                cityModel: CitySearchModel.mock.results.first!,
                id: 1
            )
        ) {
            WeatherDetailFeature()
        } withDependencies: {
            $0.weatherClient.getWeatherData = { @Sendable _ in .mock }
        }

        await store.send(.getWeatherData)
        await store.receive(\.weatherResponse) {
            $0.isLoading = false
            $0.weatherModel = WeatherModel.mock
        }
    }

    @MainActor
    func test_날씨_데이터_응답_실패() async {
        let store = TestStore(
            initialState: WeatherDetailFeature.State(
                cityModel: CitySearchModel.mock.results.first!,
                id: 1
            )
        ) {
            WeatherDetailFeature()
        } withDependencies: {
            $0.weatherClient.getWeatherData = { @Sendable _ in throw MockError() }
        }

        await store.send(.getWeatherData)
        await store.receive(\.weatherResponse) {
            $0.isLoading = false
            $0.alertState = AlertState { TextState(MockError().localizedDescription) }
        }
    }

    @MainActor
    func test_날씨_데이터_응답_실패_화면닫힘() async {
        let store = TestStore(
            initialState: WeatherDetailFeature.State(
                alertState: AlertState { TextState(MockError().localizedDescription) },
                cityModel: CitySearchModel.mock.results.first!,
                id: 1
            )
        ) {
            WeatherDetailFeature()
        }

        await store.send(.alertAction(.dismiss)) {
            $0.alertState = nil
            $0.dismiss = true
        }
    }
}
