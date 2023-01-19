//
//  RenameColumns.swift
//  
//
//  Created by Miroslav Kutak on 01/18/2023.
//

import Foundation

public struct RenameColumnsRequest: Encodable {
    public let columns: [ColumnRename]

    // MARK: - Column
    public struct ColumnRename: Encodable {
        let existingColumnName: String
        let newColumnName: String
    }

    public init(columns: [ColumnRename]) {
        self.columns = columns
    }
}

public struct RenameColumnsResponse: Decodable {

}

