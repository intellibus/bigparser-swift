//
//  DeleteTests.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import XCTest
@testable import BigParser

final class DeleteTests: XCTestCase {

    var auth: BigParser.Authorization = .none

    override func setUpWithError() throws {
        auth = BigParser.Authorization.authId(Constants.authId)
    }

    override func tearDownWithError() throws {
        auth = .none
    }

    func testDeleteRows() async throws {
        let expectation = XCTestExpectation(description: "Delete rows by Id")

        do {
            // Insert a new row
            let insertResponse = try await BigParser.shared.insertRows(
                auth: auth,
                gridId: Constants.unitTestGridId,
                request: InsertRowsRequest(insert: InsertRowsRequest.Insert(rows: [
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
                auth: auth,
                gridId: Constants.unitTestGridId,
                request: DeleteRowsRequest(
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

        await fulfillment(of: [expectation], timeout: 3)
    }

    func testDeleteRowsWithQuery() async throws {
        let expectation = XCTestExpectation(description: "Delete rows by Query")

        let rowValue = "Test"
        let globalFilter = GlobalFilter.Filter(filterOperator: .LIKE, keyword: rowValue)

        do {
            // Insert a new row
            let insertResponse = try await BigParser.shared.insertRows(
                auth: auth,
                gridId: Constants.unitTestGridId,
                request: InsertRowsRequest(insert:
                                                        InsertRowsRequest.Insert(rows: [
                                                            ["Random Number": rowValue]
                                                        ])
                                                    )
            )

            XCTAssertTrue(insertResponse.createdRows.values.count == 1)

            let deleteResponse = try await BigParser.shared.deleteRows(
                auth: auth,
                gridId: Constants.unitTestGridId,
                request: DeleteRowsByQueryRequest(singleGlobalFilter: globalFilter)
            )
            XCTAssertTrue(deleteResponse.noOfRowsDeleted == 1)
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        await fulfillment(of: [expectation], timeout: 3)
    }

    func testDeleteColumns() async throws {
        let expectation = XCTestExpectation(description: "Remove columns")

        let newColumnNames = ["Identification", "Message", "DebugInfo", "Stack Trace", "File", "Line", "Number Of Times Reported", "App Version", "Last Occurred At", "Last User This Happened To", "Message"]

        do {
            // Insert new columns
            let addResponse: [AddColumnsResponse] = try await BigParser.shared.addColumns(
                auth: auth,
                gridId: Constants.unitTestGridId,
                request: AddColumnsRequest(columnNames: newColumnNames))

            XCTAssertTrue(addResponse.count == newColumnNames.count)

            // Delete the columns again
            try await BigParser.shared.removeColumns(
                auth: auth,
                gridId: Constants.unitTestGridId,
                request: RemoveColumnsRequest(columnNames: newColumnNames)
            )
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        await fulfillment(of: [expectation], timeout: 3)
    }

    func testDeleteGrid() async throws {
        let expectation = XCTestExpectation(description: "Delete Tab")

        let parentGridId = Constants.unitTestGridId

        do {
            // First create a tab
            let createTabResponse = try await BigParser.shared.createTab(auth: auth, gridId: parentGridId, request: CreateTabRequest(tabName: "Delete Grid Test"))
            // Then delete it
            try await BigParser.shared.deleteTab(auth: auth, gridId: createTabResponse.gridId, request: DeleteTabRequest())
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        await fulfillment(of: [expectation], timeout: 3)
    }
}
