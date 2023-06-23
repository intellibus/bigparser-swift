//
//  QueryTests.swift
//  
//
//  Created by Miroslav Kutak on 01/02/2023.
//

import XCTest
@testable import BigParser

final class ReadTests: XCTestCase {

    struct Employee: Decodable {
        let address: String?
        let ipAddress: String?
        let phoneNumber: String
        let lastTimeAvailable: String?

        enum CodingKeys: String, CodingKey {
            case address = "Address"
            case geoData = "Geodata"
            case ipAddress = "IP Address"
            case phoneNumber = "Phone Number"
            case lastTimeAvailable = "Last Time Available"
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.address = try container.decodeIfPresent(String.self, forKey: .address)
            self.ipAddress = try container.decodeIfPresent(String.self, forKey: .ipAddress)
            self.phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
            self.lastTimeAvailable = try container.decodeIfPresent(String.self, forKey: .lastTimeAvailable)
        }
    }

    private struct ReadConstants {
        static let gridId = "63da91507ae3f2484bba8bdf"
        static let shareId = "63da924f69c8f049da05ccf5"
    }

    var auth: BigParser.Authorization = .none

    override func setUpWithError() throws {
        auth = BigParser.Authorization.authId(Constants.authId)
    }

    override func tearDownWithError() throws {
        auth = .none
    }

    func testSearchGrid() async throws {
        let expectation = XCTestExpectation(description: "Search")

        let filter = GlobalFilter.Filter(filterOperator: .LIKE, keyword: "Paper")
        let request = SearchRequest(singleGlobalFilter: filter)

        do {
            let _ = try await BigParser.shared.searchGrid(
                auth: auth,
                gridId: ReadConstants.gridId,
                shareId: ReadConstants.shareId,
                request: request)
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        await fulfillment(of: [expectation], timeout: 3)
    }

    func testSearchGridWithEntityParsing() async throws {
        let expectation = XCTestExpectation(description: "Search with Entity Parsing")

        let filter = ColumnFilter.Filter(column: "Phone Number", keyword: "+420605478713", filterOperator: .EQ)
        let request = SearchRequest(singleColumnFilter: filter)
        let gridId = "6439929738deba58c7b5dbc6" // Employees.grid

        do {
            let employees: SearchResponseWithColumnNamesEntity<Employee> = try await BigParser.shared.searchGridWithColumnNamesEntity(
                auth: auth,
                gridId: gridId,
                shareId: ReadConstants.shareId,
                request: request)
            XCTAssertFalse(employees.rows.isEmpty)
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        await fulfillment(of: [expectation], timeout: 3)
    }

    func testQueryMetadata() async throws {
        let expectation = XCTestExpectation(description: "Get grid metadata")

        do {
            let _ = try await BigParser.shared.queryMetadata(
                auth: auth,
                gridId: ReadConstants.gridId,
                shareId: ReadConstants.shareId
            )
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        await fulfillment(of: [expectation], timeout: 3)
    }

    func testGetGridMetadata() async throws {
        let expectation = XCTestExpectation(description: "Get grid metadata")

        do {
            let _ = try await BigParser.shared.queryMultiSheetMetadata(
                auth: auth,
                gridId: ReadConstants.gridId,
                shareId: ReadConstants.shareId
            )
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        await fulfillment(of: [expectation], timeout: 3)
    }

    func testGetGrids() async throws {
        let expectation = XCTestExpectation(description: "Get grids")

        do {
            let _ = try await BigParser.shared.getGrids(
                auth: auth,
                query: "", request: GetGridsRequest(startIndex: 1, endIndex: 26, searchKeyword: "a"))
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        await fulfillment(of: [expectation], timeout: 3)
    }

    func testSearchCount() async throws {
        let expectation = XCTestExpectation(description: "Search Count")

        let query = SearchCountRequest.Query(
            globalFilter: GlobalFilter(filters: [GlobalFilter.Filter(filterOperator: .LIKE, keyword: "Paper")],
                             filtersJoinOperator: .OR),
            columnFilter: nil
        )

        do {
            let _ = try await BigParser.shared.searchCount(
                auth: auth,
                gridId: ReadConstants.gridId,
                shareId: ReadConstants.shareId,
                request: SearchCountRequest(query: query))
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        await fulfillment(of: [expectation], timeout: 3)
    }

    func testSearchKeywordsCount() async throws {
        let expectation = XCTestExpectation(description: "Search Keywords Count")

        let query = SearchKeywordsCountRequest.Query(
            globalFilter: GlobalFilter(filters: [GlobalFilter.Filter(filterOperator: .LIKE, keyword: "Paper")],
                             filtersJoinOperator: .OR),
            columnFilter: nil
        )

        do {
            let _ = try await BigParser.shared.searchKeywordsCount(
                auth: auth,
                gridId: ReadConstants.gridId,
                shareId: ReadConstants.shareId,
                request: SearchKeywordsCountRequest(query: query))
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        await fulfillment(of: [expectation], timeout: 3)
    }

}
