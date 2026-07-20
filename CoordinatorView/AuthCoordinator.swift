import UIKit

final class AuthCoordinator: Coordinator {
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
//    func showHome(name : String) {
//        let controller = HomeViewController()
//        controller.coordinator = self
//        controller.userName = name
//        navigationController.pushViewController(controller, animated: true)
//    }
    
    func finishAuth() {
        onFlowFinished?()
    }
}
