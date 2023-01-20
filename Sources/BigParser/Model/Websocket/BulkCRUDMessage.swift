//
//  BulkCRUDMessage.swift
//  
//
//  Created by Miroslav Kutak on 01/19/2023.
//

import Foundation

// MARK: - Welcome
public struct BulkCRUDMessage: Codable {
    public let topic, gridId, msgSender: String
//    public let actionType: WebsocketActionType
    public let userId: String?
    public let userInfo: UserInfo?
    public let updatedDateTime: Int
    public let payload: Payload

    // MARK: - Payload
    public struct Payload: Codable {
        public let updateRows: UpdateRows
    }

    // MARK: - UpdateRows
    public struct UpdateRows: Codable {
        public let rows: [Row]
    }

    // MARK: - Row
    public struct Row: Codable {
        public let rowId: String
        public let columns: [String: String] // Column name: Value
        public let columnsIndex: ColumnsIndex
    }

    // MARK: - ColumnsIndex
    public struct ColumnsIndex: Codable {
        // FIXME: missing implementation
    }

    // MARK: - UserInfo
    public struct UserInfo: Codable {
        public let userId, userEmail, userName, uniqueSessionId: String
    }
}
