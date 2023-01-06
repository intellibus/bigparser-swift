//
//  DeleteRows.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import Foundation

public struct DeleteRowsRequest: Encodable {
    let delete: Delete

    // MARK: - Update
    struct Delete: Encodable {
        let rows: [DeleteRow]
    }

    struct DeleteRow: Encodable {
        let rowId: String
    }
}

public extension DeleteRowsRequest {
    init(rowIds: [String]) {
        self.init(delete: Delete(rows: rowIds.map({ DeleteRow(rowId: $0) })))
    }
}

public struct DeleteRowsResponse: Decodable {
    public let noOfRowsDeleted, noOfRowsFailed: Int
    public let deletedRows: [String]
    public let failedRows: [String: String]
}
