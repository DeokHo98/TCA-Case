//
//  TCACaseTests.swift
//  TCACaseTests
//
//  Created by Jeong Deokho on 2024/05/07.
//

import XCTest
import ComposableArchitecture
@testable import TCACase

final class TCACaseTests: XCTestCase {

    @MainActor
    func testReducer() async {
        let (screenshots, takeScreenshot) = AsyncStream.makeStream(of: Void.self)
        let store = TestStore(initialState: Feature.State()) {
          Feature()
        } withDependencies: {
          $0.screenshots = { screenshots }
        }
        let task = await store.send(.task)
        takeScreenshot.yield()
        await store.receive(\.userDidTakeScreenshotNotification) {
          $0.screenshotCount = 1
        }
        await task.cancel()
    }

}
