//
//  WebsocketMessage.swift
//  
//
//  Created by Miroslav Kutak on 01/16/2023.
//

import Foundation

enum WebsocketMessage {
    case grid(GridWebsocketMessage)
    case string(String)
}

enum WebsocketActionType: String, Decodable {
    case cellHighlight
}

// MARK: - GridWebsocketMessage
struct GridWebsocketMessage: Decodable {
    let topic, gridId, msgSender: String
    let actionType: WebsocketActionType
    let userInfo: UserInfo
    let cursorPosition: CursorPosition
}

// MARK: - CursorPosition
struct CursorPosition: Decodable {
    let rowIndex, columnName, columnIndex: String
}

// MARK: - UserInfo
struct UserInfo: Decodable {
    let userId, userEmail, userName: String
}
