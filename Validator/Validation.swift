import UIKit

enum Validator {
    static func isValidEmail(_ text: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: text)
    }

   
    static func isValidPassword(_ text: String) -> Bool {
        text.count >= 8
    }
}

final class FieldValidationController: NSObject {
    
    private weak var fieldController: AppTextFieldController?
    private let validator: (String) -> Bool
    
    private lazy var checkButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return button
    }()
    
    var isValid: Bool {
        guard let text = fieldController?.text else { return false }
        return validator(text)
    }
    
    init(fieldController: AppTextFieldController, validator: @escaping (String) -> Bool) {
        self.fieldController = fieldController
        self.validator = validator
        super.init()
        configure()
    }
    
    private func configure() {
        guard let fieldController else { return }
        
        fieldController.textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 30))
        checkButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        container.addSubview(checkButton)
        fieldController.textField.rightView = container
        fieldController.textField.rightViewMode = .always
    }
    
    
    func markSubmitAttempt() {
        guard let fieldController else { return }
        fieldController.layer.borderColor = isValid
        ? UIColor.clear.cgColor
        : AssetColors.errorColor.color.cgColor
    }
    
    @objc private func textChanged() {
        guard let fieldController else { return }
        let text = fieldController.text
        
        guard !text.isEmpty else {
            checkButton.setImage(nil, for: .normal)
            fieldController.layer.borderColor = AssetColors.lightGray.color.cgColor
            return
        }
        
        if validator(text) {
            checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            checkButton.tintColor = .systemGreen
            fieldController.layer.borderColor = AssetColors.lightGray.color.cgColor
        } else {
            checkButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            checkButton.tintColor = AssetColors.errorColor.color
            fieldController.layer.borderColor = AssetColors.errorColor.color.cgColor
        }
    }
}

@MainActor
extension FieldValidationController {
    
    static func email(fieldController: AppTextFieldController) -> FieldValidationController {
        FieldValidationController(fieldController: fieldController, validator: Validator.isValidEmail)
    }

    static func password(fieldController: AppTextFieldController) -> FieldValidationController {
        FieldValidationController(fieldController: fieldController, validator: Validator.isValidPassword)
    }

    static func minLength(_ minLength: Int, fieldController: AppTextFieldController) -> FieldValidationController {
        FieldValidationController(fieldController: fieldController) { $0.count >= minLength }
    }
}
