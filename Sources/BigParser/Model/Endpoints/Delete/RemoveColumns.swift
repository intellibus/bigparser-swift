//
//  RemoveColumns.swift
//  
//
//  Created by Miroslav Kutak on 01/18/2023.
//

import Foundation

public struct RemoveColumnsRequest: Encodable {
    let columns: [Column]

    struct Column: Encodable {
        public let columnName: String
    }
}

public extension RemoveColumnsRequest {
    init(columnNames: [String]) {
        columns = columnNames.map({ Column(columnName: $0) })
    }
}

public struct RemoveColumnsResponse: Decodable {

}
