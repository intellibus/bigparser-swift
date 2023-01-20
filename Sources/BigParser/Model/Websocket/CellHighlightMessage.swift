//
//  CellHighlightMessage.swift
//  
//
//  Created by Miroslav Kutak on 01/19/2023.
//

import Foundation

// MARK: - GridWebsocketMessage
public struct CellHighlightMessage: Codable {
    public let topic, gridId, msgSender: String
//    public let actionType: WebsocketActionType
    public let userId: String?
    public let userInfo: UserInfo?
    public let cursorPosition: CursorPosition

    // MARK: - CursorPosition
    public struct CursorPosition: Codable {
        public let rowIndex, columnName, columnIndex: String
    }

    // MARK: - UserInfo
    public struct UserInfo: Codable {
        public let userId, userEmail, userName: String
    }

}
