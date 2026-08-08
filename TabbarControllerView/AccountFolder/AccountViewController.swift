//
//  AccountViewController.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 04.08.26.
//


import UIKit
import SilentMoonManager

final class AccountViewController: UIViewController {

    var onLogoutTapped: (() -> Void)?

    private let apiService: SilentMoonApiService

    init(apiService: SilentMoonApiService) {
        self.apiService = apiService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        Task { [weak self] in
            guard let self else { return }
            _ = await self.apiService.logout()
            self.onLogoutTapped?()
        }
    }
}
