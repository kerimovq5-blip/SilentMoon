//
//  UiTextFieldBuilder.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 11.08.26.
//

import UIKit

final class UiTextFieldBuilder {
    private let textField: UITextField
    
    init(textField: UITextField = UITextField()) {
        self.textField = textField
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textField.font = AppFonts.body.font
        self.textField.textColor = AssetColors.textPrimary.color
        self.textField.backgroundColor = AssetColors.backgroundSecondary.color
        self.textField.layer.cornerRadius = AppFonts.AppRaduis.buttonRadiusSmall
        self.textField.clipsToBounds = true
    }
    
    func setPlaceholder(_ placeholder: String, color: AssetColors = .textSecondary) -> UiTextFieldBuilder {
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: color.color,
                .font: AppFonts.body.font
            ]
        )
        return self
    }
    
    func isSecure(_ isSecure: Bool) -> UiTextFieldBuilder {
        textField.isSecureTextEntry = isSecure
        return self
    }
    
    func keyboardType(_ keyboardType: UIKeyboardType) -> UiTextFieldBuilder {
        textField.keyboardType = keyboardType
        return self
    }
    
    func backgroundColor(_ color: AssetColors) -> UiTextFieldBuilder {
        textField.backgroundColor = color.color
        return self
    }
    
    func setCornerRadius(_ radius: CGFloat) -> UiTextFieldBuilder {
        textField.layer.cornerRadius = radius
        return self
    }
    
    func setPadding(left: CGFloat = AppLayout.spacing.value, right: CGFloat = AppLayout.spacing.value) -> UiTextFieldBuilder {
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: 1))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
                
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: 1))
        textField.rightView = rightPaddingView
        textField.rightViewMode = .always
        
        return self
    }
    
    func clearButtonMode(_ clearButtonMode: UITextField.ViewMode) -> UiTextFieldBuilder {
        textField.clearButtonMode = clearButtonMode
        return self
    }
    
    func build() -> UITextField {
        return textField
    }
}
