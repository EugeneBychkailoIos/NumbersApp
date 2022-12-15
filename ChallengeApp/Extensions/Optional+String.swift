//
//  Optional+String.swift
//  ChallengeApp
//
//  Created by jekster on 12.12.2022.
//

import Foundation

extension Optional where Wrapped == String {
    var isNilOrEmptyString: Bool {
        return self?.isEmpty ?? true
    }
}
