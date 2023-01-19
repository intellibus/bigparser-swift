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
}

public struct UpdateColumnDescriptionResponse: Decodable {

}
