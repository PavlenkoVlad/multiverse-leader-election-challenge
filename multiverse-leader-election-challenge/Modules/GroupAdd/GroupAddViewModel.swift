//
//  GroupAddViewModel.swift
//  multiverse-leader-election-challenge
//
//  Created by Vladislav Pavlenko on 08.04.2021.
//

import Foundation
import Firebase

class GroupAddViewModel: ObservableObject {
    
    private let userDefaults = UserDefaultsService.shared
    private let firestore = Firestore.firestore()
    
    @Published var name: String = ""
    
    func addGroup(completion: @escaping () -> Void) {
        guard let userId = userDefaults.userId else {
            completion()
            return
        }
        
        firestore.collection("groups").whereField("name", isEqualTo: name)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                    completion()
                    return
                }
                
                guard let document = snapshot?.documents.first,
                      var group = UserGroup(id: document.documentID, data: document.data()),
                      !group.participants.contains(userId)
                else {
                    completion()
                    return
                }
                
                group.participants.append(userId)
                document.reference.updateData(["participants": group.participants]) { error in
                    if let error = error {
                        print("ERROR: \(error.localizedDescription)")
                        completion()
                        return
                    }
                    
                    completion()
                }
            }
    }
}
