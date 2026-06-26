import UIKit

final class ViewController: UIViewController {
    weak var coordinator: AuthCoordinator?
    
    private lazy var silentMoonFrame: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SilentMoonFrame")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var silentMoonView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SilentMoon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var labelView: UILabel = {
        let label = UILabel()
        let attributed = NSMutableAttributedString(
            string: "We are what we do  ",
            attributes: [
                .foregroundColor: AssetColors.textPrimary.color,
                .font: AppStyle.AppFonts.title
            ]
        )
        attributed.append(NSAttributedString(
            string: "\n\nThousands of people are using Silent Moon\nfor smalls meditation",
            attributes: [
                .foregroundColor: AssetColors.textSecondary.color,
                .font: AppStyle.AppFonts.body
            ]
        ))
        label.attributedText = attributed
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var signUpButton: AppButton = {
        let button = AppButton(title: "SIGN UP")
        button.onTap = { [weak self] in
            self?.signUpTapped()
        }
        return button
    }()
    
    private lazy var logInButton: UIButton = {
        let button = UIButton()
        let attributed = NSMutableAttributedString(
            string: "ALREADY HAVE AN ACCOUNT? ",
            attributes: [
                .foregroundColor: AssetColors.textSecondary.color,
                .font: AppStyle.AppFonts.body
            ]
        )
        attributed.append(NSAttributedString(
            string: "LOG IN",
            attributes: [
                .foregroundColor: AssetColors.accent.color,
                .font: AppStyle.AppFonts.body
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
            silentMoonView,
            labelView,
            signUpButton,
            logInButton
        )
    }
    
    private func setupLayout() {
        
        
        silentMoonFrame
            .top(view.topAnchor).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor).0
            .height(view.frame.height * 0.55)
        
        silentMoonView
            .top(silentMoonFrame.topAnchor, 160).0
            .leading(silentMoonFrame.leadingAnchor, 40).0
            .trailing(silentMoonFrame.trailingAnchor, -40).0
            .height(242)
        
        labelView
            .top(silentMoonFrame.bottomAnchor, 20).0
            .leading(view.leadingAnchor, 40).0
            .trailing(view.trailingAnchor, -40).0
            .height(102)
        
        signUpButton
            .top(labelView.bottomAnchor, 40).0
            .leading(view.leadingAnchor, 20).0
            .trailing(view.trailingAnchor, -20).0
            .height(60)
        
        logInButton
            .top(signUpButton.bottomAnchor, 17).0
            .leading(view.leadingAnchor, 20).0
            .trailing(view.trailingAnchor, -20).0
            .height(40)
    }
    
    
    @objc private func signUpTapped() {
        
        coordinator?.showSignUp()
    }
    @objc private func logInTapped() {
        
        coordinator?.showLogin()
    }
}
