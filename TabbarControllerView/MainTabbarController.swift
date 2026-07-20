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
        homeNavigation.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"), tag: 0)
        
        homeNavigation.tabBarItem.badgeColor = .systemRed
        let homeViewCotroller = UIViewController()
        homeViewCotroller.view.backgroundColor = .white
        homeNavigation.viewControllers = [HomeViewController(userName: "")]
        
        let sleepNavigation = UINavigationController()
        sleepNavigation.tabBarItem = UITabBarItem(title: "Sleep", image: UIImage(named: "sleep"), tag: 1)
        let sleepViewController = UIViewController()
        sleepViewController.view.backgroundColor = .green
        sleepNavigation.viewControllers = [sleepViewController]
        
        
        
        let meditateNavigation = UINavigationController()
        meditateNavigation.tabBarItem = UITabBarItem(title: "Meditate", image: UIImage(named: "brain"), tag: 2)
        let meditateViewController = UIViewController()
        meditateViewController.view.backgroundColor = .lightGray
        meditateNavigation.viewControllers = [MeditateViewController()]
        
        
        
        let musicNavigation = UINavigationController()
        musicNavigation.tabBarItem = UITabBarItem(title: "Music", image: UIImage(named: "music"), tag: 3)
        let musicViewController = UIViewController()
        musicViewController.view.backgroundColor = .yellow
        musicNavigation.viewControllers = [musicViewController]
        
        let accountNavigation = UINavigationController()
        accountNavigation.tabBarItem = UITabBarItem(title: "Account", image: UIImage(named: "user"), tag: 4)
        let accountViewController = UIViewController()
        accountViewController.view.backgroundColor = .red
        accountNavigation.viewControllers = [accountViewController]
        
        tabBarController.viewControllers = [
            homeNavigation,
            sleepNavigation,
            meditateNavigation,
            musicNavigation,
            accountNavigation
        ]
        
        
        window.rootViewController = tabBarController
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
}

