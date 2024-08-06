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
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            Form {
                Section {
                    NavigationLink("Go A View", state: Feature.Path.State.screenA(ScreenFeatureA.State()))
                }

                Section {
                    NavigationLink("Go B View", state: Feature.Path.State.screenB(ScreenFeatureB.State()))
                }

                Section {
                    NavigationLink("Go C View", state: Feature.Path.State.screenC(ScreenFeatureC.State()))
                }

                Section {
                    Button("Go A -> B -> C") {
                        store.send(.goToABCButtonTapped)
                    }
                }
            }
            .navigationTitle("Navigation Stack")
        } destination: { store in
            switch store.case {
            case .screenA(let store):
                AView(store: store)
            case .screenB(let store):
                BView(store: store)
            case .screenC(let store):
                CView(store: store)
            }
        }
        .safeAreaInset(edge: .bottom) {
            FloatingView(store: store)
        }
    }
}

struct FloatingView: View {
    let store: StoreOf<Feature>
    var stackID: [StackElementID] {
        return store.path.ids.map { $0 }
    }
    var body: some View {
        VStack {
            Button("Go RootView") {
                store.send(.popToRoot)
            }
            ForEach(stackID, id: \.self) { id in
                Button("ID: \(id)") {
                    store.send(.goBackToScreen(id: id))
                }
            }
        }

    }
}


struct AView: View {

    let store: StoreOf<ScreenFeatureA>

    var body: some View {
        Button("Next B View") {
            store.send(.screenBButtonTapped)
        }

        Button("Dismiss") {
            store.send(.dismissButtonTapped)
        }
        .navigationTitle("A View")
    }
}

struct BView: View {

    let store: StoreOf<ScreenFeatureB>

    var body: some View {
        Button("Next C View") {
            store.send(.screenCButtonTapped)
        }

        Button("Dismiss") {
            store.send(.dismissButtonTapped)
        }
        .navigationTitle("B View")
    }
}

struct CView: View {

    let store: StoreOf<ScreenFeatureC>

    var body: some View {
        Button("Next A View") {
            store.send(.screenAButtonTapped)
        }

        Button("Dismiss") {
            store.send(.dismissButtonTapped)
        }
        .navigationTitle("C View")
    }
}
