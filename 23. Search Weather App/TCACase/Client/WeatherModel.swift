//
//  WeatherModel.swift
//  TCACase
//
//  Created by Jeong Deokho on 7/31/24.
//

import Foundation

struct CitySearchModel: Decodable, Equatable, Sendable {
    var results: [Result]

    struct Result: Decodable, Equatable, Identifiable, Sendable {
        var id: Int
        var country: String
        var latitude: Double
        var longitude: Double
        var name: String
        var admin1: String?
    }
}

extension CitySearchModel {
    static let mock = Self(
        results: [
            Result(
                id: 1,
                country: "미국",
                latitude: 40.6782,
                longitude: -73.9442,
                name: "브루클린"
            ),
            Result(
                id: 1,
                country: "한국",
                latitude: 42.6782,
                longitude: -70.9442,
                name: "서울"
            )
        ]
    )
}

struct WeatherModel: Decodable, Equatable, Sendable {
    var daily: Daily?

    struct Daily: Decodable, Equatable, Sendable {
        var tempMax: [Double]
        var tempMin: [Double]
        var time: [String]

        private enum CodingKeys: String, CodingKey {
            case tempMax = "temperature_2m_max"
            case tempMin = "temperature_2m_min"
            case time
        }
    }
}

extension WeatherModel {
    static let mock = Self(
        daily: Daily(
            tempMax: [10, 20, 30],
            tempMin: [1, 2, 3],
            time: ["2024-07-29", "2024-07-30", "2024-07-31"]
        )
    )
}


