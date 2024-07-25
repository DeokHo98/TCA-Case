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
            let store = Store(initialState: Feature.State()) {
                Feature()
            }
            ContentView(store: store)
        }
    }
}
