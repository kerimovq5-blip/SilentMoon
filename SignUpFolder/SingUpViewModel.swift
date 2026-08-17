//
//  SignUpViewModel.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 04.08.26.
//


import Foundation
import SilentMoonNetwork
import SilentMoonDomain

enum SignUpViewModelState {
    case idle
    case loading
    case success
    case invalidInput(String)
    case requestFailed(AppError<ApiErrorEnvelope>)
}

final class SignUpViewModel {

    
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var isPrivacyAccepted: Bool = false

    
    private(set) var state: SignUpViewModelState = .idle {
        didSet { onStateChange?() }
    }

   
    var onStateChange: (() -> Void)?

    var onRegisterSucceeded: ((_ email: String, _ name: String) -> Void)?

    private let repository: SilentMoonRepository

    init(repository: SilentMoonRepository ) {
        self.repository = repository
    }

    

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
        Task {[weak self] in
        guard let self else { return }
            let result = await repository.register(name: self.name, email: self.email, password: self.password)
            switch result {
            case .success:
                self.state = .success
                self.onRegisterSucceeded?(self.email, self.name)
            case .failure(let error):
                self.state = .requestFailed(self.asAppError(error))
            }
        }
    }

    
    private func asAppError(_ error: Error) -> AppError<ApiErrorEnvelope> {
        (error as? AppError<ApiErrorEnvelope>) ?? .unknown(error)
    }
}
