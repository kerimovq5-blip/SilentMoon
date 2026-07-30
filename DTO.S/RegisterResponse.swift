//
//  RegisterResponse.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 30.07.26.
//

import Foundation

// MARK: - RegisterResponse
struct RegisterResponse: Decodable {
    let message: String?
    let email: String?
    let otpExpiresAt: String?

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case email = "email"
        case otpExpiresAt = "otpExpiresAt"
    }
}
