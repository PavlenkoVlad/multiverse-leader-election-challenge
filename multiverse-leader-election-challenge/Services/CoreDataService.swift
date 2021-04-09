//
//  CoreDataService.swift
//  multiverse-leader-election-challenge
//
//  Created by Vladislav Pavlenko on 09.04.2021.
//

import Foundation
import CoreData

class CoreDataService {
    
    static let shared = CoreDataService()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "multiverse-leader-election-challenge")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func isDownloaded(tracks: [String]) -> Bool {
        let managedContext = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
        
        do {
            let downloadedTracks = try managedContext.fetch(fetchRequest)
            return tracks.allSatisfy { track in
                downloadedTracks.contains { $0.name == track }
            }
        } catch let error as NSError {
            print("ERROR: \(error.localizedDescription)")
            return false
        }
    }
    
    func addTrack(with name: String) {
        let managedContext = persistentContainer.viewContext
        let track = Track(context: managedContext)
        track.name = name
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("ERROR: \(error.localizedDescription)")
        }
    }
}
