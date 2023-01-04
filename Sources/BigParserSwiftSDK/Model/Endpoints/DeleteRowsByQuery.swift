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
        let columnFilter: ColumnFilter?
        let globalFilter: GlobalFilter?
    }
}

public extension DeleteRowsByQueryRequest {
    init(columnFilter: ColumnFilter? = nil, globalFilter: GlobalFilter? = nil) {
        self.init(delete: Delete(query: Query(columnFilter: columnFilter, globalFilter: globalFilter)))
    }
}

public struct DeleteRowsByQueryResponse: Decodable {
    let noOfRowsDeleted: Int
}
