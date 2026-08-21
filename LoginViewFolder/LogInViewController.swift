import UIKit
import SilentMoonDomain
import SilentMoonNetwork

final class LogInViewController: UIViewController {

    weak var coordinator: AuthCoordinator?
    private let viewModel: LoginViewModel
    private var isPasswordVisible = false

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var form = AppBuilders.scrollableForm()
    private var scrollView: UIScrollView { form.scrollView }
    private var contentView: UIView { form.contentView }

    private lazy var googleButton = AuthBuilders.googleButton()
    private lazy var facebookButton = AuthBuilders.facebookButton()
    private lazy var titleLabel = AppBuilders.titleLabel(AppStrings.welcomeLogInTitle.letters)
    private lazy var dividerLabel = AppBuilders.dividerLabel(AppStrings.logInWithEmailDivider.letters)

    private lazy var emailValidation: FieldValidationController = {
        .email(textField: emailTextField.textField)
    }()

    private lazy var passwordValidation: FieldValidationController = {
        .password(textField: passwordTextField.textField)
    }()

    private lazy var emailTextField: AppTextFieldController = {
        AppTextFieldController(
            placeholder: AppStrings.emailAddressPlaceholder.letters,
            backgroundColor: .lightGray
        )
    }()

    private lazy var eyeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: AppStrings.eyeVectorImageName.letters), for: .normal)
        button.tintColor = AssetColors.textSecondary.color
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        return button
    }()

    private lazy var passwordTextField: AppTextFieldController = {
        AppTextFieldController(
            placeholder: AppStrings.passwordPlaceholder.letters,
            isSecure: true,
            backgroundColor: .lightGray,
            rightView: eyeButton
        )
    }()

    private lazy var logInButton: AppButton = {
        let button = AppButton(
            title: AppStrings.logInButtonTitle.letters,
            backgroundColor: .accent,
            titleColor: .buttonTitle
        )
        button.onTap = { [weak self] in self?.logInTapped() }
        return button
    }()

    private lazy var forgotLabel: UILabel = {
        let label = UILabel()
        label.text = AppStrings.forgotPasswordText.letters
        label.font = AppFonts.body.font
        label.textColor = .textPrimary
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(forgotPasswordTapped))
        label.addGestureRecognizer(tapGesture)
        return label
    }()

    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        let attributed = NSMutableAttributedString(
            string: AppStrings.dontHaveAccountText.letters,
            attributes: [
                .foregroundColor: AssetColors.textSecondary.color,
                .font: AppFonts.body.font
            ]
        )
        attributed.append(NSAttributedString(
            string: AppStrings.signUpButton.letters,
            attributes: [
                .foregroundColor: AssetColors.accent.color,
                .font: AppFonts.body.font
            ]
        ))
        button.setAttributedTitle(attributed, for: .normal)
        button.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        return button
    }()

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

    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] in
            DispatchQueue.main.async {
                self?.render()
            }
        }
        
        viewModel.onEmailNotVerified = { [weak self] email in
            DispatchQueue.main.async {
                self?.coordinator?.showOtpVerification(email: email)
            }
        }
    }

    private func render() {
        switch viewModel.state {
        case .idle:
            hideBlurLoading()
        case .loading:
            showBlurLoading()
        case .success:
            hideBlurLoading()
            coordinator?.finishAuth()
        case .invalidInput(let message):
            hideBlurLoading()
            showAlert(message: message)
        case .requestFailed(let appError):
            hideBlurLoading()
            showAlert(message: appError.errorDescription ?? AppStrings.unknownErrorAlert.letters)
        }
    }

    @objc private func logInTapped() {
        emailValidation.markSubmitAttempt()
        passwordValidation.markSubmitAttempt()

        viewModel.email = emailTextField.textField.text ?? ""
        viewModel.password = passwordTextField.textField.text ?? ""

        viewModel.login()
    }

    @objc private func signUpTapped() {
        coordinator?.showSignUp()
    }

    @objc private func forgotPasswordTapped() {
        // coordinator?.showForgotPassword()
    }

    @objc private func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        passwordTextField.textField.isSecureTextEntry = !isPasswordVisible
        eyeButton.alpha = isPasswordVisible ? 1.0 : 0.5
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
            emailTextField,
            passwordTextField,
            logInButton,
            forgotLabel,
            signUpButton
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

        emailTextField
            .top(dividerLabel.bottomAnchor, AppLayout.largeSpacing.value).0
            .leading(contentView.leadingAnchor, AppLayout.spacing.value).0
            .trailing(contentView.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.textFieldHeight.value)

        passwordTextField
            .top(emailTextField.bottomAnchor, AppLayout.spacing.value).0
            .leading(contentView.leadingAnchor, AppLayout.spacing.value).0
            .trailing(contentView.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.textFieldHeight.value)

        logInButton
            .top(passwordTextField.bottomAnchor, AppLayout.spacing.value).0
            .leading(contentView.leadingAnchor, AppLayout.spacing.value).0
            .trailing(contentView.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.buttonHeight.value)

        forgotLabel
            .top(logInButton.bottomAnchor, AppLayout.spacing.value).0
            .centerX(contentView.centerXAnchor)

        signUpButton
            .top(forgotLabel.bottomAnchor, AppLayout.largeSpacing.value).0
            .bottom(contentView.bottomAnchor, -AppLayout.spacing.value).0
            .centerX(contentView.centerXAnchor).0
            .height(AppLayout.xLargeSpacing.value)
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

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AppStrings.okAlertTitle.letters, style: .default))
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
            let activeField = [emailTextField.textField, passwordTextField.textField]
                .first(where: { $0.isFirstResponder })
        else { return }

        let fieldFrame = activeField.convert(activeField.bounds, to: scrollView)
        scrollView.scrollRectToVisible(
            fieldFrame.insetBy(dx: 0, dy: -AppLayout.largeSpacing.value),
            animated: true
        )
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
