//
//  InsertRows.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import Foundation

public struct InsertRowsRequest: Encodable {
    let insert: Insert

    // MARK: - Insert
    struct Insert: Encodable {
        let rows: [[String: String]]
    }
}

public extension InsertRowsRequest {
    init(rows: [[String: String]]) {
        self.init(insert: Insert(rows: rows))
    }
}

public struct InsertRowsResponse: Decodable {
    let noOfRowsCreated, noOfRowsFailed: Int
    let createdRows: [String: String]
    let failedRows: [String: String]
}
