//
//  SignUpViewModel.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 04.08.26.
//
//  MVVM-in "Model qatı ilə View arasındakı vasitəçi" rolu:
//  - View-dən heç bir UIKit tipi (UILabel, UIButton və s.) bura idxal olunmur
//  - Bütün "nə vaxt sorğu göndərilsin, hansı şərtlər ödənməlidir" məntiqi burdadır
//  - View yalnız `state`-i oxuyur, heç vaxt SilentMoonApiService-i özü çağırmır
//

import Foundation

enum SignUpViewModelState {
    case idle
    case loading
    case success
    case invalidInput(String)      // klient-tərəfi validasiya uğursuzluğu
    case requestFailed(AppError)   // şəbəkə/server xətası
}

final class SignUpViewModel {

    // MARK: - Inputs
    // View bu sahələri birbaşa (məsələn textField.editingChanged-də) yeniləyir.
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var isPrivacyAccepted: Bool = false

    // MARK: - Output
    private(set) var state: SignUpViewModelState = .idle {
        didSet { onStateChange?() }
    }

    /// View bu closure-u özünə bağlayır (bind edir) və state dəyişəndə UI-ı yeniləyir.
    /// Bu, Combine/RxSwift əvəzinə istifadə etdiyimiz ən sadə "binding" üsuludur.
    var onStateChange: (() -> Void)?

    /// Register uğurlu olanda View-ə "hansı email/ad ilə OTP ekranına keçim"
    /// deməyimiz lazımdır — bunun üçün ayrıca callback (state-in özü ilə
    /// deyil, çünki bu, "naviqasiya" fikridir, "state" fikri deyil).
    var onRegisterSucceeded: ((_ email: String, _ name: String) -> Void)?

    private let service: SilentMoonApiService

    init(service: SilentMoonApiService = .shared) {
        self.service = service
    }

    // MARK: - Register

    func register() {
        guard isPrivacyAccepted else {
            state = .invalidInput("Davam etmək üçün Privacy Policy-ni qəbul edin.")
            return
        }

        if let message = FormValidator.validate([
            (email, [EmailRule()]),
            (password, [MinLengthRule(minLength: 8, fieldName: "Şifrə")]),
            (name, [NotEmptyRule(fieldName: "Ad")])
        ]) {
            state = .invalidInput(message)
            return
        }

        state = .loading
        service.register(name: name, email: email, password: password) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.state = .success
                self.onRegisterSucceeded?(self.email, self.name)
            case .failure(let error):
                self.state = .requestFailed(self.asAppError(error))
            }
        }
    }

    /// Service qatı hələ ümumi Error qaytarır (AppError-a keçidi tam
    /// tamamlayanda bura ehtiyac qalmayacaq) — buradan keçirməyimiz
    /// ViewModel-i "gələcəkdə Service dəyişsə belə" qoruyur.
    private func asAppError(_ error: Error) -> AppError {
        (error as? AppError) ?? .unknown(error)
    }
}
