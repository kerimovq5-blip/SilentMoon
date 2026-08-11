//
//  UiButtonBuilders.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 11.08.26.
//

import UIKit

final class UiButtonBuilders {
    private let button: UIButton
    
    init(button: UIButton = UIButton(type: .system)) {
        self.button = button
        self.button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setTitle(_ title: String, font: AppFonts = .semiBold, color: AssetColors = .buttonTitle) -> UiButtonBuilders {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = font.font
        button.setTitleColor(color.color, for: .normal)
        return self
    }
    
    func setBackgroundColor(_ color: AssetColors) -> UiButtonBuilders {
        button.backgroundColor = color.color
        return self
    }
    
    func setCornerRadius(_ radius: CGFloat = AppFonts.AppRaduis.buttonRadius) -> UiButtonBuilders {
        button.layer.cornerRadius = radius
        button.clipsToBounds = true
        return self
    }
    
    func setImage(_ image: UIImage?, position: ImagePosition = .leading, spacing: CGFloat = AppLayout.smallSpacing.value) -> UiButtonBuilders {
        button.setImage(image, for: .normal)
        
        if #available(iOS 15.0, *) {
            var configureButton = button.configuration ?? UIButton.Configuration.plain()
            configureButton.image = image
            configureButton.imagePadding = spacing
            configureButton.imagePlacement = (position == .leading) ? .leading : .trailing
            button.configuration = configureButton
        } else {
            if position == .trailing {
                button.semanticContentAttribute = .forceRightToLeft
            } else {
                button.semanticContentAttribute = .forceLeftToRight
            }
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing / 2, bottom: 0, right: spacing / 2)
        }
        return self
    }
    
    func setBorder(color: AssetColors, width: CGFloat = 1.0) -> UiButtonBuilders {
        button.layer.borderColor = color.color.cgColor
        button.layer.borderWidth = width
        return self
    }
    
    func addTarget(target: Any, action: Selector, for event: UIControl.Event = .touchUpInside) -> UiButtonBuilders {
        button.addTarget(target, action: action, for: event)
        return self
    }
    
    func build() -> UIButton {
        return button
    }
}
