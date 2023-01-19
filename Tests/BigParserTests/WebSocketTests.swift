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

    func testExample() throws {
        let expectation = XCTestExpectation(description: "Connect grid websocket")

        Task {
            do {
                for try await message in BigParser.shared.webSocketStream(
                    gridId: Constants.unitTestGridId
                ) {
                    print(message)
                }
            } catch {
                XCTFail("\(error)")
            }
        }

        wait(for: [expectation], timeout: 3)
    }

    private let gridId = "63c7e0c5c1427e424ed42420"
    private var topic: String { "/topic/grid/\(gridId)/share_edit" }

    func testJS() {
        let expectation = XCTestExpectation(description: "Connect grid websocket")

        Task {
//            do {
                BigParser.shared.connectToWebsocket(topic: topic)
//            } catch {
//                XCTFail("\(error)")
//            }
        }

        wait(for: [expectation], timeout: 300)
    }

}
