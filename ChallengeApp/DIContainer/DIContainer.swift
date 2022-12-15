//
//  DIContainer.swift
//  ChallengeApp
//
//  Created by jekster on 13.12.2022.
//

import Foundation

final class DIContainer {
    
    let networkService: ApiServiceProtocol = ApiService()
    lazy var apiService: ApiImplementation = ApiImplementation(networkService: self.networkService)
}
