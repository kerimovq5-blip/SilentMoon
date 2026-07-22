//
//  MainTabbarController.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 30.06.26.
//

import UIKit

final class MainTabBarCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let tabBarController: UITabBarController

    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }

    func start() {
        tabBarController.viewControllers = [
            makeHomeTab(),
            makeSleepTab(),
            makeMeditateTab(),
            makeMusicTab(),
            makeAccountTab()
        ]
    }

     func makeHomeTab() -> UINavigationController {
        let navigation = UINavigationController(rootViewController: HomeViewController(userName: ""))
        navigation.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(named: "Home")?.withRenderingMode(.alwaysOriginal),
            tag: 0)
        navigation.tabBarItem.badgeColor = .systemRed
        return navigation
    }

     func makeSleepTab() -> UINavigationController {
        let controller = UIViewController()
        controller.view.backgroundColor = .white

        let navigation = UINavigationController(rootViewController: controller)
        navigation.tabBarItem = UITabBarItem(
            title: "Sleep",
            image: UIImage(named: "sleep")?.withRenderingMode(.alwaysOriginal),
            tag: 1
        )
        return navigation
    }

     func makeMeditateTab() -> UINavigationController {
        let navigation = UINavigationController(rootViewController: MeditateViewController())
        navigation.tabBarItem = UITabBarItem(
            title: "Meditate",
            image: UIImage(named: "brain")?.withRenderingMode(.alwaysOriginal),
            tag: 2
        )
        return navigation
    }

     func makeMusicTab() -> UINavigationController {
        let controller = UIViewController()
        controller.view.backgroundColor = .white

        let navigation = UINavigationController(rootViewController: controller)
        navigation.tabBarItem = UITabBarItem(
            title: "Music",
            image: UIImage(named: "music")?.withRenderingMode(.alwaysOriginal),
            tag: 3
        )
        return navigation
    }

     func makeAccountTab() -> UINavigationController {
        let controller = UIViewController()
        controller.view.backgroundColor = .white

        let navigation = UINavigationController(rootViewController: controller)
        navigation.tabBarItem = UITabBarItem(
            title: "Account",
            image: UIImage(named: "user")?.withRenderingMode(.alwaysOriginal),
            tag: 4
        )
        return navigation
    }
}
