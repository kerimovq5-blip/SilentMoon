//
//  LoginViewModel.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 05.08.26.
//

import Foundation
import SilentMoonNetwork
import SilentMoonDomain

enum LoginViewModelState {
    case idle
    case loading
    case success
    case invalidInput(String)
    case requestFailed(AppError<ApiErrorEnvelope>)
}

@MainActor
final class LoginViewModel {
    var email: String = ""
    var password: String = ""
    
    private(set) var state: LoginViewModelState = .idle {
        didSet { onStateChange?() }
    }
    var onStateChange: (() -> Void)?
    
    var onEmailNotVerified: ((_ email: String) -> Void)?
    
    private let usecases: AuthUseCases
    
    init(usecases: AuthUseCases ) {
        self.usecases = usecases
    }
    
    
    func login() {
        if let message = FormValidator.validate([
            (email, [EmailRule()]),
            (password, [MinLengthRule(minLength: 8, fieldName: "Şifrə")])
        ]) {
            state = .invalidInput(message)
            return
        }
        state = .loading
        
        Task {
            let result = await usecases.login(email: self.email, password: self.password)
            
            handleLogin(result: result)
        }
    }
    private func handleLogin(result: Result<AuthResponseEntity, Error>) {
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
    
    private func asAppError(_ error: Error) -> AppError<ApiErrorEnvelope> {
        (error as? AppError<ApiErrorEnvelope>) ?? .unknown(error)
    }
}
