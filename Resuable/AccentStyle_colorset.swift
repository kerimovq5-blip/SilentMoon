//
//  AppColor.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 25.06.26.
//

//



import UIKit

enum ImagePosition {
    case leading
    case trailing
}

enum AssetColors : String{
    
    case background = "Background"
    case backgroundSecondary = "BackgroundSecondary"
    case textPrimary = "TextPrimary"
    case textSecondary = "TextSecondary"
    case accent = "Accent"
    case buttonTitle = "ButtonTitle"
    case lightGray = "Lightgray"
    case errorColor = "ErrorColor"
    case wrongColor = "WrongColor"
    case colorIndigo = "colorIndigo"
    case datepicker = " datePicker"
    case dailyColor = "dailycolor"
    case sectionColor = "SectionColor"
    case ellipsesColor = "ellipsesColor"
    case sleepModeColor = "SleepModeColor"
    case darksleepmusic = "darksleepmusic"
    
    var color : UIColor {
        return UIColor(named: self.rawValue) ?? .clear
        
    }
    
}

extension UIColor  {
    func assetColor( _ colorName : AssetColors) -> UIColor {
        return colorName.color
    }
    
}

enum AppFonts {
    case title
    case titleBold
    case titleRegular
    case body
    case litletitle
    case semiBold
    var font: UIFont {
        switch self {
        case .title:
            return UIFont.systemFont(ofSize: 30, weight: .bold)
        case .titleBold:
            return UIFont.systemFont(ofSize: 24, weight: .bold)
        case .titleRegular:
            return UIFont.systemFont(ofSize: 28, weight: .regular)
        case .body:
            return UIFont.systemFont(ofSize: 16, weight: .regular)
        case .litletitle:
            return UIFont.systemFont(ofSize: 12, weight: .regular)
        case .semiBold:
            return UIFont.systemFont(ofSize: 18, weight: .semibold)
        }
    }

    enum AppRaduis {
        static let buttonRadius: CGFloat = 30
        static let buttonRadiusSmall: CGFloat = 15
        static let buttonRadiusMedium: CGFloat = 20
        static let buttonRadiusLarge: CGFloat = 25
    }

}

