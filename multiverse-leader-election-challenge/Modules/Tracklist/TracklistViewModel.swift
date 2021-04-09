//
//  TracklistViewModel.swift
//  multiverse-leader-election-challenge
//
//  Created by Vladislav Pavlenko on 08.04.2021.
//

import Foundation
import Firebase
import CoreData
import AVFoundation

class TracklistViewModel: ObservableObject {
    
    private let userDefaults = UserDefaultsService.shared
    private let firestore = Firestore.firestore()
    private let coreData = CoreDataService.shared
    private let downloadService = DownloadService.shared
    
    private var player: AVAudioPlayer!
    
    var group: UserGroup
    
    @Published var isDownloaded: Bool = false
    @Published var isPlaying: Bool = false
    @Published var selectedTrack: String = ""
    
    init(group: UserGroup) {
        self.group = group
    }
    
    private func deleteGroup() {
        firestore.collection("groups").whereField("name", isEqualTo: group.name)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                    return
                }
                
                guard let document = snapshot?.documents.first else { return }
                
                document.reference.delete { error in
                    if let error = error {
                        print("ERROR: \(error.localizedDescription)")
                    }
                }
            }
    }
    
    private func updateLeader() {
        guard let leader = group.participants.randomElement() else { return }
        firestore.collection("groups").whereField("name", isEqualTo: group.name)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                    return
                }
                
                guard let self = self,
                      let document = snapshot?.documents.first
                else {
                    return
                }
                
                let data: [String: Any] = [
                    "leader": leader,
                    "participants": self.group.participants
                ]
                
                document.reference.updateData(data) { error in
                    if let error = error {
                        print("ERROR: \(error.localizedDescription)")
                    }
                }
            }
    }
    
    private func updateParticipants() {
        firestore.collection("groups").whereField("name", isEqualTo: group.name)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                    return
                }
                
                guard let self = self,
                      let document = snapshot?.documents.first
                else {
                    return
                }
                
                let data: [String: Any] = ["participants": self.group.participants]
                
                document.reference.updateData(data) { error in
                    if let error = error {
                        print("ERROR: \(error.localizedDescription)")
                    }
                }
            }
    }
    
    func onAppear() {
        isDownloaded = coreData.isDownloaded(tracks: group.tracks)
    }
    
    func downloadTracks() {
        downloadService.downloadTracks(group.tracks)
    }
    
    func playTrack(with name: String) {
        isPlaying = true
        selectedTrack = name
        let url = downloadService.url(for: selectedTrack)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            player.play()
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
    func playBackward() {
        guard !selectedTrack.isEmpty,
              let index = group.tracks.firstIndex(of: selectedTrack)
        else {
            return
        }
        
        if index == 0 {
            playTrack(with: group.tracks.last!)
        } else {
            playTrack(with: group.tracks[index - 1])
        }
    }
    
    func playPause() {
        guard let player = player, !selectedTrack.isEmpty else { return }
        isPlaying.toggle()
        if isPlaying {
            player.play()
        } else {
            player.pause()
        }
    }
    
    func playForward() {
        guard !selectedTrack.isEmpty,
              let index = group.tracks.firstIndex(of: selectedTrack)
        else {
            return
        }
        
        if index == group.tracks.count - 1 {
            playTrack(with: group.tracks.first!)
        } else {
            playTrack(with: group.tracks[index + 1])
        }
    }
    
    func leaveFromGroup() {
        guard let userId = userDefaults.userId,
              let index = group.participants.firstIndex(of: userId)
        else {
            return
        }
        
        group.participants.remove(at: index)
        
        if group.participants.isEmpty {
            deleteGroup()
        }
        
        if !group.participants.isEmpty && group.leader == userId {
            updateLeader()
        }
        
        if !group.participants.isEmpty && group.leader != userId {
            updateParticipants()
        }
    }
}
