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

    public init(filters: [Filter], filtersJoinOperator: JoinOperator) {
        self.filters = filters
        self.filtersJoinOperator = filtersJoinOperator
    }

    // MARK: - ColumnFilterFilter
    public struct Filter: Encodable {
        let column, keyword: String
        let filterOperator: Operator

        public init(column: String, keyword: String, filterOperator: Operator) {
            self.column = column
            self.keyword = keyword
            self.filterOperator = filterOperator
        }

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

    public init(filters: [Filter], filtersJoinOperator: JoinOperator) {
        self.filters = filters
        self.filtersJoinOperator = filtersJoinOperator
    }

    // MARK: - GlobalFilterFilter
    public struct Filter: Encodable {
        let filterOperator: Operator
        let keyword: String

        public init(filterOperator: Operator, keyword: String) {
            self.filterOperator = filterOperator
            self.keyword = keyword
        }

        enum CodingKeys: String, CodingKey {
            case filterOperator = "operator"
            case keyword
        }
    }
}
