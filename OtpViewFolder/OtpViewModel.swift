//
//  OtpViewModel.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 05.08.26.
//

import Foundation
import SilentMoonNetworkCommon
import SilentMoonManager

public enum OtpViewModelState {
    case idle

    case verifying
    case verifySucceeded
    case invalidInput(String)
    case verifyFailed(AppError)

    case resending
    case resendSucceeded(String)    
    case resendFailed(AppError)
}

public final class OtpViewModel {

    var email: String = ""
    var userName: String = ""
    var otp: String = ""

    private let apiService: SilentMoonApiService

    private(set) var state: OtpViewModelState = .idle {
        didSet { onStateChange?() }
    }
    var onStateChange: (() -> Void)?

    var onVerifySucceeded: ((_ userName: String) -> Void)?

    init(apiService: SilentMoonApiService ) {
        self.apiService = apiService
    }

    

  public  func verify() {
        guard otp.count == 6 else {
            state = .invalidInput("Zəhmət olmasa 6 rəqəmli kodu daxil edin.")
            return
        }
        
        state = .verifying
        Task { [weak self] in
                    guard let self else { return }
                    
                    let result = await self.apiService.verifyEmail(email: self.email, otp: self.otp)
                    
                    switch result {
                    case .success:
                        self.state = .verifySucceeded
                        self.onVerifySucceeded?(self.userName)
                    case .failure(let error):
                        self.state = .verifyFailed(self.asAppError(error))
                    }
                }
            }
   public func resendOtp() {
        state = .resending
        Task { [weak self] in
            guard let self else { return }
            
            let result = await self.apiService.resendOtp(email: self.email)
            
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
