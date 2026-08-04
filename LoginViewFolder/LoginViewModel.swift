//
//  LoginViewModel.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 05.08.26.
//

import Foundation

enum LoginViewModelState {
    case idle
    case loading
    case success
    case invalidInput(String)
    case requestFailed(AppError)
}

final class LoginViewModel {
    var email: String = ""
    var password: String = ""

    private(set) var state: LoginViewModelState = .idle {
        didSet { onStateChange?() }
    }
    var onStateChange: (() -> Void)?

    
    var onEmailNotVerified: ((_ email: String) -> Void)?

    private let service: SilentMoonApiService

    init(service: SilentMoonApiService = .shared) {
        self.service = service
    }

    var isEmailValid: Bool {
        Validator.isValidEmail(email)
    }

    var isPasswordValid: Bool {
        password.count >= 8
    }

    func login() {
        guard isEmailValid else {
            state = .invalidInput("E-poçt formatı yanlışdır.")
            return
        }
        guard isPasswordValid else {
            state = .invalidInput("Şifrə minimum 8 simvol olmalıdır.")
            return
        }

        state = .loading
        service.login(email: email, password: password) {
            [weak self] result in
            
            guard let self else { return }
            switch result {
            case .success:
                self.state = .success
            case .failure(let error):
                let appError = self.asAppError(error)
                if appError.backendCode == "EMAIL_NOT_VERIFIED" {
                    self.onEmailNotVerified?(self.email)
                } else {
                    self.state = .requestFailed(appError)
                }
            }
        }
    }

    private func asAppError(_ error: Error) -> AppError {
        (error as? AppError) ?? .unknown(error)
    }
}
