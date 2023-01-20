//
//  LeaveGridMessage.swift
//  
//
//  Created by Miroslav Kutak on 01/19/2023.
//

import Foundation

public struct LeaveGridMessage: Codable {
    public let gridId: String
//    public let actionType: WebsocketActionType
    public let msgSender: String
    public let userId: String
    public let userInfo: UserInfo?

    // MARK: - UserInfo
    public struct UserInfo: Codable {
        public let userId, userEmail, userName: String
    }
}
