//
//  ApplicationCoordinator.swift
//  ChallengeApp
//
//  Created by jekster on 12.12.2022.
//

import UIKit
import Combine

final class ApplicationCoordinator: BaseCoordinator<Void> {
    
    // MARK: - Public methods
    
    override func start() {
        let coordinator = MainCoordinator(window: window, container: container)
        coordinator.onComplete = { [unowned self] _ in
            start()
//            openMainFlow()
        }
        coordinate(to: coordinator)
    }
    
    func openMainFlow() {
        guard let navigationController = window?.rootViewController as? UINavigationController else {
            return
        }
        navigationController.popToRootViewController(animated: true)
    }
    
    // MARK: - Private properties
    
    private unowned let window: UIWindow?
    private let container = DIContainer()
    
    // MARK: - Init
    
    init(window: UIWindow?) {
        self.window = window
        super.init()
    }
}

