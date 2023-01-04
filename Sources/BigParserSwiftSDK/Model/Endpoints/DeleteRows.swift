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
    public struct Delete: Encodable {
        let rows: [DeleteRow]
    }

    public struct DeleteRow: Encodable {
        let rowId: String
    }
}

public struct DeleteRowsResponse: Decodable {
    let noOfRowsDeleted, noOfRowsFailed: Int
    let deletedRows: [String]
    let failedRows: [String: String]
}
