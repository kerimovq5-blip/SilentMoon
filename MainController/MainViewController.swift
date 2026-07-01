import UIKit

final class ViewController: UIViewController {
    weak var coordinator: AuthCoordinator?
    private lazy var SilentMoonlogoLabel: UILabel = {
        let label = UILabel()

        let silent = NSAttributedString(
            string: "silent ",
            attributes: [.font: AppStyle.AppFonts.title]
        )

        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "SilentMoonLogo")
        attachment.bounds = CGRect(x: 0, y: -6, width: 30, height: 30)
        let logo = NSAttributedString(attachment: attachment)

        let moon = NSAttributedString(
            string: " moon",
            attributes: [.font: AppStyle.AppFonts.title]
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
        imageView.image = UIImage(named: "SilentMoonFrame")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
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
            string: "\n\nThousands of people are using Silent Moon\nfor daily meditation",
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
            self?.coordinator?.showSignUp()
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
            SilentMoonlogoLabel,
            silentMoonFrame,
            silentMoonView,
            labelView,
            signUpButton,
            logInButton
        )
    }

    private func setupLayout() {
        SilentMoonlogoLabel
            .top(view.safeAreaLayoutGuide.topAnchor).0
            .centerX(view.centerXAnchor).0
            .height(50)
        

        silentMoonFrame
            .top(view.topAnchor).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor)

        silentMoonFrame.heightAnchor.constraint(
            equalTo: view.heightAnchor,
            multiplier: WelcomeLayout.frameHeightMultiplier
        ).isActive = true

        silentMoonView
            .top(silentMoonFrame.topAnchor, WelcomeLayout.silentMoonTopInset).0
            .leading(silentMoonFrame.leadingAnchor, WelcomeLayout.silentMoonHorizontalInset).0
            .trailing(silentMoonFrame.trailingAnchor, -WelcomeLayout.silentMoonHorizontalInset).0
            .height(WelcomeLayout.silentMoonHeight)

        labelView
            .top(silentMoonFrame.bottomAnchor, WelcomeLayout.labelTopSpacing).0
            .leading(view.leadingAnchor, WelcomeLayout.labelHorizontalInset).0
            .trailing(view.trailingAnchor, -WelcomeLayout.labelHorizontalInset).0
            .height(WelcomeLayout.labelHeight)

        signUpButton
            .top(labelView.bottomAnchor, WelcomeLayout.signUpTopSpacing).0
            .leading(view.leadingAnchor, WelcomeLayout.horizontalInset).0
            .trailing(view.trailingAnchor, -WelcomeLayout.horizontalInset).0
            .height(WelcomeLayout.signUpHeight)

        logInButton
            .top(signUpButton.bottomAnchor, WelcomeLayout.logInTopSpacing).0
            .leading(view.leadingAnchor, WelcomeLayout.horizontalInset).0
            .trailing(view.trailingAnchor, -WelcomeLayout.horizontalInset).0
            .height(WelcomeLayout.logInHeight)
    }

    @objc private func logInTapped() {
        coordinator?.showLogin()
    }
}
