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
        TabView(selection: $store.currentTab.sending(\.selectTab)) {
            MainTabView(
                store: store.scope(state: \.main, action: \.main)
            )
            .tag(Tab.main)
            .tabItem { Text("Main") }

            ProfileTabView(
                store: store.scope(state: \.profile, action: \.profile)
            )
            .tag(Tab.profile)
            .tabItem { Text("Profile") }
        }
        .navigationTitle("Shared State Demo")
    }
}

struct MainTabView: View {
    @Bindable var store: StoreOf<Feature.MainTap>
    var body: some View {
        if store.isLogin {
            Button("로그아웃") {
                store.send(.logoutButtonTap)
            }
        } else {
            Button("로그인") {
                store.send(.loginButtonTap)
            }
        }
    }
}

struct ProfileTabView: View {
    @Bindable var store: StoreOf<Feature.ProfileTap>
    var body: some View {
        if store.isLogin {
            Button("로그아웃") {
                store.send(.logoutButtonTap)
            }
        } else {
            Button("로그인") {
                store.send(.loginButtonTap)
            }
        }
    }
}
