//
//  MainViewModel.swift
//  ChallengeApp
//
//  Created by jekster on 12.12.2022.
//

import Foundation

final class MainViewModel {
    
    // MARK: - Public methods
    
    func start() {
        guard case .idle = state else {
            return
        }
//        state = .started
        
        setStartedState()
    }
    
    func inputFirst(_ first: String) {
        inputFirst = first
        setStartedState()
    }
    
    func inputSecond(_ second: String) {
        inputSecond = second
        setStartedState()
    }
    
    func coordinateToResult() {
        DispatchQueue.main.async {
            self.coordinator?.openResultFlow(data: self.data)
        }
    }
    
    func coordinateToBack() {
        coordinator?.goBack()
    }
    
    
    // MARK: - Public properties
    
    @Published private(set) var state: State
    
    // MARK: - Private properties
    
    private weak var coordinator: MainCoordinator?
    
    private let numberFirstValidationRule: [ValidationRule] = [
        ValidateNumbers()
    ]
    
    private let numberSecondValidationRule: [ValidationRule] = [
        ValidateNumbers()
    ]
    
    private var firstError: Error? {
        guard let first = inputFirst else {
            return nil
        }
        return numberFirstValidationRule.compactMap({ $0.validate(first)}).first
    }
    private var secondError: Error? {
        guard let second = inputSecond else {
            return nil
        }
        return numberSecondValidationRule.compactMap({ $0.validate(second)}).first
    }
    
    private var inputFirst: String?
    private var inputSecond: String?
    
    private unowned let apiService: ApiImplementation
    
    var data: [Post] = []
    
    // MARK: - Init
    
    init(coordinator: MainCoordinator, apiService: ApiImplementation) {
        self.coordinator = coordinator
        self.apiService = apiService
        state = .idle
    }
    
    // MARK: - Private methods
    
    func makeRequest() {
        switch state {
        case .loading:
            return
        default:
            break
        }
        guard inputFirst != nil,
              inputSecond != nil
        else {
            return
        }
        state = .loading
        
        guard let inputFirst = inputFirst else { return }
        guard let inputSecond = inputSecond else { return }
        
        guard let inputFirstInt = Int(inputFirst) else { return }
        guard let inputSecondInt = Int(inputSecond) else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
        Task {
            do {
                let posts = try await self.apiService.getPosts(from: inputFirstInt, to: inputSecondInt)
                self.data = posts
                
                debugPrint("POSTS: \(posts)")
                self.coordinateToResult()
            } catch {
                print(error)
                }
            }
        }
    }
    
    func cancelRequest() {
        apiService.isCancelTask = true
    }
    
    private func setStartedState() {
        switch state {
        case .loading:
            return
        default:
            break
        }
        
        let isFirstAvailable = !inputFirst.isNilOrEmptyString
        let isSecondAvailable = !inputSecond.isNilOrEmptyString
        
        let loadedState = LoadedState(
            firstNumber: inputFirst,
            secondNumber: inputSecond,
            firstError: firstError?.localizedDescription,
            secondError: secondError?.localizedDescription,
            isButtonEnable: isFirstAvailable && isSecondAvailable
        )
        state = .started(loadedState)
    }
    
    private func setFailureState(error: String?) {
        state = .failure(error)
    }
}

