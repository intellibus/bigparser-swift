//
//  UpdateRowsResponse.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import Foundation

public struct UpdateRowsResponse: Codable {
    let noOfRowsUpdated, noOfRowsFailed: Int
    let updatedRows: [String: String]
    let failedRows: [String: String]
}
