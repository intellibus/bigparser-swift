//
//  File.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import Foundation

public struct IntellisenseRequest: Codable {
    let column, keyword: String
    let pagination: Pagination
    let filterOperator: Operator

    enum CodingKeys: String, CodingKey {
        case column
        case filterOperator = "operator"
        case keyword, pagination
    }
}

public struct IntellisenseResponse: Codable {
    let matchingValues: [String]
}
