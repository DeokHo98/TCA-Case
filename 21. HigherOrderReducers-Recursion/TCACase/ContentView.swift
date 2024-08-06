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
                ForEach(store.scope(state: \.rows, action: \.rows)) { rowStore in
                    @Bindable var rowStore = rowStore
                    NavigationLink {
                        ContentView(store: rowStore)
                    } label: {
                        HStack {
                            TextField("입력해주세요.", text: $rowStore.name.sending(\.nameTextFieldChanged))
                            Text("다음")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete(perform: { indexSet in
                    store.send(.onDelete(indexSet))
                })
            }
            .navigationTitle(store.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
              ToolbarItem(placement: .navigationBarTrailing) {
                Button("추가하기") { store.send(.addRowButtonTapped) }
              }
            }
        }
    }
}
