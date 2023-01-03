//
//  File.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import Foundation

public struct DeleteRowsByQueryRequest: Codable {
    let delete: Delete

    // MARK: - Update
    struct Delete: Codable {
        let query: Query
    }

    // MARK: - Query
    struct Query: Codable {
        let columnFilter: ColumnFilter?
        let globalFilter: GlobalFilter?
    }
}
