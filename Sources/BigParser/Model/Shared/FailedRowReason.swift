//
//  File.swift
//  
//
//  Created by Miroslav Kutak on 01/17/2023.
//

import Foundation

public enum FailedRowReason: String, Decodable {
    case invalidRowId = "Invalid rowId"
    case invalidColumns = "Invalid columns"
    case invalidColumnType = "Invalid column type" //?
}
