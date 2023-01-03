//
//  GetGridHeader.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import Foundation

// No request JSON - it's a GET method

public struct GetGridHeaderResponse: Codable {
    let name: String
    let description: String?
    let columns: [Column]
    let fileID, fileExtension, fileSource: String?

    enum CodingKeys: String, CodingKey {
        case name
        case description
        case columns
        case fileID = "fileId"
        case fileExtension, fileSource
    }

    // MARK: - Columns
    public struct Column: Codable {
        let columnName, columnDesc, dataType, columnIndex: String
        let islinkedColumn, isPrimaryLink: Bool
    }
}
