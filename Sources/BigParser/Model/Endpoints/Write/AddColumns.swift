//
//  AddColumnsRequest.swift
//  
//
//  Created by Miroslav Kutak on 01/17/2023.
//

import Foundation

public struct AddColumnsRequest: Encodable {
    public var newColumns: [Column]
    public var afterColumn: String?
    public var beforeColumn: String?

    public struct Column: Encodable {
        public let columnName: String
        public let columnDesc: String

        public init(columnName: String, columnDesc: String) {
            self.columnName = columnName
            self.columnDesc = columnDesc
        }
    }

    public init(newColumns: [AddColumnsRequest.Column], afterColumn: String? = nil, beforeColumn: String? = nil) {
        self.newColumns = newColumns
        self.afterColumn = afterColumn
        self.beforeColumn = beforeColumn
    }

    public init(columnNames: [String], afterColumn: String? = nil, beforeColumn: String? = nil) {
        self.init(
            newColumns: columnNames.map({ AddColumnsRequest.Column(columnName: $0, columnDesc: "") }),
            afterColumn: afterColumn,
            beforeColumn: beforeColumn
        )
    }
}

// Keep in mind it's an array that's coming back
public struct AddColumnsResponse: Decodable {
    public let columnName: String
    public let columnIndex: String
}
