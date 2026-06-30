//
//  GetStartedController'.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 25.06.26.
//

import UIKit

final class GetStartedController: UIViewController {
    weak var coordinator: AuthCoordinator?

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
        view.addSubviews(frameImageGroup , getStartedButton)
        
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
