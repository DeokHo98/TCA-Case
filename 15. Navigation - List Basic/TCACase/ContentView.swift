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
            NavigationView {
                List {
                    ForEach(viewStore.rows) { row in
                        NavigationLink(
                            destination:
                                Text("num is \(row.num)")
                                    .onAppear {
                                        viewStore.send(.setSelection(row))
                                    }
                        ) {
                            Text(String(row.num))
                        }
                    }
                }
                .navigationTitle("Last Selection \(viewStore.selection?.num ?? 0)")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { viewStore.send(.addRow) }) {
                            Image(systemName: "plus")
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
//                List {
//                    ForEach(viewStore.rows) { row in
//                        NavigationLink(
//                            String(row.num),
//                            value: row.id
//                        )
//                    }
//                }
//                .navigationDestination(for: UUID.self) { rowID in
//                    if let row = viewStore.rows[id: rowID] {
//                        Text("num is \(row.num)")
//                            .onAppear {
//                                viewStore.send(.setSelection(row))
//                            }
//                    }
//                }
//                .navigationTitle("Last Selection \(store.selection?.num ?? 0)")
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button(action: { viewStore.send(.addRow) }) {
//                            Image(systemName: "plus")
//                        }
//                    }
//                }
//            }
//        }
//    }
//}

