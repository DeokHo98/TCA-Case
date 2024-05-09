//
//  Feature.swift
//  TCACase
//
//  Created by Jeong Deokho on 2024/05/07.
//

import ComposableArchitecture
import Foundation

@Reducer
struct Feature {
    @ObservableState
    struct State: Equatable {
        var text = ""
        var sliderValue = 0.0
        var stepCount = 1
        var toggleIsOn = false
        var opacity = 1.0
    }

    enum Action {
        case textFeildEditing(String)
        case sliderChanged(Double)
        case stepperChanged(Int)
        case toggleChnaged(isOn: Bool)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .textFeildEditing(let text):
                state.text = text
            case .sliderChanged(let value):
                state.sliderValue = value
            case .stepperChanged(let value):
                state.sliderValue = .minimum(state.sliderValue, Double(value))
                state.stepCount = value
            case .toggleChnaged(let isOn):
                state.toggleIsOn = isOn
                state.opacity = isOn ? 0.0 : 1.0
            }
            return .none
        }
    }
}
