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
    struct Query: Encodable {
        let globalFilter: GlobalFilter?
        let columnFilter: ColumnFilter?
        let sort: [String: SortDirection]?
        let pagination: Pagination
    }
}

public extension SearchRequest {
    init(
        globalFilter: GlobalFilter? = nil,
        columnFilter: ColumnFilter? = nil,
        sort: [String: SortDirection]? = nil,
        pagination: Pagination
    ) {
        self.init(query: Query(globalFilter: globalFilter, columnFilter: columnFilter, sort: sort, pagination: pagination))
    }
}

public struct SearchResponse: Decodable {
    public let totalRowCount: Int
    public let rows: [[String]]
}
