//
//  FilterModels.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import Foundation


// MARK: - ColumnFilter
public struct ColumnFilter: Codable {
    let filters: [Filter]
    let filtersJoinOperator: String

    // MARK: - ColumnFilterFilter
    struct Filter: Codable {
        let column, filterOperator, keyword: String

        enum CodingKeys: String, CodingKey {
            case column
            case filterOperator = "operator"
            case keyword
        }
    }
}

// MARK: - GlobalFilter
public struct GlobalFilter: Codable {
    let filters: [Filter]
    let filtersJoinOperator: String


    // MARK: - GlobalFilterFilter
    struct Filter: Codable {
        let filterOperator, keyword: String

        enum CodingKeys: String, CodingKey {
            case filterOperator = "operator"
            case keyword
        }
    }
}
