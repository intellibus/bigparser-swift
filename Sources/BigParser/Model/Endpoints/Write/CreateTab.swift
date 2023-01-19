//
//  CreateTab.swift
//  
//
//  Created by Miroslav Kutak on 01/19/2023.
//

import Foundation

public struct CreateTabRequest: Encodable {
    public let tabName: String
    public var tabDescription: String?
}

public struct CreateTabResponse: Decodable {
    public let gridId: String
}
