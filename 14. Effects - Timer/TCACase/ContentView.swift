//
//  ContentView.swift
//  TCACase
//
//  Created by Jeong Deokho on 2024/05/07.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

struct ContentView: View {

    let store: StoreOf<Feature>

    var body: some View {
        ZStack {
            Circle()
                .fill(Color(uiColor: .blue))
            GeometryReader { proxy in
              Path { path in
                path.move(to: CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2))
                path.addLine(to: CGPoint(x: proxy.size.width / 2, y: 0))
              }
              .stroke(.primary, lineWidth: 3)
              .rotationEffect(.degrees(Double(store.secondsElapsed) * 360 / 60))
            }
            .foregroundStyle(.black)

        }
        .aspectRatio(1, contentMode: .fit)
        .frame(maxWidth: 280)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)

        Button {
            store.send(.toggleTimerButtonTapped)
        } label: {
            Text(store.isTimerActive ? "Stop" : "Start")
                .padding(8)
        }
        .frame(maxWidth: .infinity)
        .tint(store.isTimerActive ? Color.red : .accentColor)
        .buttonStyle(.borderedProminent)
        .onDisappear {
          store.send(.onDisappear)
        }

        Text("\(store.secondsElapsed)")
    }
}

