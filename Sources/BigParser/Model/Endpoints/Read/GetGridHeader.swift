//
//  GetGridHeader.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import Foundation

// No request JSON - it's a GET method

public struct GetGridHeaderResponse: Decodable {
    public let name: String
    public let description: String?
    public let columns: [Column]
    public let fileId, fileExtension, fileSource: String?

    // MARK: - Columns
    public struct Column: Decodable {
        public let columnName, columnDesc, dataType, columnIndex: String
        public let islinkedColumn, isPrimaryLink: Bool
    }
}
