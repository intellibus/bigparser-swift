//
//  WebsocketMessage.swift
//  
//
//  Created by Miroslav Kutak on 01/16/2023.
//

import Foundation

public enum WebsocketMessage {
    case grid(GridWebsocketMessage)
    case string(String)
}

public enum WebsocketActionType: String, Decodable {
    case cellHighlight
    case bulk_crud
}

// MARK: - GridWebsocketMessage
public struct GridWebsocketMessage: Decodable {
    public let topic, gridId, msgSender: String
    public let actionType: WebsocketActionType
    public let userInfo: UserInfo
    public let cursorPosition: CursorPosition
}

// MARK: - CursorPosition
public struct CursorPosition: Decodable {
    public let rowIndex, columnName, columnIndex: String
}

// MARK: - UserInfo
public struct UserInfo: Decodable {
    public let userId, userEmail, userName: String
}
