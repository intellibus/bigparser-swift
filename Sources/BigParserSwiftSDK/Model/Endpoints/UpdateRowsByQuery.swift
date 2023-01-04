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

public struct UpdateRowsByQueryResponse: Decodable {
    let noOfRowsUpdated: Int
}
