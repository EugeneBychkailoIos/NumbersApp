//
//  ResultCoordinator.swift
//  ChallengeApp
//
//  Created by jekster on 12.12.2022.
//

import UIKit

final class ResultCoordinator: BaseCoordinator<Void> {
    
    // MARK: - Public methods
    
    override func start() {
        let viewModel = ResultViewModel(coordinator: self, date: data)
        let viewController = ResultViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goBack() {
        onComplete?(())
        navigationController.popViewController(animated: true)
    }
    
    // MARK: - Private properties
    
    private unowned let navigationController: UINavigationController
    private var data: [Post]
    
    
    // MARK: - Init
    
    init(navigationController: UINavigationController, data: [Post]) {
        self.navigationController = navigationController
        self.data = data
    }
}

