//
//  File.swift
//  
//
//  Created by Miroslav Kutak on 01/02/2023.
//

import Foundation

public enum BigParserRequestError: Error, LocalizedError {
    case emptyResponse
    case unknownError
    case unauthorized
    case invalidGridName
}

public extension BigParserRequestError {
    var errorDescription: String? {
        switch self {
        case .emptyResponse:
            return "Empty Response"
        case .unknownError:
            return "Unknown Error"
        case .unauthorized:
            return "Unauthorized"
        case .invalidGridName:
            return "Invalid Grid Name"
        }
    }
}


public struct BigParserErrorResponse: Decodable, Error {
    public let errorMessage: String
    public let errorType: ErrorType

    // TODO: fill up all the valid types and replace errorType's String type with ErrorType
    public enum ErrorType: String, Decodable, CustomStringConvertible {
        case SYSTEMERROR
        case DATAERROR
        case AUTHERROR

        public var description: String {
            switch self {
            case .SYSTEMERROR:
                return "System Error"
            case .DATAERROR:
                return "Data Error"
            case .AUTHERROR:
                return "Auth Error"
            }
        }
    }
}

extension BigParserErrorResponse: LocalizedError {
    public var errorDescription: String? {
        "BigParser \(errorType.description): \(errorMessage)"
    }
}

public enum BigParserStringResponseError: String, Decodable, Error {
    case userAlreadyExists = "Email Id is already present."
}
