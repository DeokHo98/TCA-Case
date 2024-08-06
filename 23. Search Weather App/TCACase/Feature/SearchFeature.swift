//
//  SearchFeature.swift
//  TCACase
//
//  Created by Jeong Deokho on 2024/05/07.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SearchFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var alertState: AlertState<Action.Alert>?
        var isLoading: Bool = false
        var searchQuery = ""
        var detailFeatureState: IdentifiedArrayOf<WeatherDetailFeature.State> = []

    }

    enum Action {
        case alertAction(PresentationAction<Alert>)
        case search
        case searchQueryChange(String)
        case searchResponse(Result<CitySearchModel, Error>)
        case detailFeatureAction(IdentifiedAction<WeatherDetailFeature.State.ID, WeatherDetailFeature.Action>)

        enum Alert: Equatable { }
    }

    @Dependency(\.weatherClient) var weatherClient
    private enum CancelID {
        case request
    }
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .alertAction:
                return .none
            case .search:
                guard state.searchQuery.isEmpty == false else {
                    state.alertState = AlertState { TextState("Please enter") }
                    return .none
                }
                state.isLoading = true
                return .concatenate(
                    .cancel(id: CancelID.request),
                    .run { [state] send in
                        await send(
                            .searchResponse(
                                Result {
                                    try await self.weatherClient.citySearch(query: state.searchQuery)
                                }
                            )
                        )
                    }.cancellable(id: CancelID.request, cancelInFlight: true)
                )
            case .searchQueryChange(let query):
                state.searchQuery = query
                return .none
            case .searchResponse(.failure(let error)):
                state.isLoading = false
                state.detailFeatureState = []
                state.alertState = AlertState { TextState("\(error.localizedDescription)") }
                return .none
            case .searchResponse(.success(let model)):
                state.isLoading = false
                state.detailFeatureState = IdentifiedArrayOf(
                    uniqueElements: model.results.map {
                        WeatherDetailFeature.State(cityModel: $0, id: $0.id)
                    }
                )
                return .none
            case .detailFeatureAction(.element(let id, let action)):
                // Detail화면에서 액션을 받고싶으면 여기서 처리
                return .none
            }
        }
        .ifLet(\.alertState, action: \.alertAction)
        .forEach(\.detailFeatureState, action: \.detailFeatureAction) {
            WeatherDetailFeature()
        }
    }
}
