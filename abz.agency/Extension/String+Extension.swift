//
//  String+Extension.swift
//  abz.agency
//
//  Created by Alexander on 11.06.25.
//

import Foundation

extension String {
    func formattedPhoneNumber() -> String {
        let cleaned = self.filter { $0.isNumber || $0 == "+" }
        guard cleaned.hasPrefix("+380"), cleaned.count == 13 else {
            return self
        }

        let countryCode = "+38"
        let operatorCode = cleaned.dropFirst(3).prefix(3)
        let part1 = cleaned.dropFirst(6).prefix(3)
        let part2 = cleaned.dropFirst(9).prefix(2)
        let part3 = cleaned.dropFirst(11)

        return "\(countryCode) (\(operatorCode)) \(part1) \(part2) \(part3)"
    }
    
    func formatPhoneNumber() -> String {
        let digits = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let format = "+XX(XXX) XXX - XX - XX"
        var result = ""
        var digitIndex = digits.startIndex
        
        for char in format {
            if char == "X" {
                if digitIndex < digits.endIndex {
                    result.append(digits[digitIndex])
                    digitIndex = digits.index(after: digitIndex)
                } else {
                    break
                }
            } else {
                if digitIndex < digits.endIndex {
                    result.append(char)
                } else {
                    break
                }
            }
        }
        
        return result
    }
}

