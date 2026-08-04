//
//  OtpViewModel.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 05.08.26.
//

import Foundation


enum OtpViewModelState {
    case idle

    case verifying
    case verifySucceeded
    case invalidInput(String)       // klient-tərəfi validasiya (məs. "6 rəqəm daxil edin")
    case verifyFailed(AppError)

    case resending
    case resendSucceeded(String)    // backend-in "Yeni kod göndərildi" mesajı
    case resendFailed(AppError)
}

final class OtpViewModel {

    var email: String = ""
    var userName: String = ""
    var otp: String = ""

    private let apiService: SilentMoonApiService

    private(set) var state: OtpViewModelState = .idle {
        didSet { onStateChange?() }
    }
    var onStateChange: (() -> Void)?

    var onVerifySucceeded: ((_ userName: String) -> Void)?

    init(apiService: SilentMoonApiService = .shared) {
        self.apiService = apiService
    }

    

    func verify() {
        guard otp.count == 6 else {
            state = .invalidInput("Zəhmət olmasa 6 rəqəmli kodu daxil edin.")
            return
        }

        state = .verifying
        apiService.verifyEmail(email: email, otp: otp) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.state = .verifySucceeded
                self.onVerifySucceeded?(self.userName)
            case .failure(let error):
                self.state = .verifyFailed(self.asAppError(error))
            }
        }
    }

   

    func resendOtp() {
        state = .resending
        apiService.resendOtp(email: email) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                self.state = .resendSucceeded(response.message)
            case .failure(let error):
                self.state = .resendFailed(self.asAppError(error))
            }
        }
    }

    private func asAppError(_ error: Error) -> AppError {
        (error as? AppError) ?? .unknown(error)
    }
}
