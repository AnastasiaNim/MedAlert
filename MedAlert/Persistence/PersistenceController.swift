//
//  PersistenceController.swift
//  MedAlert
//
//  Created by Anastasia N.  on 05.05.2025.
//

import Foundation
import CoreData

final class PersistenceController {
    
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    private var containerName:  String = "MedsContainer"
    let viewContext: NSManagedObjectContext
    
    private init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading Core Data! \(error.localizedDescription)")
            }
        }
        if let storeURL = container.persistentStoreDescriptions.first?.url {
            print("Core Data store URL: \(storeURL)")
        }
        viewContext = container.viewContext
    }
}
