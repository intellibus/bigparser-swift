//
//  GetGridMetadata.swift
//  
//
//  Created by Miroslav Kutak on 01/02/2023.
//

import Foundation

// No request JSON - it's a GET method

public struct GetMultiSheetMetadataResponse: Codable {
    let grids: [Grid]

    // MARK: - Grid
    public struct Grid: Codable {
        let gridID, name: String

        enum CodingKeys: String, CodingKey {
            case gridID = "gridId"
            case name
        }
    }
}
