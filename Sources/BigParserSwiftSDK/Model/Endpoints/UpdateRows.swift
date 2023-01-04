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
    }
}

public extension UpdateRowsRequest {
    init(rows: [UpdateRow]) {
        self.init(update: Update(rows: rows))
    }
}

public struct UpdateRowsResponse: Decodable {
    let noOfRowsUpdated, noOfRowsFailed: Int
    let updatedRows: [String]
    let failedRows: [String: String]
}
