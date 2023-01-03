//
//  UpdateColumnDataType.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import Foundation

public struct UpdateColumnDataTypeRequest: Codable {
    let columns: [Column]

    // MARK: - Column
    struct Column: Codable {
        let columnName: String
        let dataType: DataType
    }
}

public struct UpdateColumnDataTypeResponse: Codable {

}
