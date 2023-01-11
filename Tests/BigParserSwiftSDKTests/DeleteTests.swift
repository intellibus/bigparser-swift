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
    }

    override func setUpWithError() throws {
        BigParser.shared.authId = Constants.authId
    }

    override func tearDownWithError() throws {
        BigParser.shared.authId = nil
    }

    func testDeleteRows() async throws {
        let expectation = XCTestExpectation(description: "Delete rows by Id")

        do {
            // Insert a new row
            let insertResponse = try await BigParser.shared.insertRows(
                Constants.gridId,
                insertRowsRequest: InsertRowsRequest(insert:
                                                        InsertRowsRequest.Insert(rows: [
                                                            ["Random Number": "\(arc4random() % 100)"]
                                                        ])
                                                    )
            )

            XCTAssertTrue(insertResponse.createdRows.values.count == 1)
            guard let rowId =  insertResponse.createdRows.values.first else {
                XCTFail("No row inserted")
                return
            }

            // Delete the row again
            let deleteResponse = try await BigParser.shared.deleteRows(
                Constants.gridId,
                deleteRows: DeleteRowsRequest(
                    delete: DeleteRowsRequest.Delete(rows: [DeleteRowsRequest.DeleteRow(rowId: rowId)]
                                                    )
                )
            )
            XCTAssertTrue(deleteResponse.noOfRowsFailed == 0)
            XCTAssertTrue(deleteResponse.noOfRowsDeleted == 1)
            XCTAssertTrue(deleteResponse.deletedRows[0] == rowId)
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        wait(for: [expectation], timeout: 3)
    }

    func testDeleteRowsWithQuery() async throws {
        let expectation = XCTestExpectation(description: "Delete rows by Query")

        let rowValue = "Test"
        let globalFilter = GlobalFilter.Filter(filterOperator: .LIKE, keyword: rowValue)

        do {

            // Insert a new row
            let insertResponse = try await BigParser.shared.insertRows(
                Constants.gridId,
                insertRowsRequest: InsertRowsRequest(insert:
                                                        InsertRowsRequest.Insert(rows: [
                                                            ["Random Number": rowValue]
                                                        ])
                                                    )
            )

            XCTAssertTrue(insertResponse.createdRows.values.count == 1)

            let deleteResponse = try await BigParser.shared.deleteRows(
                Constants.gridId,
                deleteRowsByQueryRequest:
                    DeleteRowsByQueryRequest(singleGlobalFilter: globalFilter)
            )
            XCTAssertTrue(deleteResponse.noOfRowsDeleted == 1)
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        wait(for: [expectation], timeout: 3)
    }

}
