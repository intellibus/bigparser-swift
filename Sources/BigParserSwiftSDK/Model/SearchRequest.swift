//
//  SearchRequest.swift
//  
//
//  Created by Miroslav Kutak on 01/02/2023.
//

import Foundation

public struct SearchRequest: Codable {
    let query: Query

    // MARK: - Query
    struct Query: Codable {
        let globalFilter: GlobalFilter
        let columnFilter: ColumnFilter?
        let sort: [String: SortDirection]?
        let pagination: Pagination

        enum CodingKeys: String, CodingKey {
            case globalFilter, columnFilter, sort, pagination
        }
    }

    // MARK: - ColumnFilter
    struct ColumnFilter: Codable {
        let filters: [ColumnFilterFilter]
        let filtersJoinOperator: String
    }

    // MARK: - ColumnFilterFilter
    struct ColumnFilterFilter: Codable {
        let column, filterOperator, keyword: String

        enum CodingKeys: String, CodingKey {
            case column
            case filterOperator = "operator"
            case keyword
        }
    }

    // MARK: - GlobalFilter
    struct GlobalFilter: Codable {
        let filters: [GlobalFilterFilter]
        let filtersJoinOperator: String
    }

    // MARK: - GlobalFilterFilter
    struct GlobalFilterFilter: Codable {
        let filterOperator, keyword: String

        enum CodingKeys: String, CodingKey {
            case filterOperator = "operator"
            case keyword
        }
    }

    // MARK: - Pagination
    struct Pagination: Codable {
        let startRow, rowCount: Int
    }

}
