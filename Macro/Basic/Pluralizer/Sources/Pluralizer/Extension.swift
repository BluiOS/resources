//
//  Extension.swift
//
//
//  Created by HEssam on 5/7/24.
//

import Foundation

public extension Array {
    
    func pluralize(input: String) -> String {
        count.pluralize(input: input)
    }
}

public extension Int {
    
    func pluralize(input: String) -> String {
        if self == 1 {
            return input
        } else {
            // Basic implementation for English language, you may need to extend this for other cases
            if input.hasSuffix("y") {
                let endIndex = input.index(input.endIndex, offsetBy: -1)
                let stem = String(input[..<endIndex])
                return stem + "ies"
            } else {
                return input + "s"
            }
        }
    }
}
