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
    case search(query: String, type: String? = nil, page: Int = 1, limit: Int = 20)

    var path: String {
        switch self {
        case .register:
            return "/auth/register"
        case .login:
            return "/auth/login"
        case .verifyEmail:
            return "/auth/verify-email"
        case .resendOtp:
            return "/auth/resend-otp"
        case .refresh:
            return "/auth/refresh"
        case .logout:
            return "/auth/logout"
        case .search:
            return "/search"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .register, .login, .verifyEmail, .resendOtp, .logout, .refresh:
            return .post
        case .search:
            return .get
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .search(let query, let type, let page, let limit):
            var items = [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "limit", value: "\(limit)")
            ]
            if let type {
                items.append(URLQueryItem(name: "type", value: type))
            }
            return items
        default:
            return []
        }
    }

    var requestBody: RequestBody? {
        switch self {
        case .register(let name, let email, let password):
            let dto = RegisterRequest(name: name, email: email, password: password)
            return .encodable(dto as! Encodable)
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
        case .search:
            return nil
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
