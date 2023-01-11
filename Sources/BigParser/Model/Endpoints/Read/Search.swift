//
//  Search.swift
//  
//
//  Created by Miroslav Kutak on 01/02/2023.
//

import Foundation

public struct SearchRequest: Encodable {
    var query: Query

    // MARK: - Query
    struct Query: Encodable {
        let globalFilter: GlobalFilter?
        let columnFilter: ColumnFilter?
        let sort: [String: SortDirection]?
        let pagination: Pagination
        var showColumnNamesInResponse: Bool?
    }
}

public extension SearchRequest {
    init(
        globalFilter: GlobalFilter? = nil,
        columnFilter: ColumnFilter? = nil,
        sort: [String: SortDirection]? = nil,
        pagination: Pagination = .standardStart
    ) {
        self.init(query: Query(globalFilter: globalFilter, columnFilter: columnFilter, sort: sort, pagination: pagination, showColumnNamesInResponse: nil))
    }

    init(
        singleGlobalFilter: GlobalFilter.Filter? = nil,
        singleColumnFilter: ColumnFilter.Filter? = nil,
        sort: [String: SortDirection]? = nil,
        pagination: Pagination = .standardStart
    ) {

        var globalFilter: GlobalFilter?
        var columnFilter: ColumnFilter?

        if let singleGlobalFilter = singleGlobalFilter {
            globalFilter = GlobalFilter(filters: [singleGlobalFilter])
        }
        if let singleColumnFilter = singleColumnFilter {
            columnFilter = ColumnFilter(filters: [singleColumnFilter])
        }

        self.init(query:
            Query(
                globalFilter: globalFilter,
                columnFilter: columnFilter,
                sort: sort,
                pagination: pagination,
                showColumnNamesInResponse: nil)
        )
    }
}

public struct SearchResponse: Decodable {
    public let totalRowCount: Int
    public let rows: [[String?]]
}

public struct SearchResponseWithColumnNames: Decodable {
    public let totalRowCount: Int
    public let rows: [[String: String?]]
}
