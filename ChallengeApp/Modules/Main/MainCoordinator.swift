//
//  MainCoordinator.swift
//  ChallengeApp
//
//  Created by jekster on 12.12.2022.
//

import UIKit

final class MainCoordinator: BaseCoordinator<Void> {
    
    // MARK: - Public methods
    
    override func start() {
        let viewModel = MainViewModel(coordinator: self, apiService: container.apiService)
        let viewController = MainViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        self.navigationController = navigationController
//        navigationController.isNavigationBarHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func openResultFlow(data: [Post]) {
        let coordinator = ResultCoordinator(navigationController: navigationController, data: data)
        
        coordinator.onComplete = onComplete
        coordinate(to: coordinator)
        
    }
    
    func goBack() {
        onComplete?(())
        navigationController.popViewController(animated: true)
    }
    
    // MARK: - Private properties
    
    private unowned let window: UIWindow?
    private unowned var navigationController: UINavigationController!
    private unowned let container: DIContainer
    
    // MARK: - Init
    
    init(window: UIWindow?, container: DIContainer) {
        self.window = window
        self.container = container
    }
}

