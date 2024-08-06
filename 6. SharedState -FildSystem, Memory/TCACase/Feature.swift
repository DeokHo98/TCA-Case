//
//  Feature.swift
//  TCACase
//
//  Created by Jeong Deokho on 2024/05/07.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CounterTab {
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        // 여러 다른 뷰나 리듀서에서 동일한 Stats 객체를 공유할수 있게 됨 싱글톤과 비슷
        @Shared(.stats) var stats = Stats()
    }

    enum Action {
        case alert(PresentationAction<Alert>)
        case incrementButtonTapped
        case decrementButtonTapped
        case isPrimeButtonTapped

        enum Alert: Equatable { }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .alert:
                return .none
            case .incrementButtonTapped:
                state.stats.increment()
            case .decrementButtonTapped:
                state.stats.decrement()
            case .isPrimeButtonTapped:
                state.alert = AlertState {
                    TextState(isPrime(state.stats.count)
                              ? "👍 The number \(state.stats.count) is prime!"
                              : "👎 The number \(state.stats.count) is not prime :(")
                }
            }
            return .none
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

@Reducer
struct ProfileTab {
    @ObservableState
    struct State: Equatable {
        // 여러 다른 뷰나 리듀서에서 동일한 Stats 객체를 고유할수 있게 됨 싱글톤과 비슷
        @Shared(.stats) var stats = Stats()
    }

    enum Action {
        case resetStatsButtonTap
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .resetStatsButtonTap:
                state.stats = Stats()
                return .none
            }
        }
    }
}

struct Stats: Codable, Equatable {
    private(set) var count = 0
    private(set) var maxCount = 0
    private(set) var minCount = 0
    private(set) var numberOfCounts = 0

    mutating func increment() {
        count += 1
        numberOfCounts += 1
        maxCount = max(maxCount, count)
    }

    mutating func decrement() {
        count -= 1
        numberOfCounts -= 1
        maxCount = max(minCount, count)
    }
}

private func isPrime(_ p: Int) -> Bool {
    if p <= 1 { return false }
    if p <= 3 { return true }
    for i in 2...Int(sqrtf(Float(p))) {
        if p % i == 0 { return false }
    }
    return true
}

// 파일시스템에 저장 (비 휘발성)
extension PersistenceReaderKey where Self == FileStorageKey<Stats> {
    fileprivate static var stats: Self {
        fileStorage(.documentsDirectory.appending(component: "stats"))
    }
}

// 메모리에 저장 (휘발성)
//extension PersistenceReaderKey where Self == InMemoryKey<Stats> {
//    fileprivate static var stats: Self {
//        inMemory("stats")
//    }
//}
