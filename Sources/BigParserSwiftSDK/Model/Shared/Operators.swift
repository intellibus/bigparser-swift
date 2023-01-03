//
//  File.swift
//  
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import Foundation

public enum Operator: String, Codable {
    case LIKE //    Like    STRING
    case NLIKE //    Not Like    STRING
    case EQ //    Equals    STRING, NUMBER, BOOLEAN
    case NEQ //    Not Equals    STRING, NUMBER, BOOLEAN
    case GT //    Greater Than    DATE, DATE_TIME, NUMBER
    case GTE //    Greater Than Equals    DATE, DATE_TIME, NUMBER
    case LT //    Less Than    DATE, DATE_TIME, NUMBER
    case LTE //    Less Than Equals    DATE, DATE_TIME, NUMBER
    case IN //    In query    STRING
    case DISTINCT
}

public enum JoinOperator: String, Codable {
    case AND, OR
}
