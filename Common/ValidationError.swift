//
//  ValidationError.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 30.07.26.
//


import Foundation

// MARK: - ValidationError
struct ValidationError: Decodable {
    let error: Error?

    enum CodingKeys: String, CodingKey {
        case error = "error"
    }
}

// MARK: - Error
struct Error: Decodable {
    let code: String?
    let message: String?
    let details: [Detail]?
    let requestId: String?

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
        case details = "details"
        case requestId = "requestId"
    }
}

// MARK: - Detail
struct Detail: Decodable {
    let field: String?
    let issue: String?

    enum CodingKeys: String, CodingKey {
        case field = "field"
        case issue = "issue"
    }
}
