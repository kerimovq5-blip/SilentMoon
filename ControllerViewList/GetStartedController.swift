import UIKit

final class GetStartedController: UIViewController {

    weak var coordinator: AuthCoordinator?

    private lazy var meditateLabel: UILabel = {
        let label = UILabel()
        label.text = "Explore the app, Find some peace of mind to prepare for meditation."
        label.font = AppStyle.AppFonts.body
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var frameImageGroup: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "GroupFrame")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var getStartedButton: AppButton = {
        let button = AppButton(
            title: "GET STARTED",
            backgroundColor: .backgroundSecondary,
            titleColor: .textPrimary
        )
        button.onTap = { [weak self] in
            self?.getStartedTapped()
        }
        return button
    }()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
    }

   

    private func setupHierarchy() {
        view.backgroundColor = .colorIndigo
        view.addSubviews(frameImageGroup, meditateLabel, getStartedButton)
    }

    private func setupLayout() {
        frameImageGroup
            .bottom(view.bottomAnchor).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor)

        frameImageGroup.heightAnchor.constraint(
            equalTo: view.heightAnchor,
            multiplier: GetStartedLayout.frameHeightMultiplier
        ).isActive = true

        meditateLabel
            .bottom(frameImageGroup.topAnchor, -GetStartedLayout.labelBottomSpacing).0
            .leading(view.leadingAnchor, GetStartedLayout.labelHorizontalInset).0
            .trailing(view.trailingAnchor, -GetStartedLayout.labelHorizontalInset).0
            .height(GetStartedLayout.labelHeight)

        getStartedButton
            .bottom(view.safeAreaLayoutGuide.bottomAnchor, GetStartedLayout.buttonBottomInset).0
            .leading(view.leadingAnchor, GetStartedLayout.horizontalInset).0
            .trailing(view.trailingAnchor, -GetStartedLayout.horizontalInset).0
            .height(GetStartedLayout.buttonHeight)
    }

   

    private func getStartedTapped() {
        // TODO: coordinator?.showHome()
    }
}
