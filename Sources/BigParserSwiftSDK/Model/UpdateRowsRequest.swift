//
//  UpdateRowsRequest.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import Foundation

public struct UpdateRowsRequest: Codable {
    let update: Update

    // MARK: - Update
    struct Update: Codable {
        let rows: [UpdateRow]
    }

    struct UpdateRow: Codable {
        let rowId: String
        let columns: [String: String]
    }
}
