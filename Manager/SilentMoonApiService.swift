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


    func resendOtp(
        email: String,
        completion: @escaping (Result<ResendOtpResponse, Error>) -> Void
    ) {
        network.request(endPoint: SilentMoonEndPoint.resendOtp(email: email), completion: completion)
    }


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

    

    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let refreshToken = TokenStore.shared.refreshToken else {
            TokenStore.shared.clear()
            completion(.success(()))
            return
        }
        
        struct EmptyResponse: Decodable {}
        network.request(endPoint: SilentMoonEndPoint.logout(refreshToken: refreshToken)) {(
            result: Result<EmptyResponse, Error>) in
            TokenStore.shared.clear()
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func search(
           query: String,
           type: String? = nil,
           page: Int = 1,
           limit: Int = 20,
           completion: @escaping (Result<SearchResponse, Error>) -> Void
       ) {
           network.request(
               endPoint: SilentMoonEndPoint.search(query: query, type: type, page: page, limit: limit),
               completion: completion
           )
       }
}
