import UIKit

final class GetStartedController: UIViewController {
    
    var coordinator: AuthCoordinator?
    var userName: String = ""
    
    private lazy var logoLabel: UILabel = {
        let label = UILabel()
        
        let silent = NSAttributedString(
            string: "Silent ",
            attributes: [.font: AppFonts.body.font ,
                         .foregroundColor: AssetColors.buttonTitle.color]
        )
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "logo")?
            .withRenderingMode(.alwaysOriginal)
        attachment.bounds = CGRect(x: 0, y: -6, width: 30, height: 30)
        let logo = NSAttributedString(attachment: attachment)
        
        let moon = NSAttributedString(
            string: " Moon",
            attributes: [.font: AppFonts.body.font,
                         .foregroundColor: AssetColors.buttonTitle.color]
        )
        
        let full = NSMutableAttributedString()
        full.append(silent)
        full.append(logo)
        full.append(moon)
        
        label.attributedText = full
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        let attributed = NSMutableAttributedString(
            string: "Explore the app, Find some peace of mind to prepare for meditation.",
            attributes: [
                .foregroundColor: AssetColors.buttonTitle.color,
                .font: AppFonts.body.font
            ]
        )
        
        label.attributedText = attributed
        label.textAlignment = .center
        label.numberOfLines = 2
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
        button.onTap = {
            [weak self] in self?.getStartedTapped()
        }
        return button
    }()
    
    private var logOutButton: UIBarButtonItem {
        
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "door.right.hand.open" ), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
        let barItem = UIBarButtonItem(customView: button)
        return barItem
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = logOutButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        
    }
    
    
    private func makeWelcomeLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        let hi = NSAttributedString(
            string: "Hi \(userName),\n",
            attributes: [
                .font: AppFonts.title.font,
                .foregroundColor: UIColor.white
            ]
        )
        let welcome = NSAttributedString(
            string: "Welcome to Silent Moon",
            attributes: [
                .font: AppFonts.titleRegular.font,
                .foregroundColor: UIColor.white
            ]
        )
        let full = NSMutableAttributedString()
        full.append(hi)
        full.append(welcome)
        label.attributedText = full
        return label
    }
    
    
    private func setupHierarchy() {
        view.backgroundColor = .colorIndigo
        let welcomeLabel = makeWelcomeLabel()
        view
            .addSubviews(
                frameImageGroup,
                logoLabel,
                descriptionLabel,
                welcomeLabel,
                getStartedButton,
                
            )
        
        welcomeLabel
            .bottom(descriptionLabel.topAnchor, -AppLayout.spacing.value).0
            .leading(view.leadingAnchor, AppLayout.largeSpacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.largeSpacing.value).0
            .height(AppLayout.labelHeight.rawValue)
    }
    
    private func setupLayout() {
        
        logoLabel
            .bottom(view.safeAreaLayoutGuide.topAnchor).0
            .centerX(view.centerXAnchor).0
            .height(AppLayout.buttonHeight2.value)
        
        descriptionLabel
            .bottom(frameImageGroup.topAnchor , -AppLayout.largeSpacing.value).0
            .centerX(view.centerXAnchor).0
            .leading(view.leadingAnchor , AppLayout.xLargeSpacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.xLargeSpacing.value)
        
        frameImageGroup
            .bottom(view.bottomAnchor).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor)
        
        frameImageGroup.heightAnchor.constraint(
            equalTo: view.heightAnchor,
            multiplier: 0.55
        ).isActive = true
        
        getStartedButton
            .bottom(view.safeAreaLayoutGuide.bottomAnchor, AppLayout.bottomInset.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.textFieldHeight.value)
        
        
        
    }
    @objc private func logOutTapped() {
        coordinator?.backToMain()
    }
    
    @objc private func getStartedTapped() {
        coordinator?.showTopics()
    }
}
