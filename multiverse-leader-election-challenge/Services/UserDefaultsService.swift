//
//  UserDefaultsService.swift
//  multiverse-leader-election-challenge
//
//  Created by Vladislav Pavlenko on 08.04.2021.
//

import Foundation

@propertyWrapper struct UserDefaultsExecutable<Value> {
    
    let key: String
    var storage: UserDefaults = .standard
    
    var wrappedValue: Value? {
        get { storage.value(forKey: key) as? Value }
        set { storage.setValue(newValue, forKey: key) }
    }
}

class UserDefaultsService {
    
    static let shared = UserDefaultsService()
    
    @UserDefaultsExecutable(key: "user-id")
    var userId: String?
}
