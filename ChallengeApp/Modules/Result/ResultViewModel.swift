//
//  ResultViewModel.swift
//  ChallengeApp
//
//  Created by jekster on 12.12.2022.
//

import Foundation

final class ResultViewModel {
    
    // MARK: - Public methods
    
    func start() {
        guard case .idle = state else {
            return
        }
        state = .started
        
    }
    
    func coordinateToBack() {
        coordinator?.goBack()
    }
    
    // MARK: - Public properties
    
    @Published private(set) var state: State
    
    // MARK: - Private properties
    
    private weak var coordinator: ResultCoordinator?
    var date: [Post]
    
    // MARK: - Init
    
    init(coordinator: ResultCoordinator, date: [Post]) {
        self.coordinator = coordinator
        self.date = date
        state = .idle
    }
}

