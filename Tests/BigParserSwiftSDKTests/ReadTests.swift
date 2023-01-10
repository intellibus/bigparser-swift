//
//  QueryTests.swift
//  
//
//  Created by Miroslav Kutak on 01/02/2023.
//

import XCTest
@testable import BigParserSwiftSDK

final class ReadTests: XCTestCase {

    private struct Constants {
        static let authId = "fcd0b8a0-5fae-449d-a977-0426915f42a0"
        static let gridId = "638f43e7cc3151353d14a63a"
        static let shareId = "638f48d68108ee25ecc3a11a"
    }

    override func setUpWithError() throws {
        BigParser.shared.authId = Constants.authId
    }

    override func tearDownWithError() throws {
        BigParser.shared.authId = nil
    }

    func testSearchGrid() async throws {
        let expectation = XCTestExpectation(description: "Search")

        let filter = GlobalFilter.Filter(filterOperator: .LIKE, keyword: "Paper")
        let request = SearchRequest(singleGlobalFilter: filter)

        do {
            let _ = try await BigParser.shared.searchGrid(
                Constants.gridId,
                shareId: Constants.shareId,
                searchRequest: request)
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        wait(for: [expectation], timeout: 3)
    }

    func testGetGridHeader() async throws {
        let expectation = XCTestExpectation(description: "Get grid metadata")


        do {
            let _ = try await BigParser.shared.getGridHeader(Constants.gridId, shareId: Constants.shareId)
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        wait(for: [expectation], timeout: 3)
    }

    func testGetGridMetadata() async throws {
        let expectation = XCTestExpectation(description: "Get grid metadata")


        do {
            let _ = try await BigParser.shared.getMultiSheetMetadata(Constants.gridId, shareId: Constants.shareId)
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        wait(for: [expectation], timeout: 3)
    }

    func testSearchCount() async throws {
        let expectation = XCTestExpectation(description: "Search Count")

        let query = SearchCountRequest.Query(
            globalFilter: GlobalFilter(filters: [GlobalFilter.Filter(filterOperator: .LIKE, keyword: "Paper")],
                             filtersJoinOperator: .OR),
            columnFilter: nil
        )

        do {
            let _ = try await BigParser.shared.getSearchCount(
                Constants.gridId,
                shareId: Constants.shareId,
                searchCountRequest: SearchCountRequest(query: query))
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        wait(for: [expectation], timeout: 3)
    }

    func testSearchKeywordsCount() async throws {
        let expectation = XCTestExpectation(description: "Search Keywords Count")

        let query = SearchKeywordsCountRequest.Query(
            globalFilter: GlobalFilter(filters: [GlobalFilter.Filter(filterOperator: .LIKE, keyword: "Paper")],
                             filtersJoinOperator: .OR),
            columnFilter: nil
        )

        do {
            let _ = try await BigParser.shared.getSearchKeywordsCount(
                Constants.gridId,
                shareId: Constants.shareId,
                searchKeywordsCountRequest: SearchKeywordsCountRequest(query: query))
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        wait(for: [expectation], timeout: 3)
    }

}
