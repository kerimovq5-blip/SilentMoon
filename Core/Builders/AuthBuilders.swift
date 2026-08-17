//
//  AuthBuilders.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 11.08.26.
//

import UIKit

enum AuthBuilders {

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
   
   }
