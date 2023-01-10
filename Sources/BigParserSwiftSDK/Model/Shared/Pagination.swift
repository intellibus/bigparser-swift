//
//  File.swift
//  
//
//  Created by Miroslav Kutak on 01/02/2023.
//

import Foundation

public struct Pagination: Codable {
    public let startRow, rowCount: Int

    public init(startRow: Int, rowCount: Int) {
        self.startRow = startRow
        self.rowCount = rowCount
    }
}

public extension Pagination {
    static let oneRow = Pagination(startRow: 0, rowCount: 1)
    static let standardStart = Pagination(startRow: 0, rowCount: 50)
}
