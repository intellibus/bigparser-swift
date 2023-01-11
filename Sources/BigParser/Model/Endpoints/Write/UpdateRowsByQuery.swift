//
//  UpdateRowsByQuery.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import Foundation

public struct UpdateRowsByQueryRequest: Encodable {
    let update: Update
    let query: Query

    // MARK: - Update
    public struct Update: Encodable {
        let columns: [String: String]
    }

    // MARK: - Query
    public struct Query: Encodable {
        let globalFilter: GlobalFilter?
        let columnFilter: ColumnFilter?
    }
}

public extension UpdateRowsByQueryRequest {
    init(
        columns: [String: String],
        globalFilter: GlobalFilter? = nil,
        columnFilter: ColumnFilter? = nil
    ) {
        self.init(
            update: Update(columns: columns),
            query: Query(globalFilter: globalFilter, columnFilter: columnFilter)
        )
    }

    init(
        columns: [String: String],
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

        self.init(
            update: Update(columns: columns),
            query: Query(
                globalFilter: globalFilter,
                columnFilter: columnFilter)
        )
    }
}

public struct UpdateRowsByQueryResponse: Decodable {
    public let noOfRowsUpdated: Int
}
