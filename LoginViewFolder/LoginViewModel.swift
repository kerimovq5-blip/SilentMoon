//
//  LoginViewModel.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 05.08.26.
//

import Foundation
import SilentMoonManagers
import SilentMoonNetworkCommon

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

    init(service: SilentMoonApiService ) {
        self.service = service
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
        
        Task {[weak self ] in
        guard let self  else { return}
        let result = await service.login(email: email, password: password)
            
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
