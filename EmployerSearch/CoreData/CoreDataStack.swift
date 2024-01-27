//
//  CoreDataStack.swift
//  EmployerSearch
//
//  Created by rinto.andrews on 26/01/2024.
//

import CoreData

class CoreDataStack {

    static let shared = CoreDataStack()

    let persitentContianer: NSPersistentContainer
    let mainContent: NSManagedObjectContext

    init() {
        persitentContianer = NSPersistentContainer(name: "EmployerSearch")
        let description = persitentContianer.persistentStoreDescriptions.first
        description?.type = NSSQLiteStoreType

        persitentContianer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("unable to load store")
            }
        }

        mainContent = persitentContianer.viewContext
    }
}
