//
//  SignUpViewModel.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 04.08.26.
//


import Foundation
import SilentMoonNetworkCommon
import SilentMoonManagers

enum SignUpViewModelState {
    case idle
    case loading
    case success
    case invalidInput(String)
    case requestFailed(AppError)
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

    private let service: SilentMoonApiService

    init(service: SilentMoonApiService ) {
        self.service = service
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
            let result = await service.register(name: name, email: email, password :password)
            switch result {
            case .success:
                self.state = .success
                self.onRegisterSucceeded?(self.email, self.name)
            case .failure(let error):
                self.state = .requestFailed(self.asAppError(error))
            }
        }
    }

    
    private func asAppError(_ error: Error) -> AppError {
        (error as? AppError) ?? .unknown(error)
    }
}
