//
//  DataTypes.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import Foundation

public enum DataType: String, Codable {
    case STRING
    case NUMBER // E.g (with decimal or without decimal): 2 or 12.12 or 2.0
    case DATE // yyyy-MM-dd
    case DATE_TIME // yyyy-MM-dd HH:mm:ss
    case BOOLEAN // true / false
}
