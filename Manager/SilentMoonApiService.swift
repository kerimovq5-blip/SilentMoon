//
//  SilentMoonApiService.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 29.07.26.
//

import Foundation

final class SilentMoonApiService {

    static let shared = SilentMoonApiService()

    private let network: NetworkManager

    /// Test üçün fərqli bir NetworkManager (məsələn mock) inject etmək istəsəniz init-i istifadə edin.
    init(network: NetworkManager = .silentMoon) {
        self.network = network
    }


    func register(
        name: String,
        email: String,
        password: String,
        completion: @escaping (Result<RegisterResponse, Error>) -> Void
    ) {
        network.request(
            endPoint: SilentMoonEndPoint.register(name: name, email: email, password: password),
            completion: completion
        )
    }

    // MARK: - Login

    func login(
        email: String,
        password: String,
        completion: @escaping (Result<AuthResponse, Error>) -> Void
    ) {
        network.request(endPoint: SilentMoonEndPoint.login(email: email, password: password)) { (result: Result<AuthResponse, Error>) in
            if case .success(let auth) = result {
                TokenStore.shared.save(access: auth.accessToken, refresh: auth.refreshToken)
            }
            completion(result)
        }
    }

    // MARK: - Verify Email (OTP)

    func verifyEmail(
        email: String,
        otp: String,
        completion: @escaping (Result<AuthResponse, Error>) -> Void
    ) {
        network.request(endPoint: SilentMoonEndPoint.verifyEmail(email: email, otp: otp)) { (result: Result<AuthResponse, Error>) in
            if case .success(let auth) = result {
                TokenStore.shared.save(access: auth.accessToken, refresh: auth.refreshToken)
            }
            completion(result)
        }
    }

    // MARK: - Resend OTP

    func resendOtp(
        email: String,
        completion: @escaping (Result<ResendOtpResponse, Error>) -> Void
    ) {
        network.request(endPoint: SilentMoonEndPoint.resendOtp(email: email), completion: completion)
    }

    // MARK: - Refresh token

    func refreshToken(
        completion: @escaping (Result<AuthResponse, Error>) -> Void
    ) {
        guard let refreshToken = TokenStore.shared.refreshToken else {
            completion(.failure(LocalError.invalidResponse))
            return
        }
        network.request(endPoint: SilentMoonEndPoint.refresh(refreshToken: refreshToken)) { (result: Result<AuthResponse, Error>) in
            if case .success(let auth) = result {
                TokenStore.shared.save(access: auth.accessToken, refresh: auth.refreshToken)
            }
            completion(result)
        }
    }

    // MARK: - Logout

    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let refreshToken = TokenStore.shared.refreshToken else {
            TokenStore.shared.clear()
            completion(.success(()))
            return
        }
        // /auth/logout 204 (boş gövdə) qaytarır, ona görə Decodable üçün kiçik bir "EmptyResponse" istifadə edirik.
        struct EmptyResponse: Decodable {}
        network.request(endPoint: SilentMoonEndPoint.logout(refreshToken: refreshToken)) { (result: Result<EmptyResponse, Error>) in
            TokenStore.shared.clear()
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
