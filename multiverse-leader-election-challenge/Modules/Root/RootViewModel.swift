//
//  RootViewModel.swift
//  multiverse-leader-election-challenge
//
//  Created by Vladislav Pavlenko on 07.04.2021.
//

import Foundation
import FirebaseAuth

class RootViewModel: ObservableObject {
    
    enum State {
        
        case initial
        case auth
        case home
    }
    
    private let userDefaults = UserDefaultsService.shared
    private var authHandle: AuthStateDidChangeListenerHandle!
    
    @Published var state: State = .initial
    
    func onAppear() {
        authHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if let user = user {
                self?.userDefaults.userId = user.uid
                self?.state = .home
            } else {
                self?.state = .auth
            }
        }
    }
    
    func onDisappear() {
        Auth.auth().removeStateDidChangeListener(authHandle)
    }
}
