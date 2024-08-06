//
//  Feature.swift
//  TCACase
//
//  Created by Jeong Deokho on 2024/05/07.
//

import Foundation
import ComposableArchitecture

@Reducer
struct Feature {
    @Reducer(state: .equatable)
    enum Destination {
        case drillDown(Counter)
        case popover(Counter)
        case sheet(Counter)
    }

    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
    }

    enum Action {
        case destination(PresentationAction<Destination.Action>)
        case showDrillDown
        case showPopover
        case showSheet
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .destination:
                return .none
            case .showDrillDown:
                state.destination = .drillDown(Counter.State())
                return .none
            case .showPopover:
                state.destination = .popover(Counter.State())
                return .none
            case .showSheet:
                state.destination = .sheet(Counter.State())
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
