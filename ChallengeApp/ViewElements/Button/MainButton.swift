//
//  MainButton.swift
//  ChallengeApp
//
//  Created by jekster on 12.12.2022.
//

import UIKit

class MainButton: UIButton {
    
    // MARK: - Nested Types
    
    enum ButtonStyle {
        case contained
        case outlined
        case empty
        case withImage
        case genderButton
        case emptyRed
    }
    
    // MARK: - Public properties
    
    override var isHighlighted: Bool {
        didSet {
            layer.borderColor = isHighlighted ?
            UIColor.yellow.cgColor :
            UIColor.black.cgColor
        }
    }
    
    // MARK: - Public methods
    
    func setUp(style: ButtonStyle, title: String, image: UIImage? = nil) {
//        NavvarHeadingStyle.apply(to: self)
        switch style {
        case .contained:
            setupContainedStyle()
        case .outlined:
            setupOutlinedStyle()
        case .empty:
            setupEmptyStyle()
        case .withImage:
            setupWithImageStyle(image: image ?? UIImage())
        case .genderButton:
            setupGenderButton()
        case .emptyRed:
            setupEmptyRedButton()
        }
        setTitle(title, for: .normal)
        layer.cornerRadius = frame.height / 2
    }
    
    func canBeEnabled(value: Bool) {
        isEnabled = value
    }
    
    // MARK: - Private methods
    
    private func setupContainedStyle() {
        setBackgroundImage(UIColor.black.image(), for: .normal)
        setBackgroundImage(UIColor.yellow.image(), for: .highlighted)
        layer.masksToBounds = true
        setTitleColor(UIColor.yellow, for: .normal)
        setTitleColor(UIColor.black, for: .highlighted)
    }
    
    private func setupOutlinedStyle() {
        layer.borderWidth = 2
        isHighlighted = false
        setTitleColor(UIColor.blue, for: .normal)
        setTitleColor(UIColor.green, for: .highlighted)
    }
    
    private func setupEmptyStyle() {
        setTitleColor(UIColor.blue, for: .normal)
        setTitleColor(UIColor.green, for: .highlighted)
    }
    
    private func setupWithImageStyle(image: UIImage) {
        setImage(image, for: .normal)
        setImage(image, for: .highlighted)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 11, bottom: 0, right: 0)
        semanticContentAttribute = .forceRightToLeft
        setBackgroundImage(UIColor.blue.image(), for: .normal)
        setBackgroundImage(UIColor.red.image(), for: .highlighted)
        layer.masksToBounds = true
        setTitleColor(UIColor.green, for: .normal)
    }
    
    private func setupGenderButton() {
//        InputTextStyle.apply(to: self)
        setBackgroundImage(UIColor.clear.image(), for: .normal)
        setBackgroundImage(UIColor.blue.image(), for: .selected)
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.blue.cgColor
        let titleColor = isSelected ? UIColor.red : UIColor.blue
        setTitleColor(titleColor, for: .normal)
        if isSelected {
            layer.borderWidth = 0.0
        }
        layer.masksToBounds = true
    }
    
    private func setupEmptyRedButton() {
//        MainTextStyle.apply(to: self)
        backgroundColor = UIColor.white
        setTitleColor(UIColor.red, for: .normal)
    }
}

