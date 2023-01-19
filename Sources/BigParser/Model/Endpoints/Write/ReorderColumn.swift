//
//  ReorderColumn.swift
//  
//
//  Created by Miroslav Kutak on 01/19/2023.
//

import Foundation

public struct ReorderColumnRequest: Encodable {
    public let columnName: String
    public let columnNewIndex: String
}

public struct ReorderColumnResponse: Decodable {

}
