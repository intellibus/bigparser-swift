//
//  GetGridHeader.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import Foundation

// No request JSON - it's a GET method

public struct GetGridHeaderResponse: Decodable {
    let name: String
    let description: String?
    let columns: [Column]
    let fileId, fileExtension, fileSource: String?

    // MARK: - Columns
    public struct Column: Decodable {
        let columnName, columnDesc, dataType, columnIndex: String
        let islinkedColumn, isPrimaryLink: Bool
    }
}
