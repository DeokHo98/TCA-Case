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
            Form {
                Button("Show drill-down") {
                    store.send(.showDrillDown)
                }
                Button("Show popover") {
                    store.send(.showPopover)
                }
                Button("Show sheet") {
                    store.send(.showSheet)
                }
            }
            .navigationDestination(item: $store.scope(state: \.destination?.drillDown, action: \.destination.drillDown)) {
                CounterView(store: $0)
            }
            .popover(item: $store.scope(state: \.destination?.popover, action: \.destination.popover)) {
                CounterView(store: $0)
            }
            .sheet(item: $store.scope(state: \.destination?.sheet, action: \.destination.sheet)) {
                CounterView(store: $0)
            }

        }
    }
}
