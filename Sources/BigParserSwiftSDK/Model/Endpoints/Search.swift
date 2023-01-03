//
//  Search.swift
//  
//
//  Created by Miroslav Kutak on 01/02/2023.
//

import Foundation

public struct SearchRequest: Codable {
    let query: Query

    // MARK: - Query
    struct Query: Codable {
        let globalFilter: GlobalFilter
        let columnFilter: ColumnFilter?
        let sort: [String: SortDirection]?
        let pagination: Pagination

        enum CodingKeys: String, CodingKey {
            case globalFilter, columnFilter, sort, pagination
        }
    }
}

public struct SearchResponse: Decodable {
    let totalRowCount: Int
    let rows: [[String]]
}