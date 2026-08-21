//
//  AppStrings.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 21.08.26.
//

import UIKit

enum AppStrings : String {
    case logoSilent = "Silent "
    case logoMoon = " Moon"
    case logoImageName = "logo"
    case frameImageName = "SilentMoonFrame"
    case illustrationImageName = "SilentMoon"
            
    case titleText = "We are what we do"
    case subtitleText = "\n\nThousands of people are using Silent Moon\nfor daily meditation"
            
    case signUpButton = "SIGN UP"
    case alreadyHaveAccount = "ALREADY HAVE AN ACCOUNT? "
    case logInButton = "LOG IN"
    
    case createAccountTitle = "Create your account"
    case signUpWithEmailDivider = "OR SIGN UP WITH EMAIL"
    case accountNamePlaceholder = "Account name"
    case emailAddressPlaceholder = "Email address"
    case passwordPlaceholder  = "Password"
    case readPrivacyPolicyText = "I have read the "
    case privacyPolicyText = "Privacy Policy"
    case getStartedButton = "GET STARTED"
    case eyeVectorImageName = "EyeVector"
    case unknownErrorAlert = "Naməlum xəta baş verdi."
    case okAlertTitle = "OK"
    
    case acceptPrivacyPolicyAlert = "Davam etmək üçün Privacy Policy-ni qəbul edin."
    case passwordFieldName = "Şifrə"
    case nameFieldName = "Ad"
    
    case welcomeLogInTitle = "Welcome , Log in"
    case logInWithEmailDivider = "OR LOG IN WITH EMAIL"
    case logInButtonTitle = "Log In"
    case forgotPasswordText = "Forgot Password ?"
    case dontHaveAccountText = "DON'T HAVE AN ACCOUNT?"
    
    case verifyEmailTitle = "Verify your email"
    case otpSubtitleFormat = "%@ ünvanına göndərilən 6 rəqəmli kodu daxil edin."
    case otpPlaceholder = "6 rəqəmli kod"
    case verifyButtonTitle = "TƏSDİQLƏ"
    case resendCodeButtonTitle = "Kodu yenidən göndər"
    
    case getStartedDescription = "Explore the app, Find some peace of mind to prepare for meditation."
    case hiGreetingFormat = "Hi %@,\n"
    case welcomeToAppName = "Welcome to Silent Moon"
    
    case emptyTopicSelectionError = "Please select at least one topic."
    
    case whatBringsYouTitle = "What Brings you"
    case toSilentMoonSubtitle = "\nto Silent Moon?"
    case chooseTopicSubtitle = "Choose a topic to focus on:"
    case continueButtonTitle = "CONTINUE"
    case continueWithCountFormat = "CONTINUE (%d)"
    
    case reminderTimeTitle = "What time would you like to meditate?\n"
    case reminderTimeSubtitle = "\nAny time you can choose but We recommend first thing in th morning."
    case reminderDayTitle = "Which day would you like to meditate?\n";
    case reminderDaySubtitle = "\nEveryday is best, but we recommend picking at least five."
    case saveButtonTitle = "SAVE"
    case noThanksTitle = "NO THANKS"
    
    case noDaysSelectedError = "Zəhmət olmasa, ən azı bir gün seçin."
    case reminderNotFoundToUpdateError = "Yenilənəcək xatırlatma tapılmadı."
    case reminderNotFoundToDeleteError = "Silinecek xatırlatma tapılmadı."
    
    case continueWithFacebook = "CONTINUE WITH FACEBOOK"
    case continueWithGoogle = "CONTINUE WITH GOOGLE"
    
    case welcomeSleepTitle = "Welcome to Sleep\n"
    case welcomeSleepSubtitle = "\nExplore the new king of sleep. It uses sound\nand visualization to create perfect conditions\nfor refreshing sleep"
    
    case sleepStoriesTitle = "Sleep Stories\n"
    case sleepStoriesSubtitle = "\nSoothing bedtime stories to help you fall\ninto a deep and natural sleep"
    case theOceanMoonTitle = "The Ocean Moon\n"
    case theOceanMoonSubtitle = "Non-stop 8- hour mixes of our\nmost popular sleep audio"
    case startButtonTitle = "START"
    
    case nightIslandTitle = "Night Island\n\n"
    case nightIslandSubtitle = "45 MIN•SLEEP MUSIC\n\n"
    case nightIslandDescription = "Ease the mind into a restful night’s sleep with these deep, amblent tones."
    case favoritesCount = "24.234 Favorits"
    case listeningCount = "34.234 Listening"
    case relatedTitle = "Related"
    
    case tabHomeTitle = "Home"
    case tabSleepTitle = "Sleep"
    case tabMeditateTitle = "Meditate"
    case tabMusicTitle = "Music"
    case tabAccountTitle = "Account"
    
    case meditateSubtitle = "we can learn how to recognize when our minds\n are doing their normal everyday acrobatics."
    case dailyCalmTitle = "Daily Calm"
    case dailyCalmSubtitle = "APR 30 • PAUSE PRACTICE."
    
    var letters : String {
        return self.rawValue
    }
}
extension AppStrings : CaseIterable {
    func getLetter() -> String {
        return self.rawValue
    }
}
