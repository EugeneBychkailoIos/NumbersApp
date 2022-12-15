//
//  ValidationEmptyError.swift
//  ChallengeApp
//
//  Created by jekster on 12.12.2022.
//

import Foundation

struct ValidationEmptyError: LocalizedError {
    
    // MARK: - Public properties
    
    var errorDescription: String? {
        return error
    }
    
    // MARK: - Private properties
    
    private let error: String?
    
    // MARK: - Init
    
    init(error: String?) {
        self.error = error
    }
}
