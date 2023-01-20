//
//  Console.swift
//  
//
//  Created by Miroslav Kutak on 01/20/2023.
//

import Foundation

class Console {
    static func log(_ anything: Any) {
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
             // Code only executes when tests are running
            print("\(anything)")
        }
    }
}
