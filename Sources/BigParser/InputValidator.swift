//
//  InputValidator.swift
//  
//
//  Created by Miroslav Kutak on 07/27/2023.
//

import Foundation

final class InputValidator {
    func isGridNameValid(_ gridName: String) -> Bool {
        let gridName = gridName.components(separatedBy: .whitespacesAndNewlines).joined()
        // Empty
        if gridName.isEmpty {
            return false
        }
        // Too long (50 chars)
        if gridName.count > 50 {
            return false
        }

        return true
    }
}
