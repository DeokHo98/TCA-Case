//
//  ContentView.swift
//  TCACase
//
//  Created by Jeong Deokho on 2024/05/07.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    var body: some View {
        Form {
            ForEach(mocks(), id: \.id) {
                let store = StoreOf<Feature>(initialState: $0) {
                    Feature()
                }
                FavoriteButton(store: store)
            }
        }
    }

    private func mocks() -> [Feature.State] {
        return [
            Feature.State(id: UUID(), isFavorite: false),
            Feature.State(id: UUID(), isFavorite: false),
            Feature.State(id: UUID(), isFavorite: false),
            Feature.State(id: UUID(), isFavorite: false)
        ]
    }
}

struct FavoriteButton: View {
  let store: StoreOf<Feature>

  var body: some View {
      Button {
        store.send(.buttonTap)
      } label: {
        Image(systemName: "heart")
          .symbolVariant(store.isFavorite ? .fill : .none)
      }
      .alert(store: self.store.scope(state: \.$alert, action: \.alert))
  }
}

