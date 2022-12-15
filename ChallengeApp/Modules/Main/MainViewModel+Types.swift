//
//  MainViewModel + Types.swift
//  ChallengeApp
//
//  Created by jekster on 12.12.2022.
//

import Foundation

extension MainViewModel {
    
    struct LoadedState: Equatable {
        let firstNumber: String?
        let secondNumber: String?
        let firstError: String?
        let secondError: String?
        let isButtonEnable: Bool
    }
    
    enum State: Equatable {
        case idle
        case started(LoadedState)
        case loading
        case failure(String?)
    }
}
