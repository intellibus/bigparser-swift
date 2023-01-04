//
//  SearchCount.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import Foundation

public struct SearchCountRequest: Encodable {
    let query: Query

    // MARK: - Query
    public struct Query: Encodable {
        let globalFilter: GlobalFilter?
        let columnFilter: ColumnFilter?
    }
}

public extension SearchCountRequest {
    init(
        globalFilter: GlobalFilter? = nil,
        columnFilter: ColumnFilter? = nil
    ) {
        self.init(query: Query(globalFilter: globalFilter, columnFilter: columnFilter))
    }
}

public struct SearchCountResponse: Decodable {
    let totalRowCount: Int
}
