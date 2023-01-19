//
//  File.swift
//  
//
//  Created by Miroslav Kutak on 01/02/2023.
//

import Foundation

public enum BigParserRequestError: Error {
    case emptyResponse
    case unknownError
    case unauthorized
}


public struct BigParserErrorResponse: Decodable, Error {
    public let errorMessage: String
    public let errorType: ErrorType

    // TODO: fill up all the valid types and replace errorType's String type with ErrorType
    public enum ErrorType: String, Decodable {
        case SYSTEMERROR
        case DATAERROR
        case AUTHERROR
    }
}

public enum BigParserStringResponseError: String, Decodable, Error {
    case userAlreadyExists = "Email Id is already present."
}
