//
//  UpdateTab.swift
//  
//
//  Created by Miroslav Kutak on 01/19/2023.
//

import Foundation

public struct UpdateTabRequest: Encodable {
    public let tabName: String
    public var tabDescription: String?
}

public struct UpdateTabResponse: Decodable {
    
}
