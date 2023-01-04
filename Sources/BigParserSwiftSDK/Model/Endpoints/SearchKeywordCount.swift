//
//  SearchKeywordsCount.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import Foundation

public struct SearchKeywordsCountRequest: Encodable {
    let query: Query

    // MARK: - Query
    struct Query: Encodable {
        let globalFilter: GlobalFilter?
        let columnFilter: ColumnFilter?
    }
}

public extension SearchKeywordsCountRequest {
    init(
        globalFilter: GlobalFilter? = nil,
        columnFilter: ColumnFilter? = nil
    ) {
        self.init(query: Query(globalFilter: globalFilter, columnFilter: columnFilter))
    }
}

public struct SearchKeywordsCountResponse: Decodable {
    let globalFilterCount: [Int]
    let columnFilterCount: [Int]
}

