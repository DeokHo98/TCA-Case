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
      TabView() {
        CounterTabView(
            store: Store(initialState: CounterTab.State(), reducer: {
                CounterTab()
            })
        )
        .tabItem { Text("Counter") }

        ProfileTabView(
            store: Store(initialState: ProfileTab.State(), reducer: {
                ProfileTab()
            })
        )
        .tabItem { Text("Profile") }
      }
      .navigationTitle("Shared State Demo")
    }
}

private struct CounterTabView: View {
  @Bindable var store: StoreOf<CounterTab>

  var body: some View {
      @State var text: String = ""
    Form {
      VStack(spacing: 16) {
          Text(text)
              .font(.largeTitle)

        HStack {
          Button {
            store.send(.decrementButtonTapped)
          } label: {
            Image(systemName: "minus")
          }

          Text("\(store.stats.count)")
            .monospacedDigit()

          Button {
            store.send(.incrementButtonTapped)
          } label: {
            Image(systemName: "plus")
          }
        }

        Button("소수인가요?") { store.send(.isPrimeButtonTapped) }
      }
    }
    .buttonStyle(.borderless)
    .alert($store.scope(state: \.alert, action: \.alert))
  }
}

private struct ProfileTabView: View {
  let store: StoreOf<ProfileTab>

  var body: some View {
    Form {
      Text(
          """
          이 탭은 이전 탭의 상태를 보여주며, 모든 상태를 0으로 초기화할 수 있습니다.

          이는 각 화면이 가장 적합한 방식으로 상태를 모델링할 수 있으면서도 독립된 화면 간에 \
          상태와 변형을 공유할 수 있음을 보여줍니다.
          """
      )

      VStack(spacing: 16) {
        Text("현재 수: \(store.stats.count)")
        Text("최대 수: \(store.stats.maxCount)")
        Text("최소 수: \(store.stats.minCount)")
        Text("총 수 이벤트 수: \(store.stats.numberOfCounts)")
        Button("초기화") { store.send(.resetStatsButtonTap) }
      }
    }
    .buttonStyle(.borderless)
  }
}
