//
//  WeatherClient.swift
//  TCACase
//
//  Created by Jeong Deokho on 7/31/24.
//

import Foundation
import ComposableArchitecture

@DependencyClient
struct WeatherClient {
    var citySearch: @Sendable (_ query: String) async throws -> CitySearchModel
    var getWeatherData: @Sendable (_ cityModel: CitySearchModel.Result) async throws -> WeatherModel
}

extension DependencyValues {
    var weatherClient: WeatherClient {
        get { self[WeatherClient.self] }
        set { self[WeatherClient.self] = newValue }
    }
}

extension WeatherClient: DependencyKey {
    static let liveValue = WeatherClient(
        citySearch: {
            try await API.Weather.citySearch(query: $0).request()
        },
        getWeatherData: {
            try await API.Weather.getWeatherData(
                latitude: $0.latitude,
                longitude: $0.longitude
            ).request()
        }
    )
}

extension WeatherClient: TestDependencyKey {
    static let previewValue = Self(
        citySearch: { _ in .mock },
        getWeatherData: { _ in .mock }
    )

    static let testValue = Self()
}



