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
    @State var isLoading = false


    var body: some View {
        List {
            VStack {
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
                .buttonStyle(.borderless)

                if let fact = store.fact {
                    Text(fact)
                        .bold()
                }

                if self.isLoading {
                    Button("Cancel") {
                        store.send(.cancelButtonTap, animation: .default)
                    }
                }

            }
        }
        .refreshable {
            isLoading = true
            await store.send(.refresh).finish()
            isLoading = false
        }
    }
}
