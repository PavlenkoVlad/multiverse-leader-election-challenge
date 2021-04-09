//
//  AuthViewModel.swift
//  multiverse-leader-election-challenge
//
//  Created by Vladislav Pavlenko on 07.04.2021.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    
    var email: String = ""
    var password: String = ""
    var errorMessage: String = ""
    
    @Published var showLogin: Bool = true
    @Published var showErrorMessage: Bool = false
    
    private func authCompletion(_ result: AuthDataResult?, _ error: Error?) {
        if let error = error {
            errorMessage = error.localizedDescription
            showErrorMessage = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.showErrorMessage = false
            }
        } else {
            print("success")
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password, completion: authCompletion)
    }
    
    func registration() {
        Auth.auth().createUser(withEmail: email, password: password, completion: authCompletion)
    }
}
