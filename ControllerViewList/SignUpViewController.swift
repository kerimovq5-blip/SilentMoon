import UIKit

final class SignUpViewController: UIViewController {

    var coordinator: AuthCoordinator?
    private var isPasswordVisible = false
    private var isPrivacyAccepted = false

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

    private lazy var emailValidation: FieldValidationController = {
        .email(fieldController: emailTextField)
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
        let text = NSMutableAttributedString(
            string: "I have read the ",
            attributes: [.foregroundColor: AssetColors.textSecondary.color, .font: AppStyle.AppFonts.body]
        )
        text.append(
NSAttributedString(
            string: "Privacy Policy",
            attributes: [
                .foregroundColor: AssetColors.accent.color,
                .font: AppStyle.AppFonts.body
            ]
        )
)
        label.attributedText = text
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

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        _ = emailValidation
        configureKeyboardHandling()
        let tapgesture = UITapGestureRecognizer(
            target: self, action: #selector(dismissKeyboard))
        tapgesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapgesture)
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
            getStartedButton
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
            .bottom(contentView.bottomAnchor, -AppLayout.bottomInset.value).0
            .leading(contentView.leadingAnchor, AppLayout.spacing.value).0
            .trailing(contentView.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.textFieldHeight.value)
    }

    private func getStartedTapped() {
        guard isPrivacyAccepted else { return }
        emailValidation.markSubmitAttempt()
        guard emailValidation.isValid else { return }
        coordinator?.getStarted(name: accountTextField.text)
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
