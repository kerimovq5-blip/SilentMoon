import UIKit

final class SignUpViewController: UIViewController {

    weak var coordinator: AuthCoordinator?

    private var isPasswordVisible = false


    private lazy var createLabel: UILabel = {
        let label = UILabel()
        label.text = "Create your account"
        label.font = AppStyle.AppFonts.title.withSize(28)
        label.textColor = .textPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var facebookButton: AppButton = {
        AppButton(
            title: "CONTINUE WITH FACEBOOK",
            backgroundColor: .accent,
            titleColor: .buttonTitle,
            image: UIImage(named: "Vector"),
            imagePosition: .leading
        )
    }()

    private lazy var googleButton: AppButton = {
        AppButton(
            title: "CONTINUE WITH GOOGLE",
            backgroundColor: .backgroundSecondary,
            titleColor: .textPrimary,
            image: UIImage(named: "google"),
            imagePosition: .leading,
            borderColor: .textSecondary
        )
    }()

    private lazy var chooseLabel: UILabel = {
        let label = UILabel()
        label.text = "OR SIGN UP WITH EMAIL"
        label.font = AppStyle.AppFonts.body
        label.textColor = .textSecondary
        label.textAlignment = .center
        return label
    }()

    private lazy var accountTextField: AppTextFieldController = {
        AppTextFieldController(
            placeholder: "Account name",
            backgroundColor: .lightGray,
            
        )
    }()

    private lazy var emailTextField: AppTextFieldController = {
        AppTextFieldController(
            placeholder: "Email address",
            backgroundColor: .lightGray,
           
        )
    }()

    private lazy var eyeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "EyeVector"), for: .normal)
        button.tintColor = AssetColors.textSecondary.color
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        return button
    }()

    private lazy var passwordTextField: AppTextFieldController = {
        AppTextFieldController(
            placeholder: "Password",
            isSecure: true,
            backgroundColor: .lightGray,
            rightView: eyeButton
        )
    }()

    private lazy var privacyCheckbox: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "privacyCheckbox"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        button.tintColor = AssetColors.accent.color
        button.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
        return button
    }()

    private lazy var privacyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        let text = NSMutableAttributedString(
            string: "I have read the ",
            attributes: [
                .foregroundColor: AssetColors.textSecondary.color,
                .font: AppStyle.AppFonts.body
            ]
        )
        text.append(NSAttributedString(
            string: "Privacy Policy",
            attributes: [
                .foregroundColor: AssetColors.accent.color,
                .font: AppStyle.AppFonts.body
            ]
        ))
        label.attributedText = text
        return label
    }()

    private lazy var privacyStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [ privacyLabel , privacyCheckbox])
        stack.axis = .horizontal
        stack.spacing = SignUpLayout.privacyStackSpacing
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()

    private lazy var getStartedButton: AppButton = {
        let button = AppButton(title: "GET STARTED")
        button.onTap = { [weak self] in
            self?.getStartedTapped()
        }
        return button
    }()

   

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
    }

    

    private func setupHierarchy() {
        view.backgroundColor = .backgroundSecondary
        view.addSubviews(
            createLabel,
            facebookButton,
            googleButton,
            chooseLabel,
            accountTextField,
            emailTextField,
            passwordTextField,
            privacyStackView,
            getStartedButton
        )
    }

    private func setupLayout() {
        createLabel
            .top(view.safeAreaLayoutGuide.topAnchor, SignUpLayout.createLabelTopSpacing).0
            .centerX(view.centerXAnchor).0
            .height(SignUpLayout.createLabelHeight)

        facebookButton
            .top(createLabel.bottomAnchor, SignUpLayout.facebookButtonTopSpacing).0
            .leading(view.leadingAnchor, SignUpLayout.horizontalInset).0
            .trailing(view.trailingAnchor, -SignUpLayout.horizontalInset).0
            .height(SignUpLayout.buttonHeight)

        googleButton
            .top(facebookButton.bottomAnchor, SignUpLayout.buttonSpacing).0
            .leading(view.leadingAnchor, SignUpLayout.horizontalInset).0
            .trailing(view.trailingAnchor, -SignUpLayout.horizontalInset).0
            .height(SignUpLayout.buttonHeight)

        chooseLabel
            .top(googleButton.bottomAnchor, SignUpLayout.chooseLabelTopSpacing).0
            .centerX(view.centerXAnchor).0
            .height(SignUpLayout.chooseLabelHeight)

        accountTextField
            .top(chooseLabel.bottomAnchor, SignUpLayout.textFieldTopSpacing).0
            .leading(view.leadingAnchor, SignUpLayout.horizontalInset).0
            .trailing(view.trailingAnchor, -SignUpLayout.horizontalInset).0
            .height(SignUpLayout.textFieldHeight)

        emailTextField
            .top(accountTextField.bottomAnchor, SignUpLayout.textFieldSpacing).0
            .leading(view.leadingAnchor, SignUpLayout.horizontalInset).0
            .trailing(view.trailingAnchor, -SignUpLayout.horizontalInset).0
            .height(SignUpLayout.textFieldHeight)

        passwordTextField
            .top(emailTextField.bottomAnchor, SignUpLayout.textFieldSpacing).0
            .leading(view.leadingAnchor, SignUpLayout.horizontalInset).0
            .trailing(view.trailingAnchor, -SignUpLayout.horizontalInset).0
            .height(SignUpLayout.textFieldHeight)

        privacyStackView
            .top(passwordTextField.bottomAnchor, SignUpLayout.privacyStackTopSpacing).0
            .leading(view.leadingAnchor, SignUpLayout.horizontalInset).0
            .trailing(view.trailingAnchor, -SignUpLayout.horizontalInset).0
            .height(SignUpLayout.privacyStackHeight)

        getStartedButton
            .bottom(view.safeAreaLayoutGuide.bottomAnchor, SignUpLayout.getStartedBottomInset).0
            .leading(view.leadingAnchor, SignUpLayout.horizontalInset).0
            .trailing(view.trailingAnchor, -SignUpLayout.horizontalInset).0
            .height(SignUpLayout.getStartedHeight)
    }

    
    private func getStartedTapped() {
          guard privacyCheckbox.isSelected else {return}
          guard isValidEmail(emailTextField.text) else {
              emailTextField.layer.borderColor = AssetColors.errorColor.color.cgColor
              return
          }
          emailTextField.layer.borderColor = UIColor.clear.cgColor
          coordinator?.getStarted()
      }
   
      @objc private func togglePasswordVisibility() {
          isPasswordVisible.toggle()
          passwordTextField.textField.isSecureTextEntry = !isPasswordVisible
          eyeButton.alpha = isPasswordVisible ? 1.0 : 0.5
      }
   
      @objc private func checkboxTapped() {
          privacyCheckbox.isSelected.toggle()
      }
   
      
   
      private func isValidEmail(_ email: String) -> Bool {
          let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
          return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: email)
      }
  }
