//
//  DeleteTests.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import XCTest
@testable import BigParserSwiftSDK

final class DeleteTests: XCTestCase {

    private struct Constants {
        static let authId = "fcd0b8a0-5fae-449d-a977-0426915f42a0"
        static let gridId = "63b3f7f2afe52c4a2373a9ed"
        static let row0Id = "63b3f902a360a56c50361641"
    }

    func testDeleteRows() async throws {
        let expectation = XCTestExpectation(description: "Delete rows by Id")

        do {
            let _ = try await BigParser.shared.deleteRows(
                Constants.gridId,
                deleteRows: DeleteRowsRequest(
                    delete: DeleteRowsRequest.Delete(rows: [DeleteRowsRequest.DeleteRow(rowId: Constants.row0Id)]
                                                    )
                )
            )
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        wait(for: [expectation], timeout: 3)
    }

    func testDeleteRowsWithQuery() async throws {
        let expectation = XCTestExpectation(description: "Delete rows by Query")

        let globalFilter = GlobalFilter(filters: [GlobalFilter.Filter(filterOperator: .LIKE, keyword: "Paper")],
                         filtersJoinOperator: .OR)

        do {
            let _ = try await BigParser.shared.deleteRows(
                Constants.gridId,
                deleteRowsByQueryRequest:
                    DeleteRowsByQueryRequest(delete:
                        DeleteRowsByQueryRequest.Delete(query:
                            DeleteRowsByQueryRequest.Query(
                                columnFilter: nil, globalFilter: globalFilter
                            )
                        )
                    )
            )
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        wait(for: [expectation], timeout: 3)
    }

}
