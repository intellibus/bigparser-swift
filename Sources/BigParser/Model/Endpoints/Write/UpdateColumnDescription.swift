//
//  UpdateColumnDescription.swift
//  
//
//  Created by Miroslav Kutak on 01/19/2023.
//

import Foundation

public struct UpdateColumnDescriptionRequest: Encodable {
    public let columnName: String
    public let columnDesc: String

    public init(columnName: String, columnDesc: String) {
        self.columnName = columnName
        self.columnDesc = columnDesc
    }
}

public struct UpdateColumnDescriptionResponse: Decodable {

}
