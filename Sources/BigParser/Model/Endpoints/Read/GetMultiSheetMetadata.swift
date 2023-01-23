//
//  GetGridMetadata.swift
//  
//
//  Created by Miroslav Kutak on 01/02/2023.
//

import Foundation

// No request JSON - it's a GET method

public struct GetMultiSheetMetadataResponse: Decodable {
    public let grids: [Grid]

    // MARK: - Grid
    public struct Grid: Decodable {
        public let gridId, name: String
    }
}
