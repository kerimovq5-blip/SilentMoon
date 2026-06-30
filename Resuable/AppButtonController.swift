//
//  AppButtonController.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 25.06.26.
//

import UIKit

final class AppButton: UIView{
    
    var onTap: (() -> Void)?
    
    private lazy var mainButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = AppStyle.AppFonts.body
        button.layer.cornerRadius = AppStyle.AppRaduis.buttonRadius
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        return button
        //jdhjdsjfklksd;lfkjsd;
    }()
    
    
    init(
        title: String,
        backgroundColor:AssetColors = .accent,
        titleColor: AssetColors = .buttonTitle,
        image : UIImage? = nil,
        font : UIFont? = AppStyle.AppFonts.body,
        ImagePosition : ImagePosition = .leading,
        imageTintColor : UIColor? = nil,
        borderColor: AssetColors? = nil,
        attributed : NSMutableAttributedString? = nil,
        
        
    ) {
        super.init(frame: .zero)
        
        mainButton.setTitle(title, for: .normal)
        mainButton.backgroundColor = UIColor().assetColor(backgroundColor)
        mainButton.setTitleColor(UIColor().assetColor(titleColor), for: .normal)
        if let borderColor = borderColor {
            mainButton.layer.borderColor = UIColor().assetColor(borderColor).cgColor
                    mainButton.layer.borderWidth = 1
                }
        if let image = image {
          
            
            mainButton.setImage(image, for: .normal)
            
            mainButton.tintColor = .systemBlue
            mainButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 70)
            mainButton.titleLabel?.adjustsFontSizeToFitWidth = true
        }
        setupHierarchy()
        setupLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        addSubviews(mainButton)
    }
    
    private func setupLayout() {
        mainButton
            .top(topAnchor).0
            .leading(leadingAnchor).0
            .trailing(trailingAnchor).0
            .bottom(bottomAnchor)
    }
    
    @objc private func buttonTapped() {
        onTap?()
    }
    
    func setTitle(_ title: String) {
        mainButton.setTitle(title, for: .normal)
    }
    func setIsEnabled( _ isEnabled: Bool) {
        mainButton.isEnabled = isEnabled
        mainButton.alpha = isEnabled ? 1.0 : 0.5
    }
}
