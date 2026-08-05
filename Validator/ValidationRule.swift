//
//  ValidationRule.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 06.08.26.
//

//
//  ValidationRule.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 05.08.26.
//
//  "Validation pattern" (Rule/Specification pattern): hər qayda öz-özünü
//  yoxlayır və xəta mesajını özü daşıyır. ViewModel-lər Validator.isValidEmail
//  kimi ATOM yoxlamaları TƏKRARLAMIR — bu Rule-lar onların üzərinə qurulub,
//  beləcə "email formatı necə yoxlanılır" sualının cavabı YALNIZ bir yerdə
//  (Validator enum-unda) qalır.
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

/// Bir neçə sahəni, hər birinin öz qaydalar dəstəsi ilə, sıra ilə yoxlayır.
/// İlk uğursuz qayda tapılan kimi dayanır (ilk mesajı qaytarır) — istifadəçiyə
/// eyni anda 5 xəta yağdırmaq əvəzinə, bir-bir düzəltdirmək daha rahatdır.
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
