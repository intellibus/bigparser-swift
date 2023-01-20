//
//  WebsocketMessage.swift
//  
//
//  Created by Miroslav Kutak on 01/16/2023.
//

import Foundation

// MARK: - WebsocketMessage
public struct WebsocketMessage: Codable {
    public let topic, gridId, msgSender: String
    public let actionType: ActionType
    public let userId: String?
    public let userInfo: UserInfo?
    public let updatedDateTime: Int?
    public let payload: Payload?
    public let cursorPosition: CursorPosition?

    // MARK: - ActionType
    public enum ActionType: String, Codable {
        case cellHighlight
        case removeCellHighlight
        case bulk_crud
        case leaveGrid
        case openGrid
    }

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
        public let userId, userEmail, userName: String
        public let uniqueSessionId: String?
    }

    // MARK: - CursorPosition
    public struct CursorPosition: Codable {
        public let rowIndex, columnName, columnIndex: String?
    }
}


public extension WebsocketMessage {
    init(data: Data) throws {
        let decoder = JSONDecoder()
        let message = try decoder.decode(WebsocketMessage.self, from: data)
        self = message
    }
}
