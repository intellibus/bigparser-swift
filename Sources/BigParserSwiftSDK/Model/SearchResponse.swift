//
//  File.swift
//  
//
//  Created by Miroslav Kutak on 01/02/2023.
//

import Foundation

struct SearchResponse: Decodable {
    let totalRowCount: Int
    let rows: [[String]]
}
