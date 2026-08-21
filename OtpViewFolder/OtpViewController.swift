//
//  OtpViewController.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 30.07.26.
//

import UIKit

final class OtpViewController: UIViewController {

    weak var coordinator: AuthCoordinator?
    private let viewModel: OtpViewModel

    var email: String {
        get { viewModel.email }
        set { viewModel.email = newValue }
    }
    var userName: String {
        get { viewModel.userName }
        set { viewModel.userName = newValue }
    }

    init(viewModel: OtpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = AppStrings.verifyEmailTitle.letters
        label.font = AppFonts.title.font
        label.textColor = .textPrimary
        label.textAlignment = .center
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = String(format: AppStrings.otpSubtitleFormat.letters, email)
        label.font = AppFonts.body.font
        label.textColor = .textSecondary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var otpTextField: AppTextFieldController = {
        let field = AppTextFieldController(
            placeholder: AppStrings.otpPlaceholder.letters,
            backgroundColor: .lightGray
        )
        field.textField.keyboardType = .numberPad
        return field
    }()

    private lazy var verifyButton: AppButton = {
        let button = AppButton(
            title: AppStrings.verifyButtonTitle.letters,
            backgroundColor: .accent,
            titleColor: .buttonTitle
        )
        button.onTap = { [weak self] in self?.verifyTapped() }
        return button
    }()

    private lazy var resendButton: UIButton = {
        let button = UIButton()
        let attributed = NSAttributedString(
            string: AppStrings.resendCodeButtonTitle.letters,
            attributes: [
                .foregroundColor: AssetColors.accent.color,
                .font: AppFonts.body.font
            ]
        )
        button.setAttributedTitle(attributed, for: .normal)
        button.addTarget(self, action: #selector(resendTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundSecondary
        setupHierarchy()
        setupLayout()
        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] in
            DispatchQueue.main.async {
                self?.render()
            }
        }
        viewModel.onVerifySucceeded = { [weak self] userName in
            DispatchQueue.main.async {
                self?.coordinator?.getStarted(name: userName)
            }
        }
    }

    private func render() {
        switch viewModel.state {
        case .idle, .verifySucceeded:
            verifyButton.isUserInteractionEnabled = true
        case .verifying:
            verifyButton.isUserInteractionEnabled = false
        case .invalidInput(let message):
            verifyButton.isUserInteractionEnabled = true
            showAlert(message: message)
        case .verifyFailed(let appError):
            verifyButton.isUserInteractionEnabled = true
            showAlert(message: appError.errorDescription ?? AppStrings.unknownErrorAlert.letters)
        case .resending:
            resendButton.isUserInteractionEnabled = false
        case .resendSucceeded(let message):
            resendButton.isUserInteractionEnabled = true
            showAlert(message: message)
        case .resendFailed(let appError):
            resendButton.isUserInteractionEnabled = true
            showAlert(message: appError.errorDescription ?? AppStrings.unknownErrorAlert.letters)
        }
    }

    private func setupHierarchy() {
        view.addSubviews(titleLabel, subtitleLabel, otpTextField, verifyButton, resendButton)
    }

    private func setupLayout() {
        titleLabel
            .top(view.safeAreaLayoutGuide.topAnchor, AppLayout.xLargeSpacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value)

        subtitleLabel
            .top(titleLabel.bottomAnchor, AppLayout.smallSpacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value)

        otpTextField
            .top(subtitleLabel.bottomAnchor, AppLayout.largeSpacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.textFieldHeight.value)

        verifyButton
            .top(otpTextField.bottomAnchor, AppLayout.spacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.buttonHeight.value)

        resendButton
            .top(verifyButton.bottomAnchor, AppLayout.spacing.value).0
            .centerX(view.centerXAnchor)
    }

    private func verifyTapped() {
        viewModel.otp = otpTextField.textField.text ?? ""
        viewModel.verify()
    }

    @objc private func resendTapped() {
        viewModel.resendOtp()
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AppStrings.okAlertTitle.letters, style: .default))
        present(alert, animated: true)
    }
}
