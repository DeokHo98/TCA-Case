//
//  WeatherDetailFeature.swift
//  TCACase
//
//  Created by Jeong Deokho on 7/31/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct WeatherDetailFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var alertState: AlertState<Action.Alert>?
        let cityModel: CitySearchModel.Result
        var weatherModel: WeatherModel?
        var isLoading = true
        var dismiss = false
    }

    enum Action {
        case alertAction(PresentationAction<Alert>)
        case getWeatherData
        case weatherResponse(Result<WeatherModel, Error>)

        enum Alert: Equatable { }
    }

    @Dependency(\.weatherClient) var weatherClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .alertAction:
                state.dismiss = true
                return .none
            case .getWeatherData:
                return .run { [state] send in
                    await send(
                        .weatherResponse(
                            Result {
                                try await self.weatherClient.getWeatherData(state.cityModel)
                            }
                        )
                    )
                }
            case .weatherResponse(.success(let model)):
                state.isLoading = false
                state.weatherModel = model
                return .none
            case .weatherResponse(.failure(let error)):
                state.isLoading = false
                state.alertState = AlertState { TextState(error.localizedDescription) }
                return .none
            }
        }
        .ifLet(\.alertState, action: \.alertAction)
    }
}
