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
        NavigationStack {
            Form {
                Section {
                    NavigationLink {
                        detailView
                    } label: {
                        Text("Navigate to another screen")
                    }
                }

                Section {
                    Text("\(store.screenshotCount)")
                        .font(.largeTitle)
                        .task {
                            await store.send(.task).finish()
                        }

                }
            }
        }
    }

    var detailView: some View {
      Text(
        """
        여기서 스크린샷을찍고 이전화면으로 돌아가도 카운트가 올라가지 않는다.
        이는 effect의 수명이 View에 맞춰져있기 때문이다.
        알림 효과는 화면을 떠날 때 자동으로 취소되고, 화면에 다시 들어올 때 다시 시작된다.
        """
      )
      .padding(.horizontal, 64)
      .navigationBarTitleDisplayMode(.inline)
    }
}
