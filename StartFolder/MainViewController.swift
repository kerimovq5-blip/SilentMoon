import UIKit

final class ViewController: UIViewController {
    var coordinator: AuthCoordinator?
    
    private lazy var logoLabel: UILabel = {
        let label = UILabel()
        
        let silent = NSAttributedString(
            string: AppStrings.logoSilent.letters,
            attributes: [.font: AppFonts.body.font]
        )
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: AppStrings.logoImageName.letters)?
            .withRenderingMode(.alwaysOriginal)
        attachment.bounds = CGRect(x: 0, y: -6, width: 30, height: 30)
        let logo = NSAttributedString(attachment: attachment)
        
        let moon = NSAttributedString(
            string: AppStrings.logoMoon.letters,
            attributes: [.font: AppFonts.body.font]
        )
        
        let full = NSMutableAttributedString()
        full.append(silent)
        full.append(logo)
        full.append(moon)
        
        label.attributedText = full
        label.textAlignment = .center
        return label
    }()
    
    private lazy var silentMoonFrame: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: AppStrings.frameImageName.letters)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var silentMoonView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: AppStrings.illustrationImageName.letters)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        let attributed = NSMutableAttributedString(
            string: AppStrings.titleText.letters,
            attributes: [
                .foregroundColor: AssetColors.textPrimary.color,
                .font: AppFonts.title.font
            ]
        )
        attributed.append(NSAttributedString(
            string: AppStrings.subtitleText.letters,
            attributes: [
                .foregroundColor: AssetColors.textSecondary.color,
                .font: AppFonts.body.font
            ]
        ))
        label.attributedText = attributed
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var signUpButton: AppButton = {
        let button = AppButton(title: AppStrings.signUpButton.letters)
        button.onTap = { [weak self] in self?.coordinator?.showSignUp() }
        return button
    }()
    
    private lazy var logInButton: UIButton = {
        let button = UIButton()
        let attributed = NSMutableAttributedString(
            string: AppStrings.alreadyHaveAccount.letters,
            attributes: [
                .foregroundColor: AssetColors.textSecondary.color,
                .font: AppFonts.body.font
            ]
        )
        attributed.append(NSAttributedString(
            string: AppStrings.logInButton.letters,
            attributes: [
                .foregroundColor: AssetColors.accent.color,
                .font: AppFonts.body.font
            ]
        ))
        button.setAttributedTitle(attributed, for: .normal)
        button.addTarget(self, action: #selector(logInTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
    }
    
    private func setupHierarchy() {
        view.backgroundColor = .white
        view.addSubviews(
            silentMoonFrame,
            logoLabel,
            silentMoonView,
            descriptionLabel,
            signUpButton,
            logInButton
        )
    }
    
    private func setupLayout() {
        silentMoonFrame
            .top(view.topAnchor).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor)
        
        silentMoonFrame.heightAnchor.constraint(
            equalTo: view.heightAnchor, multiplier: 0.55
        ).isActive = true
        
        logoLabel
                .bottom(view.safeAreaLayoutGuide.topAnchor).0
                .centerX(view.centerXAnchor).0
                .height(AppLayout.logoHeight.value)
                
            silentMoonView
                .top(silentMoonFrame.topAnchor, AppLayout.silentMoonTopInset.value).0
                .leading(silentMoonFrame.leadingAnchor, AppLayout.xLargeSpacing.value).0
                .trailing(silentMoonFrame.trailingAnchor, -AppLayout.xLargeSpacing.value).0
                .height(AppLayout.illustrationHeight.value)
            
            descriptionLabel
                .top(silentMoonFrame.bottomAnchor, AppLayout.spacing.value).0
                .leading(view.leadingAnchor, AppLayout.xLargeSpacing.value).0
                .trailing(view.trailingAnchor, -AppLayout.xLargeSpacing.value).0
                .height(AppLayout.labelHeight.value)
            
            signUpButton
                .top(descriptionLabel.bottomAnchor, AppLayout.xLargeSpacing.value).0
                .leading(view.leadingAnchor, AppLayout.spacing.value).0
                .trailing(view.trailingAnchor, -AppLayout.spacing.value).0
                .height(AppLayout.buttonHeight.value)
            
            logInButton
                .top(signUpButton.bottomAnchor, AppLayout.spacing.value).0
                .leading(view.leadingAnchor, AppLayout.spacing.value).0
                .trailing(view.trailingAnchor, -AppLayout.spacing.value).0
                .height(AppLayout.secondaryButtonHeight.value)
    }
    
    @objc private func logInTapped() {
        coordinator?.showLogin()
    }
}
