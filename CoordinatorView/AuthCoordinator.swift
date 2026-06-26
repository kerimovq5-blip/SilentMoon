//
//  AuthCoordinator.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 24.06.26.
//

import UIKit
final class AuthCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = ViewController()
        controller.coordinator = self
        navigationController.setViewControllers(
            [controller],
            animated: false
        )
    }
        func showLogin() {
            let controller = LogInViewController()
            controller.coordinator = self
            navigationController.pushViewController(controller, animated: true)
        }
        
        func showSignUp() {
            let controller = SingUpViewController()
            controller.coordinator = self
            navigationController.pushViewController(controller, animated: true)
        }
    func getStarted () {
        let controller = GetStartedController()
        controller.coordinator = self
       navigationController.pushViewController(controller, animated: true)
    }
    }

