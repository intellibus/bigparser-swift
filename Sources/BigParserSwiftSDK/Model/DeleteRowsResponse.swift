//
//  DeleteRowsResponse.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import Foundation

public struct DeleteRowsResponse: Codable {
    let noOfRowsDeleted, noOfRowsFailed: Int
    let deletedRows: [String]
    let failedRows: [String: String]
}
