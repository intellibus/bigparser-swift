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

    public init(tabName: String, tabDescription: String? = nil) {
        self.tabName = tabName
        self.tabDescription = tabDescription
    }
}

public struct UpdateTabResponse: Decodable {
    
}
