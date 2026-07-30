//
//  OtpViewController.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 30.07.26.
//

import UIKit

final class OtpViewController: UIViewController {

    weak var coordinator: AuthCoordinator?
    var email: String = ""
    var userName: String = ""

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Verify your email"
        label.font = AppFonts.title.font
        label.textColor = .textPrimary
        label.textAlignment = .center
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "\(email) ünvanına göndərilən 6 rəqəmli kodu daxil edin."
        label.font = AppFonts.body.font
        label.textColor = .textSecondary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var otpTextField: AppTextFieldController = {
        let field = AppTextFieldController(
            placeholder: "6 rəqəmli kod",
            backgroundColor: .lightGray
        )
        field.textField.keyboardType = .numberPad
        return field
    }()

    private lazy var verifyButton: AppButton = {
        let button = AppButton(
            title: "TƏSDİQLƏ",
            backgroundColor: .accent,
            titleColor: .buttonTitle
        )
        button.onTap = { [weak self] in self?.verifyTapped() }
        return button
    }()

    private lazy var resendButton: UIButton = {
        let button = UIButton()
        let attributed = NSAttributedString(
            string: "Kodu yenidən göndər",
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
        let otp = otpTextField.text
        guard otp.count == 6 else {
            showAlert(message: "Zəhmət olmasa 6 rəqəmli kodu daxil edin.")
            return
        }

        verifyButton.isUserInteractionEnabled = false
        SilentMoonApiService.shared.verifyEmail(email: email, otp: otp) { [weak self] result in
            guard let self else { return }
            self.verifyButton.isUserInteractionEnabled = true
            switch result {
            case .success:
                self.coordinator?.getStarted(name: self.userName)
            case .failure(let error):
                self.showAlert(message: self.message(for: error))
            }
        }
    }

    @objc private func resendTapped() {
        SilentMoonApiService.shared.resendOtp(email: email) { [weak self] result in
            switch result {
            case .success(let response):
                self?.showAlert(message: response.message)
            case .failure(let error):
                self?.showAlert(message: self?.message(for: error) ?? "Xəta baş verdi")
            }
        }
    }

    private func message(for error: Error) -> String {
        if let apiError = error as? ApiErrorEnvelope {
            return apiError.error.message
        }
        return error.localizedDescription
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
