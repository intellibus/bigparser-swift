//
//  CreateGrid.swift
//  
//
//  Created by Miroslav Kutak on 01/19/2023.
//

import Foundation

public struct CreateGridRequest: Encodable {
    public let gridName: String
    public var gridDescription: String?

    public init(gridName: String, gridDescription: String? = nil) {
        self.gridName = gridName
        self.gridDescription = gridDescription
    }
}

public struct CreateGridResponse: Decodable {
    public let gridId: String
}
