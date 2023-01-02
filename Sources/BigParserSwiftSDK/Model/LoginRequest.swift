//
//  LoginRequest.swift
//  
//
//  Created by Miroslav Kutak on 01/02/2023.
//

import Foundation

public struct LoginRequest: Encodable {
    let emailId: String
    let password: String
    let loggedIn: Bool
}

public struct LoginResponse: Decodable {
    let authID: String
    let subscriptionInfo: SubscriptionInfo
    let userPreference: UserPreference
    let userStatus: String
    let userinfo: Userinfo

    enum CodingKeys: String, CodingKey {
        case authID = "authId"
        case subscriptionInfo, userPreference, userStatus, userinfo
    }
}

// MARK: - SubscriptionInfo
struct SubscriptionInfo: Codable {
    let subscriptionType, orderGridID: String

    enum CodingKeys: String, CodingKey {
        case subscriptionType
        case orderGridID = "orderGridId"
    }
}

// MARK: - UserPreference
struct UserPreference: Codable {
    let notificationType: NotificationType
}

// MARK: - NotificationType
struct NotificationType: Codable {
    let gridPage, myData: Bool

    enum CodingKeys: String, CodingKey {
        case gridPage = "GRID_PAGE"
        case myData = "MY_DATA"
    }
}

// MARK: - Userinfo
struct Userinfo: Codable {
    let id, fullName, emailID, dataStreamID: String
    let gridStreamID, role: String

    enum CodingKeys: String, CodingKey {
        case id, fullName
        case emailID = "emailId"
        case dataStreamID = "dataStreamId"
        case gridStreamID = "gridStreamId"
        case role
    }
}
