//
//  SilentMoonEndPoint.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 29.07.26.
//


import Foundation

enum SilentMoonEndPoint: EndPoint {
    case register(name: String, email: String, password: String)
    case login(email: String, password: String)
    case verifyEmail(email: String, otp: String)
    case resendOtp(email: String)
    case refresh(refreshToken: String)

    var path: String {
        switch self {
        case .register:    return "/auth/register"
        case .login:       return "/auth/login"
        case .verifyEmail: return "/auth/verify-email"
        case .resendOtp:   return "/auth/resend-otp"
        case .refresh:     return "/auth/refresh"
        }
    }

    var method: HTTPMethod { .post }

    var queryItems: [URLQueryItem] { [] }

    var requestBody: RequestBody? {
        switch self {
        case .register(let name, let email, let password):
            return .dictionary(["name": name, "email": email, "password": password])
        case .login(let email, let password):
            return .dictionary(["email": email, "password": password])
        case .verifyEmail(let email, let otp):
            return .dictionary(["email": email, "otp": otp])
        case .resendOtp(let email):
            return .dictionary(["email": email])
        case .refresh(let refreshToken):
            return .dictionary(["refreshToken": refreshToken])
        }
    }
}
