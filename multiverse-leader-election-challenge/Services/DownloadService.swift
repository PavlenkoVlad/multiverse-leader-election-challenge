//
//  DownloadService.swift
//  multiverse-leader-election-challenge
//
//  Created by Vladislav Pavlenko on 09.04.2021.
//

import Foundation
import Firebase

class DownloadService {
    
    static let shared = DownloadService()
    
    private let coreData = CoreDataService.shared
    private let storage = Storage.storage()
    private let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    func downloadTracks(_ tracks: [String]) {
        for track in tracks {
            let trackRef = storage.reference(withPath: track)
            trackRef.getData(maxSize: 10 * 1024 * 1024) { [weak self] data, error in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                    return
                }
                
                guard let self = self, let data = data else { return }
                
                do {
                    try data.write(to: self.path.appendingPathComponent(track))
                    self.coreData.addTrack(with: track)
                } catch {
                    print("ERROR: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func url(for track: String) -> URL {
        return path.appendingPathComponent(track)
    }
}
