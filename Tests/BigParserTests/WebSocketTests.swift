//
//  WebSocketTests.swift
//  
//
//  Created by Miroslav Kutak on 01/16/2023.
//

import XCTest
@testable import BigParser

final class WebSocketTests: XCTestCase {

    override func setUpWithError() throws {
        BigParser.shared.authId = Constants.authId
    }

    override func tearDownWithError() throws {
        BigParser.shared.authId = nil
    }

    func testJS() throws {
        let expectation = XCTestExpectation(description: "Connect grid websocket")

        Task {
            do {
                for try await message in try BigParser.shared.streamGridUpdates(
                    gridId: Constants.unitTestGridId
                ) {
                    switch message {
                    case .grid(let message):
                        print(message)
                    case .string(let string):
                        print(string)
                    }
                }
            } catch {
                XCTFail("\(error)")
            }
        }

        wait(for: [expectation], timeout: 3)
    }

}
