import UIKit

final class SignUpViewController: UIViewController {

    var coordinator: AuthCoordinator?
    private var isPasswordVisible = false

    private lazy var titleLabel: UILabel = {
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

    private lazy var dividerLabel: UILabel = {
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
            backgroundColor: .lightGray)
        
    }()

    private lazy var emailCheckButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return button
    }()

    private lazy var emailTextField: AppTextFieldController = {
        AppTextFieldController(
            placeholder: "Email address",
            backgroundColor: .lightGray
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
            attributes: [.foregroundColor: AssetColors.textSecondary.color, .font: AppStyle.AppFonts.body]
        )
        text.append(NSAttributedString(
            string: "Privacy Policy",
            attributes: [.foregroundColor: AssetColors.accent.color, .font: AppStyle.AppFonts.body]
        ))
        label.attributedText = text
        return label
    }()

    private lazy var privacyStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [privacyLabel , privacyCheckbox])
        stack.axis = .horizontal
        stack.spacing = AppLayout.xLargeSpacing.value
        stack.alignment = .center
        return stack
    }()

    private lazy var getStartedButton: AppButton = {
        let button = AppButton(title: "GET STARTED")
        button.onTap = { [weak self] in self?.getStartedTapped() }
        return button
    }()

   

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        setupEmailValidation()
    }

   

    private func setupHierarchy() {
        view.backgroundColor = .backgroundSecondary
        view.addSubviews(
            titleLabel,
            facebookButton,
            googleButton,
            dividerLabel,
            accountTextField,
            emailTextField,
            passwordTextField,
            privacyStackView,
            getStartedButton
        )
    }

    private func setupLayout() {
        titleLabel
            .top(view.safeAreaLayoutGuide.topAnchor, AppLayout.spacing.value).0
            .centerX(view.centerXAnchor).0
            .height(AppLayout.xLargeSpacing.value)

        facebookButton
            .top(titleLabel.bottomAnchor, AppLayout.xLargeSpacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.buttonHeight.value)

        googleButton
            .top(facebookButton.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.buttonHeight.value)

        dividerLabel
            .top(googleButton.bottomAnchor, AppLayout.largeSpacing.value).0
            .centerX(view.centerXAnchor).0
            .height(AppLayout.largeSpacing.value)

        accountTextField
            .top(dividerLabel.bottomAnchor, AppLayout.largeSpacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.textFieldHeight.value)

        emailTextField
            .top(accountTextField.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.textFieldHeight.value)

        passwordTextField
            .top(emailTextField.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.textFieldHeight.value)

        privacyStackView
            .top(passwordTextField.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.xLargeSpacing.value)

        getStartedButton
            .bottom(view.safeAreaLayoutGuide.bottomAnchor, AppLayout.bottomInset.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.textFieldHeight.value)
    }

    private func setupEmailValidation() {
        emailTextField.textField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 30))
        emailCheckButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        container.addSubview(emailCheckButton)
        emailTextField.textField.rightView = container
        emailTextField.textField.rightViewMode = .always
    }
    @objc private func emailChanged() {
        let email = emailTextField.text
        guard !email.isEmpty else {
            emailCheckButton.setImage(nil, for: .normal)
            emailTextField.layer.borderColor = AssetColors.lightGray.color.cgColor
            return
        }
        if isValidEmail(email) {
            emailCheckButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            emailCheckButton.tintColor = .systemGreen
            emailTextField.layer.borderColor = AssetColors.lightGray.color.cgColor
        } else {
            emailCheckButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            emailCheckButton.tintColor = AssetColors.errorColor.color
            emailTextField.layer.borderColor = AssetColors.errorColor.color.cgColor
        }
    }
    private func getStartedTapped() {
        guard privacyCheckbox.isSelected else { return }
        guard isValidEmail(emailTextField.text) else {
            emailTextField.layer.borderColor = AssetColors.errorColor.color.cgColor
            return
        }
        emailTextField.layer.borderColor = UIColor.clear.cgColor
        coordinator?.getStarted(name: accountTextField.text)
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
