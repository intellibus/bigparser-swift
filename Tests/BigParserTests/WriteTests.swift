//
//  WriteTests.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import XCTest
@testable import BigParser

final class WriteTests: XCTestCase {

    private struct WriteConstants {
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
            try await BigParser.shared.insertRows(
                Constants.unitTestGridId,
                request: InsertRowsRequest(insert:
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
            try await BigParser.shared.insertRows(
                Constants.unitTestGridId,
                request: InsertRowsRequest(insert:
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
            try await BigParser.shared.updateOrInsertRows(
                Constants.unitTestGridId,
                request: UpdateRowsRequest(update:
                                                        UpdateRowsRequest.Update(rows: [
                                                            UpdateRowsRequest.UpdateRow(
                                                                rowId: WriteConstants.row0Id,
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
        let expectation = XCTestExpectation(description: "Update 2 rows")


        do {
            try await BigParser.shared.updateOrInsertRows(
                Constants.unitTestGridId,
                request: UpdateRowsRequest(update:
                                                        UpdateRowsRequest.Update(rows: [
                                                            UpdateRowsRequest.UpdateRow(
                                                                rowId: WriteConstants.row0Id,
                                                                columns: [
                                                                    "Random Number": "\(arc4random() % 100)"
                                                                ]),
                                                            UpdateRowsRequest.UpdateRow(
                                                                rowId: WriteConstants.row1Id,
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

    func testUpdateOrInsertTwoRows() async throws {
        let expectation = XCTestExpectation(description: "Update or insert rows")

        /*
         1. insert 2 rows (to make sure they exist)
         2. delete 1 out of these rows
         3. the other row should still exist, so insert or update should result in one inserted, one updated, no failures
         */
        do {

            let deleteRowColumns = ["Random Number": "\(arc4random() % 100)"]
            let keepRowColumns = ["Random Number": "\(arc4random() % 100)"]
            let rows = [deleteRowColumns, keepRowColumns]

            // Insert 2 rows (to make sure they exist)
            let initialInsertResponse = try await BigParser.shared.insertRows(
                Constants.unitTestGridId,
                request: InsertRowsRequest(insert: InsertRowsRequest.Insert(rows: rows))
            )

            XCTAssertTrue(initialInsertResponse.noOfRowsFailed == 0)
            XCTAssertTrue(initialInsertResponse.noOfRowsCreated == 2)
            XCTAssertTrue(initialInsertResponse.createdRows.count == 2)
            guard let deleteRowId = initialInsertResponse.createdRows["0"],
                  let keepRowId = initialInsertResponse.createdRows["1"] else {
                XCTFail("Wrong response format of `createdRows`")
                return
            }

            // Delete the one again
            let deleteResponse = try await BigParser.shared.deleteRows(
                Constants.unitTestGridId,
                request: DeleteRowsRequest(rowIds: [deleteRowId])
            )

            XCTAssertTrue(deleteResponse.noOfRowsFailed == 0)
            XCTAssertTrue(deleteResponse.noOfRowsDeleted == 1)
            XCTAssertTrue(deleteResponse.deletedRows[0] == deleteRowId)

            // The other row should still exist, so insert or update should result in one inserted, one updated, no failures
            let updateOrInsertRowsResponse = try await BigParser.shared.updateOrInsertRows(
                Constants.unitTestGridId,
                request:
                    UpdateRowsRequest(rows: [
                        UpdateRowsRequest.UpdateRow(rowId: deleteRowId, columns: ["Random Number": "\(arc4random() % 100)"]),
                        UpdateRowsRequest.UpdateRow(rowId: keepRowId, columns: ["Random Number": "\(arc4random() % 100)"])
                    ])
            )

            XCTAssertTrue(updateOrInsertRowsResponse.noOfRowsFailed == 0)
            XCTAssertTrue(updateOrInsertRowsResponse.noOfRowsCreated == 1)
            XCTAssertTrue(updateOrInsertRowsResponse.noOfRowsUpdated == 1)
            XCTAssertTrue(updateOrInsertRowsResponse.updatedRows[0] == keepRowId)
            XCTAssertTrue(updateOrInsertRowsResponse.createdRows.first == deleteRowId)

            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        wait(for: [expectation], timeout: 10)
    }

    func testUpdateRowsByQuery() async throws {
        let expectation = XCTestExpectation(description: "Update row")

        let globalFilter = GlobalFilter(filters: [GlobalFilter.Filter(filterOperator: .LIKE, keyword: "Paper")],
                         filtersJoinOperator: .OR)

        do {
            try await BigParser.shared.updateRows(
                Constants.unitTestGridId,
                request:
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

    func testAddColumn() async throws {
        let expectation = XCTestExpectation(description: "Add column")
        let newColumnName = "Test Add Single Column"

        do {
            try await BigParser.shared.addColumn(
                Constants.unitTestGridId,
                request: AddColumnRequest(newColumnName: newColumnName)
            )

            // Delete the column again to clean up
            try await BigParser.shared.removeColumns(
                Constants.unitTestGridId,
                request: RemoveColumnsRequest(columnNames: [newColumnName])
            )

            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        wait(for: [expectation], timeout: 3)
    }

    func testAddColumns() async throws {
        let expectation = XCTestExpectation(description: "Add columns")

        let newColumnNames = ["Identification", "Message", "DebugInfo", "Stack Trace", "File", "Line", "Number Of Times Reported", "App Version", "Last Occurred At", "Last User This Happened To", "Message"]

        do {
            // Insert the columns
            try await BigParser.shared.addColumns(
                Constants.unitTestGridId,
                request: AddColumnsRequest(columnNames: newColumnNames))

            // Delete the columns again to clean up
            try await BigParser.shared.removeColumns(
                Constants.unitTestGridId,
                request: RemoveColumnsRequest(columnNames: newColumnNames)
            )

            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        wait(for: [expectation], timeout: 3)
    }

    func testRenameColumn() async throws {
        let expectation = XCTestExpectation(description: "Rename Column")
        let newColumnName = "Test Rename Column"
        let newColumnUpdatedName = "Test Renamed Column"


        // First create a column
        let _ = try? await BigParser.shared.addColumn(
            Constants.unitTestGridId,
            request: AddColumnRequest(newColumnName: newColumnName)
        )

        do {
            // Then rename it
            try await BigParser.shared.renameColumns(
                Constants.unitTestGridId,
                request: RenameColumnsRequest(
                    columns: [
                        RenameColumnsRequest.ColumnRename(existingColumnName: newColumnName, newColumnName: newColumnUpdatedName)
                    ]
                )
            )

            // Delete the column again to clean up
            try await BigParser.shared.removeColumns(
                Constants.unitTestGridId,
                request: RemoveColumnsRequest(columnNames: [newColumnName])
            )

            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        wait(for: [expectation], timeout: 3)
    }

    func testReorderColumn() async throws {
        let expectation = XCTestExpectation(description: "Reorder Column")
        let newColumnName = "Test Reorder Column"

        do {
            // First create a column
            try await BigParser.shared.addColumn(
                Constants.unitTestGridId,
                request: AddColumnRequest(newColumnName: newColumnName)
            )

            // Then reorder it
            try await BigParser.shared.reorderColumn(
                Constants.unitTestGridId,
                request: ReorderColumnRequest(columnName: newColumnName, columnNewIndex: "1")
            )

            // Delete the column again to clean up
            try await BigParser.shared.removeColumns(
                Constants.unitTestGridId,
                request: RemoveColumnsRequest(columnNames: [newColumnName])
            )

            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        wait(for: [expectation], timeout: 3)
    }

    func testPinUnpinColumn() async throws {
        let expectation = XCTestExpectation(description: "Pin Column")
        let newColumnName = "Test Pin Column"

        do {
            // First create a column
            try await BigParser.shared.addColumn(
                Constants.unitTestGridId,
                request: AddColumnRequest(newColumnName: newColumnName)
            )

            // Then pin it to the left
            try await BigParser.shared.pinColumn(
                Constants.unitTestGridId,
                request: PinColumnRequest(columnName: newColumnName, columnPinType: .left)
            )

            // And unpin it
            try await BigParser.shared.unPinColumn(
                Constants.unitTestGridId,
                request: UnPinColumnRequest(columnName: newColumnName)
            )

            // Then pin it again to the right
            try await BigParser.shared.pinColumn(
                Constants.unitTestGridId,
                request: PinColumnRequest(columnName: newColumnName, columnPinType: .right)
            )

            // And unpin it by unpinning all
            try await BigParser.shared.unPinAllColumns(
                Constants.unitTestGridId,
                request: UnPinAllColumnsRequest()
            )

            // Delete the column again to clean up
            try await BigParser.shared.removeColumns(
                Constants.unitTestGridId,
                request: RemoveColumnsRequest(columnNames: [newColumnName])
            )

            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        wait(for: [expectation], timeout: 5)
    }

    func testUpdateColumnDescription() async throws {
        let expectation = XCTestExpectation(description: "Update column description")

        do {
            try await BigParser.shared.updateColumnDescription(
                Constants.unitTestGridId,
                request: UpdateColumnDescriptionRequest(columnName: "Random Number", columnDesc: "Random description \(arc4random() % 100)")
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
            try await BigParser.shared.updateColumnDataType(
                Constants.unitTestGridId,
                request:
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

    func testCreateGrid() async throws {
        let expectation = XCTestExpectation(description: "Create Grid")

        do {
            try await BigParser.shared.createGrid(request: CreateGridRequest(gridName: "Test Grid 1"))
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        wait(for: [expectation], timeout: 3)
    }

    func testUpdateTab() async throws {
        let expectation = XCTestExpectation(description: "Update Tab")

        let parentGridId = "63c9b0fedf96950e4c2a1bde"

        do {
            // First create a tab
            let createTabResponse = try await BigParser.shared.createTab(parentGridId, request: CreateTabRequest(tabName: "Update Grid Test"))
            let newTabGridId = createTabResponse.gridId
            // Then update the name
            try await BigParser.shared.updateTab(newTabGridId, request: UpdateTabRequest(tabName: "Updated Grid Name"))
            // Then delete it
            try await BigParser.shared.deleteTab(newTabGridId, request: DeleteTabRequest())
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        wait(for: [expectation], timeout: 3)
    }


}
