//
//  WelcomeSleepyiewController.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 26.07.26.
//

import UIKit

final class WelcomeSleepyiewController: UIViewController {
    
    var coordinator: ContentNavigating?
    
    private lazy var frameImageGroup: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BirdsFrame")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var getStartedButton: AppButton = {
        let button = AppButton(
            title: AppStrings.getStartedButton.letters,
            backgroundColor: .colorIndigo,
            titleColor: .buttonTitle
        )
        button.onTap = { [weak self] in
            self?.getStartedSleepyStory()
        }
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
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
            string: AppStrings.welcomeSleepTitle.letters,
            attributes: [
                .font: AppFonts.title.font,
                .foregroundColor: AssetColors.buttonTitle.color
            ]
        )
        let welcome = NSAttributedString(
            string: AppStrings.welcomeSleepSubtitle.letters,
            attributes: [
                .foregroundColor: AssetColors.textSecondary.color,
                .font: AppFonts.body.font
            ]
        )
        let full = NSMutableAttributedString()
        full.append(hi)
        full.append(welcome)
        label.attributedText = full
        return label
    }
    
    private func setupHierarchy() {
        view.backgroundColor = AssetColors.sleepModeColor.color
        let welcomeLabel = makeWelcomeLabel()
        view.addSubviews(
            frameImageGroup,
            welcomeLabel,
            getStartedButton
        )
        
        welcomeLabel
            .top(view.safeAreaLayoutGuide.topAnchor, AppLayout.xLargeSpacing.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value)
    }
    
    private func setupLayout() {
        frameImageGroup
            .top(view.topAnchor).0
            .bottom(view.bottomAnchor).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor)
        
        getStartedButton
            .bottom(view.safeAreaLayoutGuide.bottomAnchor, AppLayout.bottomInset.value).0
            .leading(view.leadingAnchor, AppLayout.spacing.value).0
            .trailing(view.trailingAnchor, -AppLayout.spacing.value).0
            .height(AppLayout.textFieldHeight.value)
    }

    @objc private func getStartedSleepyStory() {
        coordinator?.showSleepyStory()
    }
}
