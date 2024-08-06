//
//  ContentView.swift
//  TCACase
//
//  Created by Jeong Deokho on 2024/05/07.
//

import SwiftUI
import ComposableArchitecture

// MARK: - iOS 16 이전

struct ContentView: View {
    let store: StoreOf<Feature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                Form {
                    Section {
                        Button(action: { viewStore.send(.addCounter) }) {
                            Image(systemName: "plus")
                        }
                    }
                    ForEach(viewStore.counters) { row in
                        NavigationLink(
                            "Load Counter: \(row.count)",
                            tag: row.id,
                            selection: viewStore.binding(
                                get: \.selection?.id,
                                send: { .setSelection($0) }
                            )
                        ) {
                            IfLetStore(self.store.scope(state: \.selection?.value, action: \.counter)) {
                                CounterView(store: $0)
                            } else: {
                                Text("none")
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - iOS 16 이후

//struct ContentView: View {
//    let store: StoreOf<Feature>
//
//    var body: some View {
//        WithViewStore(store, observe: { $0 }) { viewStore in
//            NavigationStack {
//                Form {
//                    Section {
//                        Button(action: { viewStore.send(.addCounter) }) {
//                            Image(systemName: "plus")
//                        }
//                    }
//                    ForEach(viewStore.counters) { row in
//                        NavigationLink(value: row.id) {
//                            Text("Load Counter: \(row.count)")
//                        }
//                    }
//                }
//                .navigationDestination(for: UUID.self) { rowID in
//                    IfLetStore(self.store.scope(state: \.selection?.value, action: \.counter)) {
//                        CounterView(store: $0)
//                    } else: {
//                        Text("none")
//                    }
//                    .onAppear {
//                        viewStore.send(.setSelection(rowID))
//                    }
//                    .onDisappear {
//                        viewStore.send(.setSelection(nil))
//                    }
//                }
//            }
//        }
//    }
//}
