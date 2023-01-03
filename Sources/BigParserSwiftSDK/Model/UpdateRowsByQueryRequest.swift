//
//  File.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import Foundation

public struct UpdateRowsByQueryRequest: Codable {
    let update: Update
    let query: Query


    // MARK: - Update
    struct Update: Codable {
        let columns: [String: String]
    }

    // MARK: - Query
    struct Query: Codable {
        let columnFilter: ColumnFilter?
        let globalFilter: GlobalFilter?
    }
}
