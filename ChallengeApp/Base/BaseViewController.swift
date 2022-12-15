//
//  BaseViewController.swift
//  ChallengeApp
//
//  Created by jekster on 12.12.2022.
//

import UIKit
import IQKeyboardManagerSwift

class BaseViewController<ViewModel>: UIViewController {
    
    // MARK: - Public properties
    
    var viewModel: ViewModel
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // MARK: - Public methods
    
    func observeViewModelState() {}
    
    // MARK: - Init
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeViewModelState()
        observeTapAround()
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    // MARK: - Private Methods
    
    private func observeTapAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
