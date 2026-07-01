import UIKit

final class AuthCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
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
//    func showHome() {
//        let controller = HomeViewController()
//        controller.coordinator = self
//        navigationController.pushViewController(controller, animated: true)
//    }
//    
    func finishAuth() {
        onFlowFinished?()
    }
}
