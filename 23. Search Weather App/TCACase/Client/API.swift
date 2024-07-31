//
//  API.swift
//  TCACase
//
//  Created by Jeong Deokho on 7/31/24.
//

import Foundation

protocol APIEndPoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
}

extension APIEndPoint {
    func request<T: Decodable>() async throws -> T {
        guard var compoents = URLComponents(string: self.baseURL) else {
            throw URLError(.badURL)
        }
        compoents.path = self.path
        compoents.queryItems = self.queryItems
        guard let url = compoents.url else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue
        request.timeoutInterval = 10
        let (data, _) = try await URLSession.shared.data(for: request)
        let model = try JSONDecoder().decode(T.self, from: data)
        return model
    }
}

enum HTTPMethod: String {
    case get = "GET"
}

enum API { }

extension API {
    enum Weather {
        case citySearch(query: String)
        case getWeatherData(latitude: Double, longitude: Double)
    }
}

extension API.Weather: APIEndPoint {
    var baseURL: String {
        switch self {
        case .citySearch:
            return "https://geocoding-api.open-meteo.com"
        case .getWeatherData:
            return "https://api.open-meteo.com"
        }
    }

    var path: String {
        switch self {
        case .citySearch:
            return "/v1/search"
        case .getWeatherData:
            return "/v1/forecast"
        }
    }

    var method: HTTPMethod {
        return .get
    }

    var queryItems: [URLQueryItem] {
         switch self {
         case .citySearch(let query):
             return [URLQueryItem(name: "name", value: query)]
         case .getWeatherData(let latitude, let longitude):
             return [
                 URLQueryItem(name: "latitude", value: "\(latitude)"),
                 URLQueryItem(name: "longitude", value: "\(longitude)"),
                 URLQueryItem(name: "daily", value: "temperature_2m_max,temperature_2m_min"),
                 URLQueryItem(name: "timezone", value: TimeZone.autoupdatingCurrent.identifier)
             ]
         }
     }
}
