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
        Form {
            Section {
                HStack {
                    TextField("입력하세요.", text: $store.text.sending(\.textFeildEditing))
                    Text(store.text == "" ? "비어있음" : store.text)
                }
            }
            .opacity(store.opacity)

            Section {
                Stepper("\(store.stepCount)", value: $store.stepCount.sending(\.stepperChanged), in: 0...100)
            }
            .opacity(store.opacity)

            Section {
                VStack {
                    Slider(value: $store.sliderValue.sending(\.sliderChanged), in: 0...Double(store.stepCount))
                    Text("\(store.sliderValue)")
                }
            }
            .opacity(store.opacity)

            Section {
                Toggle("\(store.toggleIsOn ? "On" : "Off")", isOn: $store.toggleIsOn.sending(\.toggleChnaged))
            }
        }
    }
}

#Preview {
    let store = StoreOf<Feature>(initialState: Feature.State()) {
        Feature()
    }
    return ContentView(store: store)
}
