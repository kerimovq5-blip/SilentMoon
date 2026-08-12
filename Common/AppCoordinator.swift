//
//  AppCoordinator.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 30.06.26.
//

import UIKit
import SilentMoonNetworkCommon
import SilentMoonManagers

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let window: UIWindow
    private let navigationController = UINavigationController()
    private let tokenStore: TokenStore
    private let apiService: SilentMoonApiService
    private let diContainer: AppDiContainer
    
    init(window: UIWindow, tokenStore: TokenStore, apiService: SilentMoonApiService, diContainer: AppDiContainer) {
        self.window = window
        self.tokenStore = tokenStore
        self.apiService = apiService
        self.diContainer = diContainer
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        if tokenStore.isLoggedIn {
            showMainTabBarFlow()
        } else {
            showAuthFlow()
        }
    }

    private func showAuthFlow() {
        let authCoordinator = AuthCoordinator(
            navigationController: navigationController,
            apiService: apiService
        )
        authCoordinator.onFlowFinished = { [weak self] in
            self?.showMainTabBarFlow()
        }
        childCoordinators = [authCoordinator]
        authCoordinator.start()
    }

    private func showMainTabBarFlow() {
        childCoordinators.removeAll()

        let tabBarController = UITabBarController()
        let tabBarCoordinator = MainTabBarCoordinator(
            tabBarController: tabBarController,
            apiService: apiService
        )
        tabBarCoordinator.onLogout = { [weak self] in
            self?.logout()
        }
        childCoordinators = [tabBarCoordinator]
        tabBarCoordinator.start()

        setRoot(tabBarController)
    }

    private func logout() {
        tokenStore.clear()
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
