//
//  DeleteRowsByQuery.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import Foundation

public struct DeleteRowsByQueryRequest: Encodable {
    let delete: Delete

    // MARK: - Update
    struct Delete: Encodable {
        let query: Query
    }

    // MARK: - Query
    struct Query: Encodable {
        let globalFilter: GlobalFilter?
        let columnFilter: ColumnFilter?
    }
}

public extension DeleteRowsByQueryRequest {
    init(globalFilter: GlobalFilter? = nil, columnFilter: ColumnFilter? = nil) {
        self.init(delete: Delete(query: Query(globalFilter: globalFilter, columnFilter: columnFilter)))
    }

    init(
        singleGlobalFilter: GlobalFilter.Filter? = nil,
        singleColumnFilter: ColumnFilter.Filter? = nil
    ) {

        var globalFilter: GlobalFilter?
        var columnFilter: ColumnFilter?

        if let singleGlobalFilter = singleGlobalFilter {
            globalFilter = GlobalFilter(filters: [singleGlobalFilter])
        }
        if let singleColumnFilter = singleColumnFilter {
            columnFilter = ColumnFilter(filters: [singleColumnFilter])
        }

        self.init(delete:
            Delete(query:
                Query(
                    globalFilter: globalFilter,
                    columnFilter: columnFilter)
           )
        )
    }
}

public struct DeleteRowsByQueryResponse: Decodable {
    public let noOfRowsDeleted: Int
}
