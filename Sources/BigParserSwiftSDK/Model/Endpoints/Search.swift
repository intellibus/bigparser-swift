//
//  Search.swift
//  
//
//  Created by Miroslav Kutak on 01/02/2023.
//

import Foundation

public struct SearchRequest: Encodable {
    let query: Query

    // MARK: - Query
    public struct Query: Encodable {
        let globalFilter: GlobalFilter
        let columnFilter: ColumnFilter?
        let sort: [String: SortDirection]?
        let pagination: Pagination
    }
}

public struct SearchResponse: Decodable {
    let totalRowCount: Int
    let rows: [[String]]
}
