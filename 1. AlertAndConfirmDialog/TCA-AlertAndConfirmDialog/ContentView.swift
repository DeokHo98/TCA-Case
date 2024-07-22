//
//  ContentView.swift
//  TCA-AlertAndConfirmDialog
//
//  Created by Jeong Deokho on 2024/05/03.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {

   @State var store: StoreOf<Feature> = .init(initialState: Feature.State()) {
        Feature()
    }

    var body: some View {
        VStack {
            Text("Count \(store.count)")

            Button("Alert") {
                store.send(.alertButtonTap)
            }

            Button("Confirmation Dalog") {
                store.send(.dialogButtonTap)
            }
        }
        .alert($store.scope(state: \.destinationState?.alert, action: \.destinationAction.alert))
        .confirmationDialog($store.scope(state: \.destinationState?.confirmDialog, action: \.destinationAction.confirmDialog))

    }
}

#Preview {
    ContentView()
}
