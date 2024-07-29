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
        HStack {
            Button {
                store.send(.decrementButtonTap)
            } label: {
                Image(systemName: "minus")
            }

            Text("\(store.count)")
                .monospacedDigit()

            Button {
                store.send(.incrementButtonTap)
            } label: {
                Image(systemName: "plus")
            }
        }
        .frame(maxWidth: .infinity)

        Button("Number fact") { store.send(.numberFactButtonTap) }
          .frame(maxWidth: .infinity)

        if store.isNumberFactRequestInFlight {
          ProgressView()
            .frame(maxWidth: .infinity)
        }
        if let numberFact = store.numberFact {
          Text(numberFact)
        }
    }

}
