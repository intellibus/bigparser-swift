//
//  BulkCRUDMessage.swift
//  
//
//  Created by Miroslav Kutak on 01/19/2023.
//

import Foundation

// MARK: - Welcome
public struct BulkCRUDMessage: Decodable {
    public let topic, gridId, msgSender: String
//    public let actionType: WebsocketActionType
    public let userInfo: UserInfo
    public let updatedDateTime: Int
    public let payload: Payload

    // MARK: - Payload
    public struct Payload: Decodable {
        public let updateRows: UpdateRows
    }

    // MARK: - UpdateRows
    public struct UpdateRows: Decodable {
        public let rows: [Row]
    }

    // MARK: - Row
    public struct Row: Decodable {
        public let rowId: String
        public let columns: [String: String] // Column name: Value
        public let columnsIndex: ColumnsIndex
    }

    // MARK: - ColumnsIndex
    public struct ColumnsIndex: Decodable {
        // FIXME: missing implementation
    }

    // MARK: - UserInfo
    public struct UserInfo: Decodable {
        public let userId, userEmail, userName, uniqueSessionId: String
    }
}
