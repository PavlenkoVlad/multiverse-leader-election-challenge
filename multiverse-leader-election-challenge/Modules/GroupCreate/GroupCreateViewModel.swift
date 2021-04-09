//
//  GroupCreateViewModel.swift
//  multiverse-leader-election-challenge
//
//  Created by Vladislav Pavlenko on 08.04.2021.
//

import Foundation
import Firebase

class GroupCreateViewModel: ObservableObject {
    
    private let userDefaults = UserDefaultsService.shared
    private let firestore = Firestore.firestore()
    private let storage = Storage.storage()
    
    @Published var tracklist: [String] = []
    @Published var name: String = ""
    @Published var selectedTracks: [String] = []
    
    func onAppear() {
        storage.reference().listAll { [weak self] result, error in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
                return
            }
            
            self?.tracklist = result.items.map { $0.name }
        }
    }
    
    func createGroup(completion: @escaping () -> Void) {
        let name = self.name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let userId = userDefaults.userId,
              !name.isEmpty,
              !selectedTracks.isEmpty
        else {
            completion()
            return
        }
        
        let group = UserGroup(name: name, leader: userId, participants: [userId], tracks: selectedTracks)
        firestore.collection("groups").document().setData(group.getData().data) { error in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            
            completion()
        }
    }
}
