//
//  ContentView.swift
//  TCACase
//
//  Created by Jeong Deokho on 2024/05/07.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {

   @Bindable var store: StoreOf<Feature>

    var body: some View {
        NavigationStack {
            if store.isActivityIndicatorVisible {
                ProgressView()
            } else {
                Button("Load") {
                    store.send(.counterButtonTapped)
                }
            }
        }
        .sheet(item: $store.scope(state: \.counter, action: \.counter)) { store in
          CounterView(store: store)
        }


    }
}
