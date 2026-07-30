//
//  RegisterRequest.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 30.07.26.
//

import Foundation

// MARK: - RegisterRequest
struct RegisterRequest: Codable {
    let name: String?
    let email: String?
    let password: String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case email = "email"
        case password = "password"
    }
}
