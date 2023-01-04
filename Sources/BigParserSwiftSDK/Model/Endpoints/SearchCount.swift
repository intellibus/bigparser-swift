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

public struct SearchCountResponse: Decodable {
    let totalRowCount: Int
}
