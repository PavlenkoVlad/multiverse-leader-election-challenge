//
//  UserGroup.swift
//  multiverse-leader-election-challenge
//
//  Created by Vladislav Pavlenko on 08.04.2021.
//

import Foundation

struct UserGroup: Identifiable, Hashable {
    
    let id: String
    let name: String
    
    var leader: String
    var participants: [String]
    var tracks: [String]
    
    init(name: String, leader: String, participants: [String], tracks: [String]) {
        self.id = ""
        self.name = name
        self.leader = leader
        self.participants = participants
        self.tracks = tracks
    }
    
    init?(id: String, data: [String: Any]) {
        guard let name = data["name"] as? String,
              let leader = data["leader"] as? String,
              let participants = data["participants"] as? [String],
              let tracks = data["tracks"] as? [String]
        else { return nil }
        
        self.id = id
        self.name = name
        self.leader = leader
        self.participants = participants
        self.tracks = tracks
    }
    
    func getData() -> (id: String, data: [String: Any]) {
        let data: [String: Any] = [
            "name": name,
            "leader": leader,
            "participants": participants,
            "tracks": tracks
        ]
        
        return (id, data)
    }
}
