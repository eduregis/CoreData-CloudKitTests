//
//  DatabaseController.swift
//  CoreDataTests
//
//  Created by Eduardo Oliveira on 13/10/20.
//

import Foundation
import CoreData

class DatabaseController {
    // MARK: - Core Data stack

    static var persistentContainer: NSPersistentCloudKitContainer = {
        
        let container = NSPersistentCloudKitContainer(name: "CoreDataTests")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    static func saveContext () {
        let context = persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
