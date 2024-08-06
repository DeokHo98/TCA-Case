//
//  ContentView.swift
//  TCACase
//
//  Created by Jeong Deokho on 2024/05/07.
//

import SwiftUI
import ComposableArchitecture

struct SearchView: View {

    @Bindable var store: StoreOf<SearchFeature>
    @FocusState private var isFocused: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField(
                            "City Name...",
                            text: $store.searchQuery.sending(\.searchQueryChange)
                        )
                        .focused($isFocused)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        Button("Search") {
                            store.send(.search)
                        }
                    }
                    .padding()

                    List {
                        ForEach(store.scope(state: \.detailFeatureState, action: \.detailFeatureAction)) { store in
                            NavigationLink(
                                destination: WeatherDetailView(
                                    store: store
                                )
                            ) {
                                Text(store.cityModel.name)
                            }
                        }
                    }
                }

                if store.isLoading {
                    ProgressView("Searching...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.3))
                        .edgesIgnoringSafeArea(.all)
                        .foregroundColor(.white)
                }
            }
            .navigationTitle("City Search")
        }
        .alert($store.scope(state: \.alertState, action: \.alertAction))
    }
}
