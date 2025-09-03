//
//  ValidatorModifier.swift
//  SwiftUI-TextField-Validator
//
//  Created by Ghoshit.
//

import SwiftUI

/// A protocol that defines the common validation functionality.
/// This can be extended to support more complex validation logic in the future.
protocol ValidationProtocol {
    /// The input text to be validated.
    var text: String { get set }
    
    /// A boolean indicating whether the input is currently valid.
    var isValid: Bool { get set }
    
    /// The type of validation to perform.
    var validationType: ValidationType { get }
    
    /// The mode of validation (live or on-demand).
    var validationMode: ValidationMode { get }
}

/// An enumeration of the different validation rules.
enum ValidationType {
    case empty
    case email
    case alphanumeric
    case numeric
    case phoneNumber
}

/// An enumeration to define when validation should occur.
enum ValidationMode {
    case onTextChange
    case onDemand
}

/// A custom `ViewModifier` for adding common validation to a SwiftUI `TextField`.
struct ValidatorModifier: ViewModifier, ValidationProtocol {
    
    @Binding var text: String
    @Binding var isValid: Bool
    
    // A separate trigger binding is only needed for on-demand validation.
    @Binding var trigger: Bool
    
    @State private var hasBeenTriggered: Bool = false
    
    let validationType: ValidationType
    let validationMode: ValidationMode
    
    /// The validation logic that checks the input string based on the validation type.
    private func validate() {
        switch validationType {
        case .empty:
            isValid = !text.isEmpty
        case .email:
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            isValid = emailPredicate.evaluate(with: text)
        case .alphanumeric:
            let alphanumericRegex = "^[a-zA-Z0-9]*$"
            let alphanumericPredicate = NSPredicate(format: "SELF MATCHES %@", alphanumericRegex)
            isValid = alphanumericPredicate.evaluate(with: text)
        case .numeric:
            isValid = Double(text) != nil
        case .phoneNumber:
            let phoneRegex = "^[0-9]{10}$" // A simple 10-digit number regex
            let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            isValid = phonePredicate.evaluate(with: text)
        }
    }
    
    /// The main body of the modifier that applies the validation logic and visual feedback.
    func body(content: Content) -> some View {
        content
            .onChange(of: text) {
                // Validate on text change if the mode is set to live validation
                if validationMode == .onTextChange {
                    validate()
                }
            }
            .onChange(of: trigger) { 
                // Validate only when the trigger is activated in on-demand mode
                if validationMode == .onDemand && trigger {
                    validate()
                    hasBeenTriggered = true
                    // Reset the trigger so it can be activated again
                    DispatchQueue.main.async {
                        trigger = false
                    }
                }
            }
    }
}

// MARK: - View Extension

extension View {
    /// A convenient extension to apply the `CommonValidatorModifier` to any view.
    /// - Parameters:
    ///   - text: A binding to the string value of the text field.
    ///   - isValid: A binding to a boolean that will hold the validation result.
    ///   - validationType: The type of validation to apply.
    ///   - validationMode: The mode of validation to use (`.onTextChange` or `.onDemand`).
    ///   - trigger: A binding to a boolean that, when toggled, will trigger validation for the `.onDemand` mode.
    func validator(
        text: Binding<String>,
        isValid: Binding<Bool>,
        validationType: ValidationType,
        validationMode: ValidationMode,
        trigger: Binding<Bool> = .constant(false)
    ) -> some View {
        self.modifier(ValidatorModifier(
            text: text,
            isValid: isValid,
            trigger: trigger,
            validationType: validationType,
            validationMode: validationMode
        ))
    }
}
