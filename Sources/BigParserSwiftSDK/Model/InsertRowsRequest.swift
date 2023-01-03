//
//  InsertRowsRequest.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import Foundation

public struct InsertRowsRequest: Codable {
    let insert: Insert

    // MARK: - Insert
    struct Insert: Codable {
        let rows: [[String: String]]
    }
}
