//
//  WebSocketTests.swift
//  
//
//  Created by Miroslav Kutak on 01/16/2023.
//

import XCTest
@testable import BigParser

final class WebSocketTests: XCTestCase {

    var auth: BigParser.Authorization = .none

    override func setUpWithError() throws {
        auth = BigParser.Authorization.authId(Constants.authId)
    }

    override func tearDownWithError() throws {
        auth = .none
    }

    func testJSGridUpdates() async throws {
        let expectation = XCTestExpectation(description: "Connect grid websocket")

        do {
            for try await message in try BigParser.shared.streamGridUpdates(
                auth: auth,
                gridId: Constants.unitTestGridId
            ) {
                Console.log(message)
                expectation.fulfill()
            }
        } catch {
            XCTFail("\(error)")
        }

        sleep(50)
        await fulfillment(of: [expectation], timeout: 300)
    }

    func testJSGridListUpdates() async throws {
        let expectation = XCTestExpectation(description: "Connect grid list websocket")

        do {
            for try await message in try BigParser.shared.streamGridListUpdates(
                auth: auth,
                userId: Constants.userId
            ) {
                Console.log(message)
                expectation.fulfill()
            }
        } catch {
            XCTFail("\(error)")
        }

        sleep(50)
        await fulfillment(of: [expectation], timeout: 300)
    }
}
