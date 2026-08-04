//
//  SingUpViewModel.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 05.08.26.
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
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var isPrivacyAccepted: Bool = false

    // MARK: - Output
    private(set) var state: SignUpViewModelState = .idle {
        didSet { onStateChange?() }
    }
    var onStateChange: (() -> Void)?

    var onRegisterSucceeded: ((_ email: String, _ name: String) -> Void)?

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

    private var isNameValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }


    func register() {
        guard isPrivacyAccepted else {
            state = .invalidInput("Davam etmək üçün Privacy Policy-ni qəbul edin.")
            return
        }
        guard isEmailValid else {
            state = .invalidInput("E-poçt formatı yanlışdır.")
            return
        }
        guard isPasswordValid else {
            state = .invalidInput("Şifrə minimum 8 simvol olmalıdır.")
            return
        }
        guard isNameValid else {
            state = .invalidInput("Ad boş ola bilməz.")
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
    
    private func asAppError(_ error: Error) -> AppError {
        (error as? AppError) ?? .unknown(error)
    }
}
