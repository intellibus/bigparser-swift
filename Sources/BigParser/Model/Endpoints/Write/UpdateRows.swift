//
//  UpdateRows.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import Foundation

public struct UpdateRowsRequest: Encodable {
    let update: Update

    // MARK: - Update
    struct Update: Encodable {
        let rows: [UpdateRow]
    }

    public struct UpdateRow: Encodable {
        let rowId: String
        let columns: [String: String]

        public init(rowId: String, columns: [String : String]) {
            self.rowId = rowId
            self.columns = columns
        }
    }
}

public extension UpdateRowsRequest {
    init(rows: [UpdateRow]) {
        self.init(update: Update(rows: rows))
    }
}

public struct UpdateRowsResponse: Decodable {
    public let noOfRowsUpdated, noOfRowsCreated, noOfRowsFailed: Int
    public let updatedRows: [String]
    public let createdRows: [String]
    public let failedRows: [String: FailedRowReason]
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
