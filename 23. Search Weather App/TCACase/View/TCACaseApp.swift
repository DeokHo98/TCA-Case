//
//  TCACaseApp.swift
//  TCACase
//
//  Created by Jeong Deokho on 2024/05/07.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCACaseApp: App {
    var body: some Scene {
        WindowGroup {
            let store = Store(initialState: SearchFeature.State()) {
                SearchFeature()
                    ._printChanges()
            }
            SearchView(store: store)

        }
    }
}
