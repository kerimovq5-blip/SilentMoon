import UIKit
import SilentMoonManager

final class SignUpViewController: UIViewController {

    weak var coordinator: AuthCoordinator?
    private let viewModel: SignUpViewModel
    private var isPasswordVisible = false
    private var isPrivacyAccepted = false

    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .interactive
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        UIView()
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create your account"
        label.font = AppFonts.title.font
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
        label.font = AppFonts.body.font
        label.textColor = .textSecondary
        label.textAlignment = .center
        return label
    }()

    private lazy var accountTextField: AppTextFieldController = {
        AppTextFieldController(
            placeholder: "Account name",
            backgroundColor: .lightGray
        )
    }()

    private lazy var emailValidation: FieldValidationController = {
        .email(fieldController: emailTextField)
    }()

    private lazy var passwordValidation: FieldValidationController = {
        .minLength(8, fieldController: passwordTextField)
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

    private lazy var privacyCheckbox: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "square")
        imageView.tintColor = AssetColors.textSecondary.color
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkboxTapped))
        imageView.addGestureRecognizer(tapGesture)

        return imageView
    }()

    private lazy var privacyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        
        let text = NSMutableAttributedString(
            string: "I have read the ",
            attributes: [
                .foregroundColor: AssetColors.textSecondary.color,
                .font: AppFonts.body.font
            ]
        )
        text.append(
            NSAttributedString(
                string: "Privacy Policy",
                attributes: [
                    .foregroundColor: AssetColors.accent.color,
                    .font: AppFonts.body.font
                ]
            )
        )
        label.attributedText = text
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(privacyPolicyTapped))
        label.addGestureRecognizer(tapGesture)
        
        return label
    }()

    private lazy var privacyStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [privacyLabel, privacyCheckbox])
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

    private lazy var logInButton: UIButton = {
        let button = UIButton()
        let attributed = NSMutableAttributedString(
            string: "ALREADY HAVE AN ACCOUNT? ",
            attributes: [
                .foregroundColor: AssetColors.textSecondary.color,
                .font: AppFonts.body.font
            ]
        )
        attributed.append(NSAttributedString(
            string: "LOG IN",
            attributes: [
                .foregroundColor: AssetColors.accent.color,
                .font: AppFonts.body.font
            ]
        ))
        button.setAttributedTitle(attributed, for: .normal)
        button.addTarget(self, action: #selector(logInTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        _ = emailValidation
        _ = passwordValidation
        configureKeyboardHandling()
        bindViewModel()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Binding & Render
    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] in
            self?.render()
        }
        viewModel.onRegisterSucceeded = { [weak self] email, name in
            self?.coordinator?.showOtpVerification(email: email, name: name)
        }
    }

    private func render() {
        switch viewModel.state {
        case .idle, .success:
            setLoading(false)
        case .loading:
            setLoading(true)
        case .invalidInput(let message):
            setLoading(false)
            showAlert(message: message)
        case .requestFailed(let appError):
            setLoading(false)
            showAlert(message: appError.errorDescription ?? "Naməlum xəta baş verdi.")
        }
    }

    private func getStartedTapped() {
        emailValidation.markSubmitAttempt()
        passwordValidation.markSubmitAttempt()

        viewModel.name = accountTextField.textField.text ?? ""
        viewModel.email = emailTextField.textField.text ?? ""
        viewModel.password = passwordTextField.textField.text ?? ""
        viewModel.isPrivacyAccepted = isPrivacyAccepted

        viewModel.register()
    }

    @objc private func logInTapped() {
        coordinator?.showLogin()
    }

    @objc private func privacyPolicyTapped() {
        // coordinator?.showPrivacyPolicy()
    }

    @objc private func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        passwordTextField.textField.isSecureTextEntry = !isPasswordVisible
        eyeButton.alpha = isPasswordVisible ? 1.0 : 0.5
    }

    @objc private func checkboxTapped() {
        isPrivacyAccepted.toggle()

        let symbolName = isPrivacyAccepted ? "checkmark.square.fill" : "square"
        privacyCheckbox.image = UIImage(systemName: symbolName)
        privacyCheckbox.tintColor = isPrivacyAccepted
            ? AssetColors.accent.color
            : AssetColors.textSecondary.color
    }

    private func setupHierarchy() {
        view.backgroundColor = .backgroundSecondary
        view.addSubviews(scrollView)
        scrollView.addSubviews(contentView)
        contentView.addSubviews(
            titleLabel,
            facebookButton,
            googleButton,
            dividerLabel,
            accountTextField,
            emailTextField,
            passwordTextField,
            privacyStackView,
            getStartedButton,
            logInButton
        )
    }

    private func setupLayout() {
        scrollView
            .top(view.safeAreaLayoutGuide.topAnchor).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor).0
            .bottom(view.bottomAnchor)

        contentView
            .top(scrollView.topAnchor).0
            .leading(scrollView.leadingAnchor).0
            .trailing(scrollView.trailingAnchor).0
            .bottom(scrollView.bottomAnchor).0
            .width(view.widthAnchor)

        titleLabel
            .top(contentView.topAnchor, AppLayout.spacing.value).0
            .centerX(contentView.centerXAnchor).0
            .height(AppLayout.xLargeSpacing.value)

        facebookButton
            .top(titleLabel.bottomAnchor, AppLayout.xLargeSpacing.value).0
            .leading(contentView.leadingAnchor, AppLayout.spacing.value).0
            .trailing(contentView.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.buttonHeight.value)

        googleButton
            .top(facebookButton.bottomAnchor, AppLayout.spacing.value).0
            .leading(contentView.leadingAnchor, AppLayout.spacing.value).0
            .trailing(contentView.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.buttonHeight.value)

        dividerLabel
            .top(googleButton.bottomAnchor, AppLayout.largeSpacing.value).0
            .centerX(contentView.centerXAnchor).0
            .height(AppLayout.largeSpacing.value)

        accountTextField
            .top(dividerLabel.bottomAnchor, AppLayout.largeSpacing.value).0
            .leading(contentView.leadingAnchor, AppLayout.spacing.value).0
            .trailing(contentView.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.textFieldHeight.value)

        emailTextField
            .top(accountTextField.bottomAnchor, AppLayout.spacing.value).0
            .leading(contentView.leadingAnchor, AppLayout.spacing.value).0
            .trailing(contentView.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.textFieldHeight.value)

        passwordTextField
            .top(emailTextField.bottomAnchor, AppLayout.spacing.value).0
            .leading(contentView.leadingAnchor, AppLayout.spacing.value).0
            .trailing(contentView.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.textFieldHeight.value)

        privacyStackView
            .top(passwordTextField.bottomAnchor, AppLayout.spacing.value).0
            .leading(contentView.leadingAnchor, AppLayout.spacing.value).0
            .trailing(contentView.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.xLargeSpacing.value)

        getStartedButton
            .top(privacyStackView.bottomAnchor, AppLayout.largeSpacing.value).0
            .leading(contentView.leadingAnchor, AppLayout.spacing.value).0
            .trailing(contentView.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.buttonHeight.value)

        logInButton
            .top(getStartedButton.bottomAnchor, AppLayout.spacing.value).0
            .bottom(contentView.bottomAnchor, -AppLayout.bottomInset.value).0
            .centerX(contentView.centerXAnchor).0
            .height(40)
    }

    private func configureKeyboardHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func setLoading(_ isLoading: Bool) {
        getStartedButton.isUserInteractionEnabled = !isLoading
        getStartedButton.alpha = isLoading ? 0.6 : 1.0
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }

        let curve = UIView.AnimationOptions(rawValue: curveRaw << 16)
        let bottomInset = keyboardFrame.height - view.safeAreaInsets.bottom

        UIView.animate(withDuration: duration, delay: 0, options: curve) {
            self.scrollView.contentInset.bottom = bottomInset
            self.scrollView.verticalScrollIndicatorInsets.bottom = bottomInset
        } completion: { _ in
            self.scrollActiveFieldToVisible()
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        guard
            let userInfo = notification.userInfo,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }

        let curve = UIView.AnimationOptions(rawValue: curveRaw << 16)

        UIView.animate(withDuration: duration, delay: 0, options: curve) {
            self.scrollView.contentInset.bottom = 0
            self.scrollView.verticalScrollIndicatorInsets.bottom = 0
        }
    }

    private func scrollActiveFieldToVisible() {
        guard
            let activeField = [accountTextField.textField, emailTextField.textField, passwordTextField.textField]
                .first(where: { $0.isFirstResponder })
        else { return }

        let fieldFrame = activeField.convert(activeField.bounds, to: scrollView)
        scrollView.scrollRectToVisible(fieldFrame.insetBy(dx: 0, dy: -AppLayout.spacing.value), animated: true)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
