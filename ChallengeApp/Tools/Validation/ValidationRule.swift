//
//  ValidationRule.swift
//  ChallengeApp
//
//  Created by jekster on 12.12.2022.
//

import UIKit

protocol ValidationRule {
    
    /// Method that validate string
    /// If error is nil, string is valid
    func validate(_ input: String?) -> Error?
    
    /// Regex to validate input string
    var regex: String { get }
}
