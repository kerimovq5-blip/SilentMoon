//
//  AppTextFieldController.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 25.06.26.
//

import UIKit
final class AppTextFieldController: UIView {
    var text : String {
        return mainTextField.text ?? ""
    }
   private lazy var mainTextField: UITextField = {
        let textField = UITextField()
       textField.font = AppStyle.AppFonts.body.withSize(20)
       textField.layer.cornerRadius = AppStyle.AppRaduis.buttonRadiusSmall
       textField.clipsToBounds = true
       return textField
    }()
    init(
            placeholder: String,
            isSecure: Bool = false,
            backgroundColor: AssetColors = .textSecondary,
            textColor: AssetColors = .textPrimary,
           // borderColor: AssetColors? = .textSecondary,
            //borderStyle: UITextField.BorderStyle = .line,
            titleColor: AssetColors? = nil,
            isSecureTextField : Bool = false,
            delegate: UITextFieldDelegate? = nil,
            image : UIImage? = nil,
            rightView: UIButton? = nil
        ) {
            super.init(frame: .zero)
            
            
            mainTextField.placeholder = placeholder
            mainTextField.isSecureTextEntry = isSecure
            
           // mainTextField.borderStyle = borderStyle
            
            mainTextField.backgroundColor = UIColor().assetColor(backgroundColor)
            mainTextField.textColor = UIColor()
                .assetColor(textColor)
            let padding = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
            mainTextField.leftView = padding
            mainTextField.leftViewMode = .always

//            if let borderColor = borderColor {
//                mainTextField.layer.borderColor = UIColor().assetColor(borderColor).cgColor
//                mainTextField.layer.borderWidth = 1.0
//            } else {
//                mainTextField.layer.borderWidth = 0.0
//            }
            if let rightButton = rightView {
                let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 30))
                rightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                containerView.addSubview(rightButton)
                mainTextField.rightView = containerView
                mainTextField.rightViewMode = .always
            }
            setupHierarchy()
        setupLayout()
    }
    
        
        override init (frame : CGRect ) {
        super.init( frame : frame)
            setupHierarchy()
            setupLayout()
    }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupHierarchy() {
            addSubviews(mainTextField)
        }
        
        private func setupLayout() {
            
            mainTextField
                .top(topAnchor).0
                .leading(leadingAnchor).0
                .trailing(trailingAnchor).0
                .bottom(bottomAnchor)
            
           
        }
}
