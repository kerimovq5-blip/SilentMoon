//
//  AccountViewController.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 04.08.26.
//


import UIKit

final class AccountViewController: UIViewController {

    var onLogoutTapped: (() -> Void)?

    private lazy var logoutButton: AppButton = {
        let button = AppButton(
            title: "LOG OUT",
            backgroundColor: .errorColor,
            titleColor: .buttonTitle
        )
        button.onTap = { [weak self] in self?.logoutTapped() }
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundSecondary
        title = "Account"
        view.addSubviews(logoutButton)
        logoutButton
            .bottom(view.safeAreaLayoutGuide.bottomAnchor, -AppLayout.bottomInset.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.buttonHeight.value)
    }

    private func logoutTapped() {
        logoutButton.isUserInteractionEnabled = false
        SilentMoonApiService.shared.logout {
            [weak self] _ in
            self?.onLogoutTapped?()
        }
    }
}
