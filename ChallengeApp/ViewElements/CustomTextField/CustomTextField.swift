//
//  CustomTextField.swift
//  ChallengeApp
//
//  Created by jekster on 12.12.2022.
//

import UIKit

protocol DelegateCustomTextField: AnyObject {
    func textFieldDidEndEditing(_ textField: UITextField)
}

class CustomTextField: UITextField {
    
    // MARK: - Nested Types
    
    enum TextFieldStyle {
        case firstField
        case secondField
    }
    
    enum TextFieldState {
        case normal
        case withError
    }
    
    // MARK: - Public properties
    weak var textFieldDelegate: DelegateCustomTextField?
    let inset: CGFloat = 16.0
    var placeHolder: String = ""
    var fieldState: TextFieldState = .normal {
        didSet {
            setState(newState: fieldState)
        }
    }
    
    // MARK: - Private properties
    
    private var style: TextFieldStyle = .firstField
    private var attributedMaskedString: [NSAttributedString.Key: Any] {
        let paragraph = NSMutableParagraphStyle()
        let attributes: [NSAttributedString.Key: Any] = [
                 NSAttributedString.Key.kern: 8,
            NSAttributedString.Key.paragraphStyle: paragraph
             ]
        return attributes
    }
           
    // MARK: - Public methods
        
    func setUp(style: TextFieldStyle, placeholder: String) {
        self.style = style
        switch style {
        case .firstField:
            setupFirstField()
        case .secondField:
            setupSecondField()
        }
        setupCorners()
//        InputTextStyle.apply(to: self)
        tintColor = UIColor.gray
        self.placeholder = placeholder
        delegate = self
        updatePlaceholder()
    }
    
    func setState(newState: TextFieldState) {
        switch newState {
        case .normal:
            setupNormalState()
        case .withError:
            setupErrorState()
        }
    }
        
    func setupErrorState() {
        layer.borderColor = UIColor.red.cgColor
    }
        
    func setupNormalState() {
        if isEditing {
            layer.borderColor = UIColor.yellow.cgColor
        } else {
            layer.borderColor = UIColor.black.cgColor
        }
    }
    
    // placeholder position
    override func textRect(forBounds: CGRect) -> CGRect {
        return CGRect(
            x: inset,
            y: forBounds.origin.y,
            width: forBounds.width - (52.0),
            height: forBounds.size.height
        )
    }

    // text position
    override func editingRect(forBounds: CGRect) -> CGRect {
        return CGRect(
            x: inset,
            y: forBounds.origin.y,
            width: forBounds.width - (52.0 + inset),
            height: forBounds.size.height
        )
    }
    
    // MARK: - Private methods
    
    private func updatePlaceholder() {
        guard let placeholder = self.placeholder else {
            return
        }
        var attributes: [NSAttributedString.Key: Any]
        switch style {
        case .firstField:
            attributes = [
                NSAttributedString.Key.foregroundColor: UIColor.red,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
            ]
        case .secondField:
            attributes = [
                NSAttributedString.Key.foregroundColor: UIColor.red,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
            ]
        }
        attributes[NSAttributedString.Key.foregroundColor] = UIColor.gray
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
    }
        
    private func updateTextStyle() {
        let attributes = isSecureTextEntry ? [
            NSAttributedString.Key.foregroundColor: UIColor.red,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
        ] : [
            NSAttributedString.Key.foregroundColor: UIColor.green,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
        ]
        guard text != nil else {
            return
        }
        guard style == .secondField else {
            return
        }
        defaultTextAttributes.updateValue(
            attributes[NSAttributedString.Key.font]!,
            forKey: NSAttributedString.Key.font
        )
        if isSecureTextEntry {
            defaultTextAttributes.updateValue(8.0, forKey: NSAttributedString.Key.kern)
        } else {
            defaultTextAttributes.removeValue(forKey: NSAttributedString.Key.kern)
        }
        updatePlaceholder()
    }
        
    private func setupCorners() {
        layer.cornerRadius = 20.0
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        clipsToBounds = true
    }
    
    private func setupFirstField() {
        keyboardType = .decimalPad
        rightView = nil
    }
    
    private func setupSecondField() {
        keyboardType = .decimalPad
        rightView = nil
    }
}

// MARK: - Extensions

extension CustomTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        layer.borderColor = UIColor.yellow.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        layer.borderColor = UIColor.black.cgColor
        textFieldDelegate?.textFieldDidEndEditing(textField)
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        updateTextStyle()
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
