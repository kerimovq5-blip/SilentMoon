//
//  MainTabbarController.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 30.06.26.
//


    
    import UIKit

    final class MainTabBarCoordinator: Coordinator {
        var childCoordinators: [Coordinator] = []
        var navigationController: UINavigationController
        var tabBarController: UITabBarController
        var window: UIWindow

        init(tabBarController: UITabBarController, window: UIWindow) {
            self.tabBarController = tabBarController
            self.window = window
            
            self.navigationController = UINavigationController()
        }

        func start() {
            
           let homeNavigation = UINavigationController()
            homeNavigation.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
            let homeViewCotroller = UIViewController()
            homeViewCotroller.view.backgroundColor = .white
            homeNavigation.viewControllers = [homeViewCotroller]
            
            // Tab 2: Meditate
            let meditateNavigation = UINavigationController()
            meditateNavigation.tabBarItem = UITabBarItem(title: "Meditate", image: UIImage(systemName: "brain"), tag: 1)
            let meditateViewController = UIViewController()
            meditateViewController.view.backgroundColor = .lightGray
            meditateNavigation.viewControllers = [meditateViewController]
            
           
            tabBarController.viewControllers = [homeNavigation, meditateNavigation]
            
            
            window.rootViewController = tabBarController
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
   
