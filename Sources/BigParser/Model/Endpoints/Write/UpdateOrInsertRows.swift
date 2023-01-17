//
//  UpdateOrInsertRows.swift
//  
//
//  Created by Miroslav Kutak on 01/17/2023.
//

import Foundation


public struct UpdateOrInsertRowsResponse {
    public let noOfRowsUpdated, noOfRowsCreated, noOfRowsFailed: Int
    public let updatedRows: [String]
    public let createdRows: [String: String]
    public let failedRows: [String: FailedRowReason]
}

public extension UpdateOrInsertRowsResponse {
    init(updateRowsResponse: UpdateRowsResponse, insertRowsResponse: InsertRowsResponse? = nil) {
        var failedRows = [String: FailedRowReason]()
        if let insertRowsResponse = insertRowsResponse {
            failedRows = insertRowsResponse.failedRows
            updateRowsResponse.failedExistingRowIds.forEach({
                if failedRows[$0] == nil {
                    failedRows[$0] = updateRowsResponse.failedRows[$0]
                }
            })
        } else {
            failedRows = updateRowsResponse.failedRows
        }
        noOfRowsUpdated = updateRowsResponse.noOfRowsUpdated
        noOfRowsCreated = insertRowsResponse?.noOfRowsCreated ?? 0
        noOfRowsFailed = failedRows.count
        updatedRows = updateRowsResponse.updatedRows
        createdRows = insertRowsResponse?.createdRows ?? [:]
        self.failedRows = failedRows
    }
}

// MARK: - Convenient extensions

public extension UpdateRowsRequest {
    var plainUpdateRows: [String: [String: String]] {
        var plainUpdateRows = [String: [String: String]]()
        update.rows.forEach({ plainUpdateRows[$0.rowId] = $0.columns })
        return plainUpdateRows
    }

    var plainInsertRows: [[String: String]] {
        update.rows.map({ $0.columns })
    }
}

public extension UpdateRowsResponse {

    /// Returns only those failed rows that failed to update because the row ID didn't exist
    var nonExistingRowIds: [String] {
        failedRows.compactMap({
            $0.value == .invalidRowId ? $0.key : nil
        })
    }

    var failedExistingRowIds: [String] {
        failedRows.compactMap({
            $0.value != .invalidRowId ? $0.key : nil
        })
    }
}
