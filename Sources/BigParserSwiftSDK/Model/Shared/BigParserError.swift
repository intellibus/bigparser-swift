//
//  File.swift
//  
//
//  Created by Miroslav Kutak on 01/02/2023.
//

import Foundation

enum BigParserRequestError: Error {
    case invalidURL
    case emptyResponse
}


struct BigParserErrorResponse: Decodable, Error {
    let errorMessage: String
    let errorType: ErrorType

    // TODO: fill up all the valid types and replace errorType's String type with ErrorType
    enum ErrorType: String, Decodable {
        case SYSTEMERROR
        case DATAERROR
        case AUTHERROR
    }
}
