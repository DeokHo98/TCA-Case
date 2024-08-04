//
//  ContentView.swift
//  TCACase
//
//  Created by Jeong Deokho on 2024/05/07.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {

    let store: StoreOf<Feature>

    var body: some View {
        VStack {
            Button("Toogle Counter State") {
                store.send(.toggleCounterButtonTap)
            }

            if let counterStore = store.scope(state: \.counterState, action: \.counterAction) {
                Text("Counter non nil")
                CounterView(store: counterStore)
            } else {
                Text("Counter is nil")
            }
        }
        .padding()
    }
}
