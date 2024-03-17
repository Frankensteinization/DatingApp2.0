//
//  SignUpView.swift
//  DatingApp
//
//  Created by Frank on 3/12/24.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var displayname: String = ""
    @State private var errorMessage: String = ""
    
    @EnvironmentObject private var model: Model
    @EnvironmentObject private var appState: AppState
    
    private var isFormValid: Bool {
        !email.isEmptyOrWhiteSpace && !password.isEmptyOrWhiteSpace && !displayname.isEmptyOrWhiteSpace
    }
    
    private func signUp() async {
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            try await model.updateDisplayName(for: result.user, displayName: displayname)
            appState.routes.append(.login)
        } catch {
            appState.errorWrapper = ErrorWrapper(error: error)
        }
    }
    
    var body: some View {
        Form {
            TextField("Email", text: $email).textInputAutocapitalization(.never)
            SecureField("Password", text: $password).textInputAutocapitalization(.never)
            TextField("Display name", text: $displayname)
            
            HStack {
                Spacer()
                Button("SignUp"){
                    Task {
                        await signUp()
                    }
                }.disabled(!isFormValid).buttonStyle(.borderless)
                
                Button("Login"){
                    appState.routes.append(.login)
                }.buttonStyle(.borderless)
                Spacer()
            }
            
        }
    }
}

#Preview {
    SignUpView().environmentObject(Model()).environmentObject(AppState())
}
