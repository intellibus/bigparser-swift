//
//  WriteTests.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import XCTest
@testable import BigParser

final class WriteTests: XCTestCase {

    private struct Constants {
        static let authId = "fcd0b8a0-5fae-449d-a977-0426915f42a0"
        static let gridId = "63b3f7f2afe52c4a2373a9ed"
        static let row0Id = "63b3f902a360a56c50361641"
        static let row1Id = "63b3f902a360a56c50361642"
    }

    override func setUpWithError() throws {
        BigParser.shared.authId = Constants.authId
    }

    override func tearDownWithError() throws {
        BigParser.shared.authId = nil
    }

    func testInsertRow() async throws {
        let expectation = XCTestExpectation(description: "Insert row")


        do {
            let _ = try await BigParser.shared.insertRows(
                Constants.gridId,
                insertRowsRequest: InsertRowsRequest(insert:
                                                        InsertRowsRequest.Insert(rows: [
                                                            ["Random Number": "\(arc4random() % 100)"]
                                                        ])
                                                    )
            )
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        wait(for: [expectation], timeout: 3)
    }

    func testInsertTwoRows() async throws {
        let expectation = XCTestExpectation(description: "Insert two rows")


        do {
            let _ = try await BigParser.shared.insertRows(
                Constants.gridId,
                insertRowsRequest: InsertRowsRequest(insert:
                                                        InsertRowsRequest.Insert(rows: [
                                                            ["Random Number": "\(arc4random() % 100)"],
                                                            ["Random Number": "\(arc4random() % 100)"]
                                                        ])
                                                    )
            )
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        wait(for: [expectation], timeout: 3)
    }

    func testUpdateRow() async throws {
        let expectation = XCTestExpectation(description: "Update row")


        do {
            let _ = try await BigParser.shared.updateRows(
                Constants.gridId,
                updateRowsRequest: UpdateRowsRequest(update:
                                                        UpdateRowsRequest.Update(rows: [
                                                            UpdateRowsRequest.UpdateRow(
                                                                rowId: Constants.row0Id,
                                                                columns: [
                                                                    "Random Number": "\(arc4random() % 100)"
                                                                ])
                                                        ])
                                                    )
            )
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        wait(for: [expectation], timeout: 3)
    }

    func testUpdateTwoRows() async throws {
        let expectation = XCTestExpectation(description: "Update row")


        do {
            let _ = try await BigParser.shared.updateRows(
                Constants.gridId,
                updateRowsRequest: UpdateRowsRequest(update:
                                                        UpdateRowsRequest.Update(rows: [
                                                            UpdateRowsRequest.UpdateRow(
                                                                rowId: Constants.row0Id,
                                                                columns: [
                                                                    "Random Number": "\(arc4random() % 100)"
                                                                ]),
                                                            UpdateRowsRequest.UpdateRow(
                                                                rowId: Constants.row1Id,
                                                                columns: [
                                                                    "Random Number": "\(arc4random() % 100)"
                                                                ])
                                                        ])
                                                    )
            )
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        wait(for: [expectation], timeout: 3)
    }

    func testUpdateRowsByQuery() async throws {
        let expectation = XCTestExpectation(description: "Update row")

        let globalFilter = GlobalFilter(filters: [GlobalFilter.Filter(filterOperator: .LIKE, keyword: "Paper")],
                         filtersJoinOperator: .OR)

        do {
            let _ = try await BigParser.shared.updateRows(
                Constants.gridId,
                updateRowsByQueryRequest:
                    UpdateRowsByQueryRequest(
                        columns: ["Random Number": "\(arc4random() % 100)"],
                        globalFilter: globalFilter
                    )
            )
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        wait(for: [expectation], timeout: 3)
    }

    func testUpdateColumnDataType() async throws {
        let expectation = XCTestExpectation(description: "Update column data type")


        do {
            let _ = try await BigParser.shared.updateColumnDataType(
                Constants.gridId,
                updateColumnDataTypeRequest:
                    UpdateColumnDataTypeRequest(columns:
                        [
                            UpdateColumnDataTypeRequest.Column (
                                columnName: "Random Number",
                                dataType: .STRING
                            )
                        ]
                )
            )
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        wait(for: [expectation], timeout: 3)
    }
}
