import UIKit

final class LogInViewController: UIViewController {

    weak var coordinator: AuthCoordinator?
    private var isPasswordVisible = false


    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome Back!"
        label.font = AppStyle.AppFonts.title
        label.textColor = .textPrimary
        label.textAlignment = .center
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
        label.text = "OR LOG IN WITH EMAIL"
        label.font = AppStyle.AppFonts.body
        label.textColor = .textSecondary
        label.textAlignment = .center
        return label
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

    private lazy var logInButton: AppButton = {
        let button = AppButton(
            title: "LOG IN",
            backgroundColor: .accent,
            titleColor: .buttonTitle
        )
        button.onTap = { [weak self] in self?.logInTapped() }
        return button
    }()

    private lazy var forgotLabel: UILabel = {
        let label = UILabel()
        label.text = "Forgot Password?"
        label.font = AppStyle.AppFonts.body
        label.textColor = .textPrimary
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        
        return label
    }()

    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        let attributed = NSMutableAttributedString(
            string: "DON'T HAVE AN ACCOUNT? ",
            attributes: [.foregroundColor: AssetColors.textSecondary.color, .font: AppStyle.AppFonts.body]
        )
        attributed.append(NSAttributedString(
            string: "SIGN UP",
            attributes: [.foregroundColor: AssetColors.accent.color, .font: AppStyle.AppFonts.body]
        ))
        button.setAttributedTitle(attributed, for: .normal)
        button.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
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
            emailTextField,
            passwordTextField,
            logInButton,
            forgotLabel,
            signUpButton
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

        emailTextField
            .top(dividerLabel.bottomAnchor, AppLayout.largeSpacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.textFieldHeight.value)

        passwordTextField
            .top(emailTextField.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.textFieldHeight.value)

        logInButton
            .top(passwordTextField.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.textFieldHeight.value)

        forgotLabel
            .top(logInButton.bottomAnchor, AppLayout.spacing.value).0
            .centerX(view.centerXAnchor)

        signUpButton
            .bottom(view.safeAreaLayoutGuide.bottomAnchor).0
            .centerX(view.centerXAnchor).0
            .height(AppLayout.xLargeSpacing.value)
    }

    private func setupEmailValidation() {
        emailTextField.textField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 30))
        emailCheckButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        container.addSubview(emailCheckButton)
        emailTextField.textField.rightView = container
        emailTextField.textField.rightViewMode = .always
    }


    private func logInTapped() {
        guard isValidEmail(emailTextField.text) else {
            emailTextField.layer.borderColor = AssetColors.errorColor.color.cgColor
            return
        }
        emailTextField.layer.borderColor = UIColor.clear.cgColor
        coordinator?.finishAuth()
    }

    @objc private func signUpTapped() {
        coordinator?.showSignUp()
    }

//    @objc private func forgotPasswordTapped() {
//    }

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

    @objc private func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        passwordTextField.textField.isSecureTextEntry = !isPasswordVisible
        eyeButton.alpha = isPasswordVisible ? 1.0 : 0.5
    }


    private func isValidEmail(_ email: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: email)
    }
}
