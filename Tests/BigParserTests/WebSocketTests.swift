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

    func testJSGridUpdates() async throws {
        let expectation = XCTestExpectation(description: "Connect grid websocket")

        do {
            for try await message in try BigParser.shared.streamGridUpdates(
                Constants.unitTestGridId
            ) {
                Console.log(message)
                expectation.fulfill()
            }
        } catch {
            XCTFail("\(error)")
        }

        sleep(50)
        wait(for: [expectation], timeout: 300)
    }

    func testJSGridListUpdates() async throws {
        let expectation = XCTestExpectation(description: "Connect grid list websocket")

        do {
            for try await message in try BigParser.shared.streamGridListUpdates(
                Constants.userId
            ) {
                Console.log(message)
                expectation.fulfill()
            }
        } catch {
            XCTFail("\(error)")
        }

        sleep(50)
        wait(for: [expectation], timeout: 300)
    }
}
