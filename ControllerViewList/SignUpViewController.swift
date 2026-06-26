//
//  SignUpViewController.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 25.06.26.
//


import UIKit

final class SingUpViewController : UIViewController {
    
   private var isPasswordVisible: Bool = false
   weak var coordinator: AuthCoordinator?
    
    private lazy var createLabel: UILabel = {
        let label = UILabel()
        label.text = "Create your account "
        label.font = AppStyle.AppFonts.title.withSize(28)
        label.textColor = .textPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private lazy var facebookButton: AppButton = {
        
        let button = AppButton(
            title: "CONTINUE WITH FACEBOOK",
            backgroundColor: .accent,
            titleColor: .buttonTitle,
            image: UIImage(named: "Vector"),
            ImagePosition: .leading
            
        )
        
        return button
    }()
    
    private lazy var googleButton: AppButton = {
        
        let button = AppButton(
            
            title: "CONTINUE WITH GOOGLE",
            backgroundColor: .backgroundSecondary,
            titleColor: .textPrimary,
            image: UIImage(named: "google"),
            ImagePosition: .leading,
            borderColor: .textSecondary
        )
        return button
    }()
    private lazy var chooseLabel: UILabel = {
        let label = UILabel()
        label.text = "OR LOG IN WITH EMAIL"
        label.font = AppStyle.AppFonts.title.withSize(16)
        label.textColor = .textSecondary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private lazy var accountTextField : AppTextFieldController = {
        let textField = AppTextFieldController(
            placeholder :"Account name",
            backgroundColor: .lightGray,
            titleColor : .buttonTitle,
        )
        return textField
    }()
    private lazy var emailTextField: AppTextFieldController = {
        let textField = AppTextFieldController(
            placeholder :"Email address",
            backgroundColor: .lightGray,
            titleColor : .buttonTitle,
            
            
        )
        return textField
    }()
    
    private lazy var eyeVector : UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "EyeVector"), for: .normal)
            button.tintColor = AssetColors.textSecondary.color
            button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
            return button
        }()
    
    private lazy var passWordTextField: AppTextFieldController = {
        let textField = AppTextFieldController(
            placeholder :"Password",
            isSecure : true,
            backgroundColor: .lightGray,
            image:  UIImage(named: "EyeVector"),
            rightView: eyeVector
        )
        return textField
    }()
   
    private lazy var getStartedButton: AppButton = {
        let button = AppButton(title: "SIGN UP")
        button.onTap = { [weak self] in
            self?.didTapGetStarted()
        }
        return button
    }()
    
   
    
    override func viewDidLoad() {
       
        view.backgroundColor = .backgroundSecondary
        super.viewDidLoad()
        view.addSubviews(
            createLabel ,
            facebookButton ,
            googleButton,
            chooseLabel,
            accountTextField,
            emailTextField,
            passWordTextField,
            getStartedButton
        )
        createLabel
            .top(view.safeAreaLayoutGuide.topAnchor , 20 ).0
            .centerX(view.centerXAnchor).0
            .height(40)
        
        facebookButton
            .top(createLabel.bottomAnchor, 40).0
            .leading(view.leadingAnchor, 20).0
            .trailing(view.trailingAnchor, -20).0
            .height(60)
        googleButton
            .top(facebookButton.bottomAnchor, 20).0
            .leading(view.leadingAnchor, 20).0
            .trailing(view.trailingAnchor, -20).0
            .height(60)
        chooseLabel
            .top(googleButton.bottomAnchor , 30).0
            .centerX(view.centerXAnchor).0
            .height(30)
        accountTextField
            .top(chooseLabel.bottomAnchor, 30).0
            .leading(view.leadingAnchor, 20).0
            .trailing(view.trailingAnchor, -20).0
            .height(65)
        emailTextField
            .top(accountTextField.bottomAnchor, 20).0
            .leading(view.leadingAnchor, 20).0
            .trailing(view.trailingAnchor, -20).0
            .height(65)
        passWordTextField
            .top(emailTextField.bottomAnchor, 20).0
            .leading(view.leadingAnchor, 20).0
            .trailing(view.trailingAnchor, -20).0
            .height(65)
        getStartedButton
            .bottom(view.safeAreaLayoutGuide.bottomAnchor , -30).0
            .leading(view.leadingAnchor , 20).0
            .trailing(view.trailingAnchor, -20).0
            .height(65)
    }
    @objc private func didTapGetStarted() {
        coordinator?.getStarted()
    }
    private func isValidRegEmail(_ email : String )-> Bool {
        let emailText  = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailText)
        return emailPredicate.evaluate(with : email)
    }
    @objc private func checkMail() {
        let emailText = emailTextField.text
        
        let isValid = isValidRegEmail(emailText)
        if isValid {
            emailTextField.isHidden = true
            emailTextField.layer.borderColor = AssetColors.wrongColor.color.cgColor
        }else {
            emailTextField.isHidden = false
            emailTextField.layer.borderColor  = AssetColors.errorColor.color.cgColor
        }
    }
    
    @objc private func togglePasswordVisibility () {
        isPasswordVisible.toggle()
        if let textField = passWordTextField.subviews.first(where: { $0 is UITextField }) as? UITextField {
            textField.isSecureTextEntry = !isPasswordVisible
        }
        
        let alphaValue = isPasswordVisible ? 1.0 : 0.5
        eyeVector.alpha = alphaValue
    }
}
