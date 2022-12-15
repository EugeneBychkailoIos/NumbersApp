//
//  BaseCoordinator.swift
//  ChallengeApp
//
//  Created by jekster on 12.12.2022.
//

import Foundation

public typealias Block<T> = (T) -> Void

/// Base class. Contains basic methods and mechanisms for implementing the concept `parent -> child`
open class BaseCoordinator<ResultType> {

    // MARK: - Public properties
    
    /// With the given callback-a
    public var onComplete: Block<ResultType>?

    // MARK: - Private properties
    
    /// Unique identifier of the coordinator
    private let identifier = UUID()
    
    /// Coordinators form a tree structure
    private var childCoordinators: [UUID: Any] = [:]
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Public methods

    /// - Parameter coordinator: Starting Coordinator
    open func coordinate<T>(to coordinator: BaseCoordinator<T>) {
        store(coordinator: coordinator)
        let completion = coordinator.onComplete
        coordinator.onComplete = { [weak self, weak coordinator] value in
            completion?(value)
            if let coordinator = coordinator {
                self?.free(coordinator: coordinator)
            }
        }
        coordinator.start()
    }

    /// Abstract method. Launches the `Flow` coordinator.
    open func start() {
        fatalError("❌")
    }
    
    // MARK: - Private methods
    
    private func store<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    private func free<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators.removeValue(forKey: coordinator.identifier)
    }
}
