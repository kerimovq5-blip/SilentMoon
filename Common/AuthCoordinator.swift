import UIKit
import SilentMoonManagers

final class AuthCoordinator: Coordinator, ContentNavigating {

    var navigationController: UINavigationController
    var onFlowFinished: (() -> Void)?

    private let apiService: SilentMoonApiService

    init(navigationController: UINavigationController, apiService: SilentMoonApiService) {
        self.navigationController = navigationController
        self.apiService = apiService
    }

    func start() {
        let controller = ViewController()
        controller.coordinator = self
        navigationController.setViewControllers([controller], animated: false)
    }

    func showLogin() {
        let viewModel = LoginViewModel(service: apiService)
        let controller = LogInViewController(viewModel: viewModel)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }

    func showSignUp() {
        let viewModel = SignUpViewModel(service: apiService)
        let controller = SignUpViewController(viewModel: viewModel)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }

    func getStarted(name: String) {
        let controller = GetStartedController()
        controller.userName = name
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }

    func showOtpVerification(email: String, name: String = "") {
        let viewModel = OtpViewModel(apiService: apiService)
        let controller = OtpViewController(viewModel: viewModel)
        controller.email = email
        controller.userName = name
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
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

    func showMusicPage(item: String) {
        let controller = MusicPageController()
        controller.titleLabel = item
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }

    func showMusicPage2(item: String) {
        let controller = MusicSleepPageController()
        controller.titleLabel = item
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }

    func showMusicList() {
        let controller = MusicListViewController()
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }

    func showSearchPage() {
        let controller = SearchPageController(apiService: apiService)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }

    func playOptionPage() {
        let controller = PlayOptionViewController()
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
