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
                Button("Load") {
                    store.send(.counterButtonTapped(true))
                }
        }
        .sheet(isPresented: $store.isActivityIndicatorVisible.sending(\.counterButtonTapped), content: {
            if let store = store.scope(state: \.counter, action: \.counter) {
                CounterView(store: store)
            } else {
                ProgressView()
            }
        })

    }
}
