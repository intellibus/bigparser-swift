//
//  UnPinColumn.swift
//  
//
//  Created by Miroslav Kutak on 01/19/2023.
//

import Foundation

public struct UnPinColumnRequest: Encodable {
    public let columnName: String

    public init(columnName: String) {
        self.columnName = columnName
    }
}

public struct UnPinColumnResponse: Decodable {

}
