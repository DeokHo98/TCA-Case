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
    @FocusState var focusedField: Feature.State.Field?

    var body: some View {
        VStack {
            VStack {
                TextField("userName", text: $store.username)
                    .focused($focusedField, equals: .username)
                    .onSubmit {
                        store.send(.userNameTextFieldEnterTap)
                    }
                TextField("password", text: $store.password)
                    .focused($focusedField, equals: .password)
                    .onSubmit {
                        store.send(.passwordTextFieldEnterTap)
                    }
                Button("Sign In") {
                    store.send(.signInButtonTap)
                }
            }
            .bind($store.focusedField, to: $focusedField)
        }
        .padding()
    }
}
