//
//  ValidateNumbers.swift
//  ChallengeApp
//
//  Created by jekster on 12.12.2022.
//

import Foundation

struct ValidateNumbers: ValidationRule {
    
    // MARK: Public methods
    
    func validate(_ input: String?) -> Error? {
        guard let input = input?.trimmingCharacters(in: .whitespaces) else {
            assertionFailure("input must be not nil")
            return ValidationEmptyError(error: nil)
        }
        guard let regex = try? NSRegularExpression(pattern: regex) else {
            return ValidationErrorInvalidPattern()
        }
        guard regex.matches(input) else {
           return ValidateNumbers.ValidationError()
        }
        return nil
    }
    
    // MARK: Private properties
    
    var regex: String {
        "^[0-9]+$"
    }
    
    // MARK: Nested Types
    
    struct ValidationError: LocalizedError {
        var errorDescription: String? {
            return "Enter the number"
        }
    }
}
