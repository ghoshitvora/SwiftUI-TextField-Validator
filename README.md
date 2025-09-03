# SwiftUI-TextField-Validator

## Overview
This is a reusable **SwiftUI ViewModifier** for adding common validation to TextField. It provides a flexible way to validate user input with different rules and control when the validation runs.


## ✨ Features
- **Protocol-based:** Easily extendable to add new validation types.  
- **Multiple Validation Types:** Supports checks for empty, email, alphanumeric, numeric, and phone numbers.  
- **Two Validation Modes:**  Choose between real-time validation as the user types or on-demand validation triggered by an action, like a button press.
- **Simple Integration:** A single extension makes it easy to apply the modifier to any `TextField`.  

## Usage
1. Add the `ValidatorModifier.swift` file to your Xcode project.

2. Use the `.validator()` modifier on your TextField and provide the necessary bindings and parameters.

**Validation Example**

    @State private var txtEmail: String = ""
    @State private var isValidEmail: Bool = false

                TextField("Enter email", text: $txtEmail)
                    .padding(.horizontal, 12)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .validator(text: $txtEmail, isValid: $isValidEmail, validationType: .email, validationMode: .onTextChange)

## ValidationType Enum

The `validationType` enum specifies the type of validation to perform.

- `.empty`: Checks if the text field is not empty.
- `.email`: Validates a standard email format.
- `.alphanumeric`: Ensures the text contains only letters and numbers.
- `.numeric`: Checks if the text can be converted to a valid number.
- `.phoneNumber`: Validates a simple 10-digit phone number format.

## ValidationMode Enum

The `validationMode` enum determines when the validation logic is executed.

- `.onTextChange`: Validation runs automatically as the text changes.
- `.onDemand`: Validation is triggered manually by toggling the trigger binding.

## License
This project is licensed under the MIT License - see the LICENSE file for details.

