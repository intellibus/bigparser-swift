//
//  GetGridHeaderResponse.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import Foundation

public struct GetGridHeaderResponse: Codable {
    let name: String
    let welcomeDescription: String?
    let columns: [Column]
    let fileID, fileExtension, fileSource: String?

    enum CodingKeys: String, CodingKey {
        case name
        case welcomeDescription = "description"
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
