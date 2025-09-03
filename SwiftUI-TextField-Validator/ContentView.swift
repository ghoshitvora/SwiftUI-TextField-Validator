//
//  ContentView.swift
//  SwiftUI-TextField-Validator
//
//  Created by Ghoshit.
//

import SwiftUI

struct ContentView: View {
    
    @State private var txtEmail: String = ""
    @State private var isValidEmail: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
           Text("Validation Example")
                .font(.largeTitle)
                .bold()
            
            VStack(alignment: .leading) {
                Text("Email")
                
                TextField("Enter email", text: $txtEmail)
                    .padding(.horizontal, 12)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .validator(text: $txtEmail, isValid: $isValidEmail, validationType: .email, validationMode: .onTextChange)
                
                Text(isValidEmail ? "valid email" : "Please enter valid email")
                    .foregroundColor(isValidEmail ? .green : .red)
                        .padding(.top, 10)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
