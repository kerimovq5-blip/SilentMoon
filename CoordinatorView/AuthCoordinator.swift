import UIKit

final class AuthCoordinator: Coordinator, ContentNavigating {

    var navigationController: UINavigationController
    var onFlowFinished: (() -> Void)?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = ViewController()
        controller.coordinator = self
        navigationController.setViewControllers([controller], animated: false)
    }
    
    func showLogin() {
        let controller = LogInViewController()
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func showSignUp() {
        let controller = SignUpViewController()
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func getStarted(name : String) {
        let controller = GetStartedController()
        controller.userName = name
        controller.coordinator = self
        navigationController.pushViewController(controller , animated: true)
    }
    func showTopics() {
        let controller = ChooseTopicViewController()
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func showReminder() {
        let controller = ReminderViewController()
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func showMorning() {
        let controller = CoursesDetailViewController()
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }

    
    func backToMain() {
        navigationController.popToRootViewController(animated: true)
    }

    func finishAuth() {
        onFlowFinished?()
    }
    func showMusicPage(item : String) {
        let controller = MusicPageController()
        controller.titleLabel = item
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    func showMusicPage2(item : String) {
        let controller = MusicSleepPageController()
        controller.titleLabel = item
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    func dismissMusicPage() {
        navigationController.popViewController(animated: true)
    }
func showSleepyStory() {
        let controller = SleepyStoryController()
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
}
