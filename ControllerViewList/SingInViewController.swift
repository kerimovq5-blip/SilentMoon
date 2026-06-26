//
//  SingInController.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 25.06.26.
//


import UIKit


final class LogInViewController: UIViewController, UITextFieldDelegate {

    
    
    weak var coordinator: AuthCoordinator?
    private var isPasswordVisible: Bool = false
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome Back!"
        label.font = AppStyle.AppFonts.title
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
    private lazy var logInButton : AppButton = {
        let button = AppButton(
            title: "LOG IN",
            backgroundColor: .accent,
            titleColor: .buttonTitle,
            image: nil,
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
    
    private lazy var emailTextField: AppTextFieldController = {
        let textField = AppTextFieldController(
            placeholder :"Email address",
            backgroundColor: .lightGray,
            titleColor : .buttonTitle,
            
            
        )
        return textField
        
       
    }()
    
    private lazy var nailCheckButton : UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return button
    }()
    
    private lazy var eyeVector : UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "EyeVector"), for: .normal)
            button.tintColor = AssetColors.textSecondary.color
            button.addTarget(self, action: #selector(togglePasswordHiden), for: .touchUpInside)
            return button
        }()
    private lazy var passWordTextField: AppTextFieldController = {
        let textField = AppTextFieldController(
            placeholder :"Password",
            isSecure : true ,
            backgroundColor: .lightGray,
            image:  UIImage(named: "EyeVector"),
            rightView: eyeVector
        )
        return textField
    }()
    private lazy var forgotLabel: UILabel = {
        let label = UILabel()
        label.text = "Forgot  Password?"
        label.font = AppStyle.AppFonts.title.withSize(16)
        label.textColor = .textPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(forgotPasswordTapped))
        label.addGestureRecognizer(gesture)
                
                   return label
    }()
    private lazy var singUpButton: UIButton = {
        let button = UIButton()
        let attributed = NSMutableAttributedString(
            string: "ALREADY HAVE AN ACCOUNT? ",
            attributes: [
                .foregroundColor: AssetColors.textSecondary.color,
                .font: AppStyle.AppFonts.body
            ]
        )
        attributed.append(NSAttributedString(
            string: "SING UP",
            attributes: [
                .foregroundColor: AssetColors.accent.color,
                .font: AppStyle.AppFonts.body
            ]
        ))
        button.setAttributedTitle(attributed, for: .normal)
        button
            .addTarget(
                self,
                action: #selector(signUpTapped),
                for: .touchUpInside
            )
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundSecondary
        
        
        view.addSubviews(
            welcomeLabel ,
            facebookButton ,
            googleButton ,
            chooseLabel,
            emailTextField,
            passWordTextField,
            logInButton,
            singUpButton,
            forgotLabel)
        welcomeLabel
            .top(view.safeAreaLayoutGuide.topAnchor , 20 ).0
            .centerX(view.centerXAnchor).0
            .height(40)
        
        facebookButton
            .top(welcomeLabel.bottomAnchor, 40).0
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
        emailTextField
            .top(chooseLabel.bottomAnchor, 30).0
            .leading(view.leadingAnchor, 20).0
            .trailing(view.trailingAnchor, -20).0
            .height(65)
        
        passWordTextField
            .top(emailTextField.bottomAnchor, 20).0
            .leading(view.leadingAnchor, 20).0
            .trailing(view.trailingAnchor, -20).0
            .height(65)
        logInButton
            .top(passWordTextField.bottomAnchor, 20).0
            .leading(view.leadingAnchor, 20).0
            .trailing(view.trailingAnchor, -20).0
            .height(65)
        forgotLabel
            .top(logInButton.bottomAnchor, 20).0
            .centerX(view.centerXAnchor)
        singUpButton
            .bottom(view.safeAreaLayoutGuide.bottomAnchor).0
            .centerX(view.centerXAnchor).0
            .height(40)
        
        nailCheckMark ()
    }
    @objc private func signUpTapped() {
        coordinator?.showSignUp()
    }
    
    @objc private func forgotPasswordTapped () {
        print ("forgot password")
    }
    
    private func isValidRegEmail(_ email : String )-> Bool {
        let emailText  = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailText)
        return emailPredicate.evaluate(with : email)
    }
    
    private func nailCheckMark () {
                
        if let nailCheckMark = emailTextField.subviews.first(where: { $0 is UITextField }) as? UITextField {
            nailCheckMark.addTarget(self, action: #selector(checkMail), for: .editingChanged)
            
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 30))
            nailCheckButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            containerView.addSubview(nailCheckButton)
            
            nailCheckMark.rightView = containerView
            nailCheckMark.rightViewMode = .always
        }
    }
    
    @objc private func checkMail() {
        let emailText = emailTextField.text
        if emailText.isEmpty {
            nailCheckButton.setImage(nil, for: .normal)
            emailTextField.layer.borderColor = AssetColors.lightGray.color.cgColor
            return
        }
        let isValid = isValidRegEmail(emailText)
        emailTextField.isHidden = false
        
        if isValid {

            nailCheckButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            nailCheckButton.tintColor = .systemGreen
            
            emailTextField.layer.borderColor = AssetColors.lightGray.color.cgColor
        } else {
            nailCheckButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            nailCheckButton.tintColor = AssetColors.errorColor.color
            
            emailTextField.layer.borderColor = AssetColors.errorColor.color.cgColor
        }
    }
    
    @objc private func togglePasswordHiden() {
        isPasswordVisible.toggle() 
        if let textField = passWordTextField.subviews.first(where: { $0 is UITextField }) as? UITextField {
            textField.isSecureTextEntry = !isPasswordVisible
        }
        let alphaValue = isPasswordVisible ? 1.0 : 0.5
        eyeVector.alpha = alphaValue
        
    }
}
