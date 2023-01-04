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
    public struct Delete: Encodable {
        let query: Query
    }

    // MARK: - Query
    public struct Query: Encodable {
        let columnFilter: ColumnFilter?
        let globalFilter: GlobalFilter?
    }
}

public struct DeleteRowsByQueryResponse: Decodable {
    let noOfRowsDeleted: Int
}
