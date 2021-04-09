//
//  GroupsViewModel.swift
//  multiverse-leader-election-challenge
//
//  Created by Vladislav Pavlenko on 07.04.2021.
//

import Foundation
import Firebase

class GroupsViewModel: ObservableObject {
    
    enum Sheet {
        case create
        case add
    }
    
    private let userDefaults = UserDefaultsService.shared
    private let firestore = Firestore.firestore()
    
    @Published var groups: [UserGroup] = []
    @Published var sheet: Sheet = .create
    @Published var showSheet: Bool = false
    
    func updateUserGroups() {
        guard let userId = userDefaults.userId else { return }
        
        firestore.collection("groups").whereField("participants", arrayContains: userId)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else { return }
                self?.groups = documents.compactMap { UserGroup(id: $0.documentID, data: $0.data()) }
            }
    }
    
    func presentSheet(_ sheet: Sheet) {
        self.sheet = sheet
        self.showSheet = true
    }
}
