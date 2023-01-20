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

    func testJSGridUpdates() throws {
        let expectation = XCTestExpectation(description: "Connect grid websocket")

        Task {
            do {
                for try await message in try BigParser.shared.streamGridUpdates(
                    Constants.unitTestGridId
                ) {
                    switch message {
                    case .cellHighlight(let message):
                        Console.log(message)
                    case .bulkCRUD(let message):
                        Console.log(message)
                    case .string(let string):
                        Console.log(string)
                    }
                }
            } catch {
                XCTFail("\(error)")
            }
        }

        wait(for: [expectation], timeout: 300)
    }

    func testJSGridListUpdates() throws {
        let expectation = XCTestExpectation(description: "Connect grid list websocket")

        Task {
            do {
                for try await message in try BigParser.shared.streamGridListUpdates(
                    Constants.userId
                ) {
                    switch message {
                    case .cellHighlight(let message):
                        Console.log(message)
                    case .bulkCRUD(let message):
                        Console.log(message)
                    case .string(let string):
                        Console.log(string)
                    }
                }
            } catch {
                XCTFail("\(error)")
            }
        }

        wait(for: [expectation], timeout: 300)
    }

}
