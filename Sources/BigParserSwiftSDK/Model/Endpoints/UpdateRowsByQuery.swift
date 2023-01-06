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
        let columnFilter: ColumnFilter?
        let globalFilter: GlobalFilter?
    }
}

public extension UpdateRowsByQueryRequest {
    init(
        columns: [String: String],
        columnFilter: ColumnFilter? = nil,
        globalFilter: GlobalFilter? = nil
    ) {
        self.init(
            update: Update(columns: columns),
            query: Query(columnFilter: columnFilter, globalFilter: globalFilter)
        )
    }
}

public struct UpdateRowsByQueryResponse: Decodable {
    public let noOfRowsUpdated: Int
}
