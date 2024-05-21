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
            HStack {
              Button {
                  store.send(.minusButtonTap)
              } label: {
                Image(systemName: "minus")
              }

              Button {
                store.send(.plusButtonTap)
              } label: {
                Image(systemName: "plus")
              }
            }
            CounterView(store: store.scope(state: \.counter1State, action: \.counter1Action))
            CounterView(store: store.scope(state: \.counter2State, action: \.counter2Action))
        }
    }
}

struct CounterView: View {
    let store: StoreOf<Counter>

    var body: some View {
        HStack {
          Button {
              store.send(.minusButtonTap)
          } label: {
            Image(systemName: "minus")
          }

          Text("\(store.count)")
            .monospacedDigit()

          Button {
            store.send(.plushButtonTap)
          } label: {
            Image(systemName: "plus")
          }
        }
    }
}
