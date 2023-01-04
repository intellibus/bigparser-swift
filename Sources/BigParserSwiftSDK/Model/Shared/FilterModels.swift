//
//  FilterModels.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import Foundation


// MARK: - ColumnFilter
public struct ColumnFilter: Encodable {
    let filters: [Filter]
    let filtersJoinOperator: JoinOperator

    // MARK: - ColumnFilterFilter
    public struct Filter: Encodable {
        let column, keyword: String
        let filterOperator: Operator

        enum CodingKeys: String, CodingKey {
            case column
            case filterOperator = "operator"
            case keyword
        }
    }
}

// MARK: - GlobalFilter
public struct GlobalFilter: Encodable {
    let filters: [Filter]
    let filtersJoinOperator: JoinOperator

    // MARK: - GlobalFilterFilter
    public struct Filter: Encodable {
        let filterOperator: Operator
        let keyword: String

        enum CodingKeys: String, CodingKey {
            case filterOperator = "operator"
            case keyword
        }
    }
}
