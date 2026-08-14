//
//  AuthBuilders.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 11.08.26.
//

import UIKit

enum AuthBuilders {
    static func scrollableForm() -> (scrollView: UIScrollView, contentView: UIView) {
           let scrollView = UIScrollView()
           scrollView.keyboardDismissMode = .interactive
           scrollView.showsVerticalScrollIndicator = false

           let contentView = UIView()

           return (scrollView, contentView)
       }

       static func titleLabel(_ text: String, numberOfLines: Int = 1) -> UILabel {
           let label = UILabel()
           label.text = text
           label.font = AppFonts.title.font
           label.textColor = .textPrimary
           label.textAlignment = .center
           label.numberOfLines = numberOfLines
           return label
       }

       static func facebookButton() -> AppButton {
           AppButton(
               title: "CONTINUE WITH FACEBOOK",
               backgroundColor: .accent,
               titleColor: .buttonTitle,
               image: UIImage(named: "Vector"),
               imagePosition: .leading
           )
       }

       static func googleButton() -> AppButton {
           AppButton(
               title: "CONTINUE WITH GOOGLE",
               backgroundColor: .backgroundSecondary,
               titleColor: .textPrimary,
               image: UIImage(named: "google"),
               imagePosition: .leading,
               borderColor: .textSecondary
           )
       }
    static func saveButton() -> AppButton {
        AppButton(
            title: "SAVE",
            backgroundColor: .accent,
            titleColor: .buttonTitle,
           
        )
    }
    static func continueButton() -> AppButton {
        AppButton(
            title: "CONTINUE",
            backgroundColor: .accent,
            titleColor: .buttonTitle,
            
        )
    }

       static func dividerLabel(_ text: String) -> UILabel {
           let label = UILabel()
           label.text = text
           label.font = AppFonts.body.font
           label.textColor = .textSecondary
           label.textAlignment = .center
           return label
       }
   }
