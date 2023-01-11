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

public extension LoginRequest {
    init(emailId: String, password: String) {
        self.init(emailId: emailId, password: password, loggedIn: true)
    }
}

public struct LoginResponse: Decodable {
    public let authId: String
    public let subscriptionInfo: SubscriptionInfo
    public let userPreference: UserPreference
    public let userStatus: String
    public let userinfo: Userinfo

    // MARK: - SubscriptionInfo
    public struct SubscriptionInfo: Decodable {
        let subscriptionType, orderGridId: String
    }

    // MARK: - UserPreference
    public struct UserPreference: Decodable {
        let notificationType: NotificationType
    }

    // MARK: - NotificationType
    struct NotificationType: Decodable {
        let GRID_PAGE, MY_DATA: Bool
    }

    // MARK: - Userinfo
    public struct Userinfo: Decodable {
        let id, fullName, emailId, dataStreamId: String
        let gridStreamId, role: String
    }

}
