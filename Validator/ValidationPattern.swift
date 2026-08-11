//
//  ValidationPattern.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 06.08.26.
//



import Foundation

protocol ValidationRule {
    func validate(_ value: String) -> String?
}

struct EmailRule: ValidationRule {
    func validate(_ value: String) -> String? {
        Validator.isValidEmail(value) ? nil : "E-poçt formatı yanlışdır."
    }
}

struct MinLengthRule: ValidationRule {
    let minLength: Int
    let fieldName: String

    func validate(_ value: String) -> String? {
        value.count >= minLength ? nil : "\(fieldName) minimum \(minLength) simvol olmalıdır."
    }
}

struct NotEmptyRule: ValidationRule {
    let fieldName: String

    func validate(_ value: String) -> String? {
        value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? "\(fieldName) boş ola bilməz."
            : nil
    }
}


enum FormValidator {
    static func validate(_ fields: [(value: String, rules: [ValidationRule])]) -> String? {
        for field in fields {
            for rule in field.rules {
                if let message = rule.validate(field.value) {
                    return message
                }
            }
        }
        return nil
    }
}
