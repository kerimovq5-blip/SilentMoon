//
//  GetStartedController'.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 25.06.26.
//

import UIKit

final class GetStartedController: UIViewController {
    
    private lazy var frameImageGroup : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "GroupFrame")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    weak var coordinator: AuthCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(frameImageGroup)
        
        frameImageGroup
            .top(view.topAnchor).0
            .bottom(view.bottomAnchor).0
            .leading(view.leadingAnchor).0
            .trailing(view.trailingAnchor)
    }
}
