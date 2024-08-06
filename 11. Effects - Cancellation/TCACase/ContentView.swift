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
        VStack {
            Stepper("\(store.count)", value: $store.count.sending(\.stepperChanged))
                .padding(.leading, 30)
                .padding(.trailing, 30)
            if store.isFactRequestInFlight {
                HStack {
                    Button("취소") {
                        store.send(.cancelButtonTap)
                    }
                    ProgressView()
                }
            } else {
                Button("Fact") {
                    store.send(.factButtonTap)
                }
                .disabled(store.isFactRequestInFlight)
            }
            if let fact = store.currentFact {
              Text(fact)
                    .padding(.vertical, 8)
            }
        }
    }
}
