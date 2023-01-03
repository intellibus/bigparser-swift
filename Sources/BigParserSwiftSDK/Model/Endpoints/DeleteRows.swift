//
//  DeleteRows.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import Foundation

public struct DeleteRowsRequest: Codable {
    let delete: Delete

    // MARK: - Update
    struct Delete: Codable {
        let rows: [DeleteRow]
    }

    struct DeleteRow: Codable {
        let rowId: String
    }
}

public struct DeleteRowsResponse: Codable {
    let noOfRowsDeleted, noOfRowsFailed: Int
    let deletedRows: [String]
    let failedRows: [String: String]
}
