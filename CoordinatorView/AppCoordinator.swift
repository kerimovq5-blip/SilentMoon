//
//  AppCoordinator.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 30.06.26.
//

import UIKit

final class AppCoordinator: Coordinator {
   

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private var window = UIWindow()
    init(navigationController: UINavigationController , window : UIWindow) {
        self.window = window
        self.navigationController = navigationController
    }
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
                
                showAuthFlow()
    }
    private func showAuthFlow() {
            let authCoordinator = AuthCoordinator(navigationController: navigationController)
            
            authCoordinator.onFlowFinished = { [weak self] in
                self?.removeChild(authCoordinator)
                self?.showMainTabBarFlow()
            }
            
            childCoordinators.append(authCoordinator)
            authCoordinator.start()
        }

        private func showMainTabBarFlow() {
            let tabBarController = UITabBarController()
            let tabBarCoordinator = MainTabBarCoordinator(tabBarController: tabBarController, window: window)
            
            childCoordinators.append(tabBarCoordinator)
            tabBarCoordinator.start()
        }
    private func removeChild(_ coordinator: Coordinator) {
            childCoordinators = childCoordinators.filter { $0 !== coordinator }
        }
    
}

    
