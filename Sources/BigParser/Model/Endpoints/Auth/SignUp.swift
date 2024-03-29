//
//  SignUp.swift
//  
//
//  Created by Miroslav Kutak on 01/02/2023.
//

import Foundation

public struct SignUpRequest: Encodable {
    public let fullName: String
    public let emailId: String
    public let password: String

    public init(fullName: String, emailId: String, password: String) {
        self.fullName = fullName
        self.emailId = emailId
        self.password = password
    }
}

public struct SignUpResponse: Decodable {

}
