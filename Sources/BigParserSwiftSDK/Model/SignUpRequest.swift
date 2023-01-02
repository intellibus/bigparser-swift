//
//  SignUpRequest.swift
//  
//
//  Created by Miroslav Kutak on 01/02/2023.
//

import Foundation

public struct SignUpRequest: Encodable {
    let fullName: String
    let emailId: String
    let password: String
}
