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
        Form {
          Text("A screenshot of this screen has been taken \(store.screenshotCount) times.")
        }

    }
}
