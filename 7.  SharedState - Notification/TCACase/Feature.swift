//
//  Feature.swift
//  TCACase
//
//  Created by Jeong Deokho on 2024/05/07.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct Feature {
  @ObservableState
  struct State: Equatable {
    @SharedReader(.screenshotCount) var screenshotCount = 0
  }
  enum Action {
  }
  var body: some ReducerOf<Self> {
    Reduce { state, action in
        return .none
      }
    }
}

extension PersistenceReaderKey where Self == NotificationReaderKey<Int> {
  static var screenshotCount: Self {
    NotificationReaderKey(
      initialValue: 0,
      name: MainActor.assumeIsolated {
        UIApplication.userDidTakeScreenshotNotification
      }
    ) { value, _ in
      value += 1
    }
  }
}

struct NotificationReaderKey<Value: Sendable>: PersistenceReaderKey {
  let name: Notification.Name
  private let transform: @Sendable (Notification) -> Value

  init(
    initialValue: Value,
    name: Notification.Name,
    transform: @Sendable @escaping (inout Value, Notification) -> Void
  ) {
    self.name = name
    let value = LockIsolated(initialValue)
    self.transform = { notification in
      value.withValue { [notification = UncheckedSendable(notification)] in
        transform(&$0, notification.wrappedValue)
      }
      return value.value
    }
  }

  func load(initialValue: Value?) -> Value? { nil }

  func subscribe(
    initialValue: Value?,
    didSet: @Sendable @escaping (Value?) -> Void
  ) -> Shared<Value>.Subscription {
    let token = NotificationCenter.default.addObserver(
      forName: name,
      object: nil,
      queue: nil,
      using: { notification in
        didSet(transform(notification))
      }
    )
    return Shared.Subscription {
      NotificationCenter.default.removeObserver(token)
    }
  }

  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.name == rhs.name
  }
  func hash(into hasher: inout Hasher) {
    hasher.combine(name)
  }
}
