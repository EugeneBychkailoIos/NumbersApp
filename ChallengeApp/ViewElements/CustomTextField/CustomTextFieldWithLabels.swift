//
//  CustomTextFieldWithLabels.swift
//  ChallengeApp
//
//  Created by jekster on 12.12.2022.
//

import UIKit
import SnapKit

protocol DelegateCustomTextFieldWithLabels: AnyObject {
    func textFieldDidEndEditing(_ textField: CustomTextFieldWithLabels)
}

class CustomTextFieldWithLabels: UIView {
    
    // MARK: - Outlets
    private var stackView = UIStackView()
//    private var containerView =  UIView()
    private var titleLabel = UILabel()
    private var textField = CustomTextField()
    private var errorLabel = UILabel()
    
    // MARK: - Nested Types
    
    enum TextFieldState {
        case normal
        case withError(String)
    }
    
    // MARK: - Public properties
    weak var delegate: DelegateCustomTextFieldWithLabels?
    var state: TextFieldState = .normal {
        didSet {
            updateTextFieldState()
        }
    }
    
    // MARK: - Public methods
    
    func setUpField(style: CustomTextField.TextFieldStyle,
                    placeholder: String,
                    title: String,
                    text: String? = nil,
                    errorLbl: String? = nil,
                    isEnabled: Bool? = nil
    ) {
        
        setupUI()
        setupConstraints()
        
        textField.textFieldDelegate = self
        textField.setUp(style: style, placeholder: placeholder)
        textField.text = text
        titleLabel.text = title
        errorLabel.text = errorLbl
        guard let isEnabled = isEnabled else { return }
        textField.isEnabled = isEnabled
        
    }
    
    func getText() -> String {
        guard let text = textField.text else { return ""}
        return text
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        self.addSubview(stackView)
//        stackView.addSubview(containerView)
        stackView.addSubview(titleLabel)
        stackView.addSubview(textField)
        stackView.addSubview(errorLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.black
        errorLabel.textColor = UIColor.red
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(9)
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
//        containerView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(textField.snp.top).offset(-4)
        }
        
        textField.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.bottom.equalTo(errorLabel.snp.top).offset(-4)
            $0.height.equalTo(48)
        }
        
        errorLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func updateTextFieldState() {
        switch state {
        case .normal:
            textField.fieldState = .normal
            errorLabel.text = ""
        case .withError(let text):
            textField.fieldState = .withError
            errorLabel.text = text
        }
    }
}

// MARK: - Extensions

extension CustomTextFieldWithLabels: DelegateCustomTextField {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(self)
    }
}

