//
//  GetGridMetadata.swift
//  
//
//  Created by Miroslav Kutak on 01/02/2023.
//

import Foundation

// No request JSON - it's a GET method

public struct GetMultiSheetMetadataResponse: Decodable {
    let grids: [Grid]

    // MARK: - Grid
    public struct Grid: Decodable {
        let gridId, name: String
    }
}
