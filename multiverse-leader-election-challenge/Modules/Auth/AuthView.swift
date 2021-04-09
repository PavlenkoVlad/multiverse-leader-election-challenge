//
//  AuthView.swift
//  multiverse-leader-election-challenge
//
//  Created by Vladislav Pavlenko on 07.04.2021.
//

import SwiftUI

struct AuthView: View {
    
    @StateObject var viewModel = AuthViewModel()
    
    var body: some View {
        
        VStack(spacing: 16) {
            if viewModel.showLogin {
                Text("Login")
                    .font(.system(size: 40))
                    .bold()
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                FilledButton(title: "Login", action: viewModel.login)
                FilledButton(title: "Create account") {
                    withAnimation {
                        viewModel.showLogin.toggle()
                    }
                }
            } else {
                Text("Registration")
                    .font(.system(size: 40))
                    .bold()
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                FilledButton(title: "Create account", action: viewModel.registration)
                FilledButton(title: "Login") {
                    withAnimation {
                        viewModel.showLogin.toggle()
                    }
                }
            }
            
            if viewModel.showErrorMessage {
                Text(viewModel.errorMessage)
            }
        }
        .padding()
    }
}
