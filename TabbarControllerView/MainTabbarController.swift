//
//  MainTabbarController.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 30.06.26.
//

import UIKit
import SilentMoonManager

final class MainTabBarCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let tabBarController: UITabBarController
    var onLogout: (() -> Void)?

    private let apiService: SilentMoonApiService

    init(tabBarController: UITabBarController, apiService: SilentMoonApiService) {
        self.tabBarController = tabBarController
        self.apiService = apiService
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

    private var activeNavigationController: UINavigationController? {
        tabBarController.selectedViewController as? UINavigationController
    }

     func makeHomeTab() -> UINavigationController {
        let homeController = HomeViewController(userName: "")
        homeController.coordinator = self
        let navigation = UINavigationController(rootViewController: homeController)
        navigation.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(named: "Home")?.withRenderingMode(.alwaysOriginal),
            tag: 0)
        navigation.tabBarItem.badgeColor = .systemRed
        return navigation
    }

     func makeSleepTab() -> UINavigationController {
        let sleepController = WelcomeSleepyiewController()
        sleepController.coordinator = self
        let navigation = UINavigationController(rootViewController: sleepController)
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
         let musicController = MusicListViewController()
         musicController.coordinator = self

         let navigation = UINavigationController(
            rootViewController: musicController
         )
        navigation.tabBarItem = UITabBarItem(
            title: "Music",
            image: UIImage(named: "music")?.withRenderingMode(.alwaysOriginal),
            tag: 3
        )
        return navigation
    }

     func makeAccountTab() -> UINavigationController {
        let controller = AccountViewController(apiService: apiService)
        controller.onLogoutTapped = { [weak self] in
            self?.onLogout?()
        }

        let navigation = UINavigationController(rootViewController: controller)
        navigation.tabBarItem = UITabBarItem(
            title: "Account",
            image: UIImage(named: "user")?.withRenderingMode(.alwaysOriginal),
            tag: 4
        )
        return navigation
    }
}

extension MainTabBarCoordinator: ContentNavigating {

    func showMorning() {
        let controller = CoursesDetailViewController()
        controller.coordinator = self
        activeNavigationController?.pushViewController(controller, animated: true)
    }

    func showMusicPage(item titlelabel : String) {
        let controller = MusicPageController()
        controller.titleLabel = titlelabel
        controller.coordinator = self
        activeNavigationController?.pushViewController(controller, animated: true)

    }
    func showMusicPage2(item titlelabel : String) {
        let controller = MusicSleepPageController()
        controller.titleLabel = titlelabel
        controller.coordinator = self
        activeNavigationController?.pushViewController(controller, animated: true)

    }
    func showMusicList() {
        let controller = MusicListViewController()
        controller.coordinator = self
        activeNavigationController?.pushViewController(controller, animated: true)
    }
    func showSearchPage() {
        let controller = SearchPageController(apiService: apiService)
        controller.coordinator = self
        activeNavigationController?.pushViewController(controller, animated: true)
    }
    func dismissMusicPage() {
        activeNavigationController?.popViewController(animated: true)
    }

    func showSleepyStory() {
        let controller = SleepyStoryController()
        controller.coordinator = self
        activeNavigationController?.pushViewController(controller, animated: true)
    }
    func playOptionPage() {
        let controller = PlayOptionViewController()
        controller.coordinator = self
        activeNavigationController?.pushViewController(controller, animated: true)
    }
}
