//
//  UpdateColumnDataType.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import Foundation

public struct UpdateColumnDataTypeRequest: Encodable {
    let columns: [Column]

    // MARK: - Column
    public struct Column: Encodable {
        let columnName: String
        let dataType: DataType

        public init(columnName: String, dataType: DataType) {
            self.columnName = columnName
            self.dataType = dataType
        }
    }

    public init(columns: [Column]) {
        self.columns = columns
    }
}

public struct UpdateColumnDataTypeResponse: Decodable {

}
