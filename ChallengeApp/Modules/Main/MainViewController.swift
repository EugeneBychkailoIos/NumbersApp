//
//  MainViewController.swift
//  ChallengeApp
//
//  Created by jekster on 12.12.2022.
//


import UIKit
import Combine
import SnapKit

final class MainViewController: BaseViewController<MainViewModel> {
    
    // MARK: - Private properties
    
    private var stateCancellable: Cancellable?
    
    private let containerView = UIView()
    private let mainButton = MainButton()
    private let firstNumberField = CustomTextFieldWithLabels()
    private let secondNumberField = CustomTextFieldWithLabels()
    private let errorContainer = UIView()
    private let errorTitle = UILabel()
    private let activityIndicator = ChallengeActivityIndicatorView()
    private let cancelButton = UIButton()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        setupView()
        setupConstraints()
        buttonActions()
        super.viewDidLoad()
        viewModel.start()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainButton.layer.cornerRadius = mainButton.frame.height/2
        mainButton.layer.masksToBounds = true
        cancelButton.layer.cornerRadius = cancelButton.frame.height/2
        cancelButton.layer.masksToBounds = true
    }
    
    override func observeViewModelState() {
        stateCancellable = viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] state in
                render(state)
            })
    }
    
    // MARK: - Private methods
    
    private func render(_ state: MainViewModel.State) {
        switch state {
        case .idle:
            errorContainer.isHidden = true
            activityIndicator.stopAnimating()
            cancelButton.isHidden = true
        case .loading:
            view.endEditing(true)
            errorContainer.isHidden = true
            activityIndicator.startAnimating()
            cancelButton.isHidden = false
        case let .started(startedState):
            if let firstError = startedState.firstError {
                firstNumberField.state = .withError(firstError)
            } else {
                firstNumberField.state = .normal
            }
            if let secondError = startedState.secondError {
                secondNumberField.state = .withError(secondError)
            } else {
                secondNumberField.state = .normal
            }
            errorContainer.isHidden = true
            activityIndicator.stopAnimating()
            cancelButton.isHidden = true
            mainButton.canBeEnabled(value: startedState.isButtonEnable)
        case let .failure(error):
            errorContainer.isHidden = false
            cancelButton.isHidden = true
            errorTitle.text = error
            activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Actions
    
    @objc func tappedButton() {
            self.viewModel.makeRequest()
    }
    
    @objc func tappedCancelButton() {
        viewModel.cancelRequest()
        viewModel.coordinateToBack()
    }
}

 // MARK: - Extensions

 extension MainViewController: DelegateCustomTextFieldWithLabels {
   
    private func setupView() {
         view.addSubview(containerView)
         containerView.backgroundColor = UIColor.lightGray
         containerView.addSubview(firstNumberField)
         containerView.addSubview(secondNumberField)
         containerView.addSubview(mainButton)
        containerView.addSubview(errorContainer)
        errorContainer.addSubview(errorTitle)
        containerView.addSubview(activityIndicator)
        
        containerView.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.setTitle("cancel", for: .normal)
        cancelButton.setTitle("canceled", for: .highlighted)
        cancelButton.setBackgroundImage(UIColor.white.image(), for: .normal)
        cancelButton.setBackgroundImage(UIColor.red.image(), for: .highlighted)
        cancelButton.layer.zPosition = 500
        
         containerView.translatesAutoresizingMaskIntoConstraints = false
         firstNumberField.translatesAutoresizingMaskIntoConstraints = false
         secondNumberField.translatesAutoresizingMaskIntoConstraints = false
         mainButton.translatesAutoresizingMaskIntoConstraints = false
        
        errorContainer.translatesAutoresizingMaskIntoConstraints = false
        errorTitle.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isUserInteractionEnabled = false
        
         firstNumberField.setUpField(style: .firstField, placeholder: "first number", title: "lower bound")
         secondNumberField.setUpField(style: .secondField, placeholder: "second number", title: "upper bound")
         mainButton.setUp(style: .contained, title: "show posts")
        
        errorContainer.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        errorTitle.textColor = UIColor.white

         firstNumberField.delegate = self
         secondNumberField.delegate = self
    }
    
    private  func setupConstraints() {
         containerView.snp.makeConstraints {
             $0.edges.equalToSuperview()
         }
         
         firstNumberField.snp.makeConstraints {
             $0.leading.equalToSuperview().offset(7)
             $0.trailing.equalToSuperview().offset(-16)
             $0.centerY.equalToSuperview().multipliedBy(0.8)
             $0.height.equalTo(72).priority(500)
         }
         
         secondNumberField.snp.makeConstraints {
             $0.leading.equalToSuperview().offset(7)
             $0.trailing.equalToSuperview().offset(-16)
             $0.top.equalTo(firstNumberField.snp.bottom).offset(16).priority(500)
             $0.top.greaterThanOrEqualTo(firstNumberField).offset(16)
             $0.height.equalTo(72).priority(500)
         }
         
         mainButton.snp.makeConstraints {
             $0.leading.equalToSuperview().offset(16)
             $0.trailing.equalToSuperview().offset(-16)
             $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
             $0.height.equalTo(48)
         }
        
        errorContainer.snp.makeConstraints {
            $0.top.equalTo(secondNumberField.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        errorTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(48)
        }
    }
    
    private func buttonActions() {
        let mainTap = UITapGestureRecognizer(target: self, action: #selector(tappedButton))
        mainButton.addGestureRecognizer(mainTap)
        
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(tappedCancelButton))
        cancelButton.addGestureRecognizer(cancelTap)
    }
     
     
    func textFieldDidEndEditing(_ textField: CustomTextFieldWithLabels) {
        if firstNumberField === textField {
            viewModel.inputFirst(firstNumberField.getText())
        }
        if secondNumberField === textField {
            viewModel.inputSecond(secondNumberField.getText())
        }
        let firstText = firstNumberField.getText()
        viewModel.inputFirst(firstText)
        let secondText = secondNumberField.getText()
        viewModel.inputSecond(secondText)
    }
}

//extension MainViewController: IndicatorViewDelegate {
//    func tappedCancel(_ sender: UIButton) {
//        viewModel.cancelRequest()
//    }
//}
