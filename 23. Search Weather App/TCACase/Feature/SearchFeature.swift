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
        var cityList: [CitySearchModel.Result] = []
        var searchQuery = ""
    }

    enum Action {
        case alertAction(PresentationAction<Alert>)
        case search
        case searchQueryChange(String)
        case searchResponse(Result<CitySearchModel, Error>)
        
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
                state.cityList = []
                state.alertState = AlertState { TextState("\(error.localizedDescription)") }
                return .none
            case .searchResponse(.success(let model)):
                state.isLoading = false
                state.cityList = model.results
                return .none
            }
        }
        .ifLet(\.alertState, action: \.alertAction)
    }
}
