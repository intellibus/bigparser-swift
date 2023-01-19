//
//  WebsocketMessage.swift
//  
//
//  Created by Miroslav Kutak on 01/16/2023.
//

import Foundation

public enum WebsocketMessage {
    case cellHighlight(CellHighlightMessage)
    case bulkCRUD(BulkCRUDMessage)
    case string(String)
}

public extension WebsocketMessage {
    init?(data: Data) throws {
        // Decode known types
        let decoder = JSONDecoder()
        if let message = try? decoder.decode(CellHighlightMessage.self, from: data) {
            self = .cellHighlight(message)
        } else
        if let message = try? decoder.decode(BulkCRUDMessage.self, from: data) {
            self = .bulkCRUD(message)
        } else
        // Return just string if the message wasn't recognized
        if let string = String(data: data, encoding: .utf8) {
            self = .string(string)
        } else {
            return nil
        }
    }
}


public enum WebsocketActionType: String, Decodable {
    case cellHighlight
    case bulk_crud
}
