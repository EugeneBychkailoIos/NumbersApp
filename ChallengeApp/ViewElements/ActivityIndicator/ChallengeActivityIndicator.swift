//
//  ChallengeActivityIndicator.swift
//  ChallengeApp
//
//  Created by jekster on 13.12.2022.
//

import UIKit

class ChallengeActivityIndicatorView: UIView {
    
    // MARK: - Public methods
    
    func startAnimating() {
        splashView.alpha = 1.0
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        splashView.alpha = 0.0
        activityIndicator.stopAnimating()
    }
    
    // MARK: - Private properties
    
    private lazy var splashView: UIView = {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        $0.translatesAutoresizingMaskIntoConstraints = false
        addSubview($0)
        NSLayoutConstraint.activate([
            $0.topAnchor.constraint(equalTo: topAnchor),
            $0.bottomAnchor.constraint(equalTo: bottomAnchor),
            $0.leadingAnchor.constraint(equalTo: leadingAnchor),
            $0.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        return $0
    }(UIView())
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        $0.color = UIColor.yellow.withAlphaComponent(0.6)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.hidesWhenStopped = true
        splashView.addSubview($0)
        NSLayoutConstraint.activate([
            $0.centerXAnchor.constraint(equalTo: splashView.centerXAnchor),
            $0.centerYAnchor.constraint(equalTo: splashView.centerYAnchor)
        ])
        return $0
    }(UIActivityIndicatorView(style: .large))
}
