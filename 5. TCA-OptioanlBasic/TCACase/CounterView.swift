//
//  CounterView.swift
//  TCACase
//
//  Created by Jeong Deokho on 5/29/24.
//

import ComposableArchitecture
import SwiftUI

struct CounterView: View {
  let store: StoreOf<Counter>

  var body: some View {
    HStack {
      Button {
        store.send(.decrementButtonTapped)
      } label: {
        Image(systemName: "minus")
      }

      Text("\(store.count)")
        .monospacedDigit()

      Button {
        store.send(.incrementButtonTapped)
      } label: {
        Image(systemName: "plus")
      }
    }
  }
}
