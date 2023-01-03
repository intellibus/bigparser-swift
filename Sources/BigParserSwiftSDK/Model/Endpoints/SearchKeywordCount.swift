//
//  SearchKeywordsCount.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import Foundation

public struct SearchKeywordsCountRequest: Codable {
    let query: Query

    // MARK: - Query
    struct Query: Codable {
        let globalFilter: GlobalFilter?
        let columnFilter: ColumnFilter?

        enum CodingKeys: String, CodingKey {
            case globalFilter, columnFilter
        }
    }
}

public struct SearchKeywordsCountResponse: Codable {
    let globalFilterCount: [Int]
    let columnFilterCount: [Int]
}

