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
    public let noOfRowsUpdated, noOfRowsFailed: Int
    public let updatedRows: [String]
    public let failedRows: [String: FailedRowReason]
}
