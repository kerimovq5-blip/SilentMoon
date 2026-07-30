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
    case logout(refreshToken: String)

    var path: String {
        switch self {
        case .register:    return "/auth/register"
        case .login:       return "/auth/login"
        case .verifyEmail: return "/auth/verify-email"
        case .resendOtp:   return "/auth/resend-otp"
        case .refresh:     return "/auth/refresh"
        case .logout:      return "/auth/logout"
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
        case .logout(let refreshToken):
            return .dictionary(["refreshToken": refreshToken])
        }
    }

    var requiresAuth: Bool {
        switch self {
        case .logout:
            return true
        default:
            return false
        }
    }
}

// MARK: - Response modelləri
// Qeyd: bu struct-lar ayrıca "Models" faylında deyil, məhz aid olduqları
// endpoint enum-unun yanında saxlanılır — ErrorModel-in EndPoint.swift-də
// olduğu kimi eyni məntiq.

struct RegisterResponse: Decodable {
    let message: String
    let email: String
    let otpExpiresAt: String
}

struct ResendOtpResponse: Decodable {
    let message: String
    let otpExpiresAt: String
}

struct AuthResponse: Decodable {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let expiresIn: Int
    let user: UserProfile
}

struct UserProfile: Decodable {
    let id: String
    let name: String
    let email: String
    let emailVerified: Bool
    let avatarUrl: String?
    let createdAt: String
}
