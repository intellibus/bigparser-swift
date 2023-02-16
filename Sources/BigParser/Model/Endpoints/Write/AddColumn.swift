//
//  AddColumnRequest.swift
//  
//
//  Created by Miroslav Kutak on 01/17/2023.
//

import Foundation

public struct AddColumnRequest: Encodable {
    public let newColumnName: String
    public var afterColumn: String?
    public var beforeColumn: String?

    public init(newColumnName: String, afterColumn: String? = nil, beforeColumn: String? = nil) {
        self.newColumnName = newColumnName
        self.afterColumn = afterColumn
        self.beforeColumn = beforeColumn
    }
}

public struct AddColumnResponse: Decodable {
    public let columnIndex: String
}
