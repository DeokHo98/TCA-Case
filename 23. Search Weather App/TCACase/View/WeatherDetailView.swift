//
//  WeatherDetailView.swift
//  TCACase
//
//  Created by Jeong Deokho on 7/31/24.
//

import SwiftUI
import ComposableArchitecture

struct WeatherDetailView: View {

    @Bindable var store: StoreOf<WeatherDetailFeature>
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Group {
            if store.isLoading {
                ProgressView("\(store.cityModel.name) Weather Searching...")
            } else {
                if let model = store.weatherModel?.daily {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(store.cityModel.name)
                                .font(.title)
                                .fontWeight(.bold)

                            ForEach(0..<model.time.count, id: \.self) { index in
                                VStack(alignment: .leading) {
                                    Text("\(model.time[index])")
                                        .font(.title3)
                                    Text("\(model.tempMax[index], specifier: "%.1f")°C")
                                        .font(.headline)
                                    Text("\(model.tempMin[index], specifier: "%.1f")°C")
                                        .font(.headline)
                                }
                                .padding(.bottom, 5)
                            }
                        }
                        .padding()
                    }
                } else {
                    Text("No Data")
                }
            }
        }
        .alert($store.scope(state: \.alertState, action: \.alertAction))
        .onAppear {
            store.send(.getWeatherData)
        }
        .onChange(of: store.dismiss) { _, _ in
            dismiss()
        }
    }
}
