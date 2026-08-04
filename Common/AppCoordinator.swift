//
//  AppCoordinator.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 30.06.26.
//

import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let window: UIWindow
    private let navigationController = UINavigationController()

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        if TokenStore.shared.isLoggedIn {
            showMainTabBarFlow()
        } else {
            showAuthFlow()
        }
    }

    private func showAuthFlow() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator.onFlowFinished = {
            [weak self] in
            self?.showMainTabBarFlow()
        }
        childCoordinators = [authCoordinator]
        authCoordinator.start()
    }

    private func showMainTabBarFlow() {
        childCoordinators.removeAll()

        let tabBarController = UITabBarController()
        let tabBarCoordinator = MainTabBarCoordinator(tabBarController: tabBarController)
        tabBarCoordinator.onLogout = { [weak self] in
            self?.logout()
        }
        childCoordinators = [tabBarCoordinator]
        tabBarCoordinator.start()

        setRoot(tabBarController)
    }

    private func logout() {
        TokenStore.shared.clear()
        childCoordinators.removeAll()
        navigationController.setViewControllers([], animated: false)
        setRoot(navigationController)
        showAuthFlow()
    }

    private func setRoot(_ viewController: UIViewController) {
        window.rootViewController = viewController
        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil
        )
    }
}
