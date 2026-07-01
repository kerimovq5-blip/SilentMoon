//
//  GetStartedController'.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 25.06.26.
//

import UIKit

final class GetStartedController: UIViewController {
    weak var coordinator: AuthCoordinator?
    private lazy var meditateLabel: UILabel = {
        let label = UILabel()
        label.text = "Explore the app, Find some peace of mind to prepare for meditation."
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var frameImageGroup : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "GroupFrame")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var getStartedButton: AppButton = {
        let button = AppButton(
            title: "GET STARTED",
            backgroundColor : .backgroundSecondary,
            titleColor: .textPrimary
            
        )
        
        button.onTap = { [weak self] in
            self?.didTapGetStarted()
        }
        return button
    }()
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
       view.backgroundColor = .colorIndigo
        view.addSubviews(meditateLabel , frameImageGroup , getStartedButton)
        
        meditateLabel
            .bottom(frameImageGroup.topAnchor ,-20).0
            .leading(view.leadingAnchor, 30).0
            .trailing(view.trailingAnchor, -30).0
            .height(102)
        frameImageGroup
            .bottom(view.bottomAnchor).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor)
        getStartedButton
            .bottom(view.safeAreaLayoutGuide.bottomAnchor , -30).0
            .leading(view.leadingAnchor , 20).0
            .trailing(view.trailingAnchor, -20).0
            .height(65)
    }
    @objc private func didTapGetStarted() {
      //  coordinator?.showLogin()
    }
    
    
}
