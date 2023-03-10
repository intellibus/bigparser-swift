//
//  PinColumn.swift
//  
//
//  Created by Miroslav Kutak on 01/19/2023.
//

import Foundation

public struct PinColumnRequest: Encodable {
    public let columnName: String
    public let columnPinType: PinType

    public enum PinType: String, Encodable {
        case left
        case right
    }

    public init(columnName: String, columnPinType: PinType) {
        self.columnName = columnName
        self.columnPinType = columnPinType
    }
}

public struct PinColumnResponse: Decodable {

}
