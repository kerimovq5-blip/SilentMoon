//
//  OtpViewModel.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 05.08.26.
//

import Foundation
import SilentMoonNetwork
import SilentMoonDomain

public enum OtpViewModelState {
    case idle
    case verifying
    case verifySucceeded
    case invalidInput(String)
    case verifyFailed(AppError<ApiErrorEnvelope>)
    case resending
    case resendSucceeded(String)
    case resendFailed(AppError<ApiErrorEnvelope>)
}

@MainActor
public final class OtpViewModel {

    public var email: String
    public var userName: String
    public var otp: String = ""

    private let usecases: SilentMoonUseCases

    public private(set) var state: OtpViewModelState = .idle {
        didSet { onStateChange?() }
    }
    
    public var onStateChange: (() -> Void)?
    public var onVerifySucceeded: ((_ userName: String) -> Void)?

    public init(
        usecases: SilentMoonUseCases,
        email: String = "",
        userName: String = ""
    ) {
        self.usecases = usecases
        self.email = email
        self.userName = userName
    }

    public func verify() {
        guard otp.count == 6 else {
            state = .invalidInput("Zəhmət olmasa 6 rəqəmli kodu daxil edin.")
            return
        }
        
        state = .verifying
        
        Task {
            let result = await usecases.verifyEmail(email: email, otp: otp)
            handleverify(result: result)
            
        }
    }
        private func handleverify(result: Result<AuthResponseEntity, Error>) {
            switch result {
            case .success:
                self.state = .verifySucceeded
                self.onVerifySucceeded?(self.userName)
            case .failure(let error):
                self.state = .verifyFailed(self.asAppError(error))
            }
        }
    
    

    public func resendOtp() {
        state = .resending
        Task {
           
            let result = await usecases.resendOtp(email: email)
            handleResend(result: result)
           
        }
    }
private func handleResend(result: Result<ResendOtpResponseEntity, Error>) {
    switch result {
    case .success(let response):
        let message = response.message
        self.state = .resendSucceeded(message)
    case .failure(let error):
        self.state = .resendFailed(self.asAppError(error))
    }
}
    private func asAppError(_ error: Error) -> AppError<ApiErrorEnvelope> {
        (error as? AppError<ApiErrorEnvelope>) ?? .unknown(error)
    }
}
