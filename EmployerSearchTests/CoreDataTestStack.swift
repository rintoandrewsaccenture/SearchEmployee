//
//  CoreDataTestStack.swift
//  EmployerSearchTests
//
//  Created by rinto.andrews on 27/01/2024.
//

import CoreData
import Foundation
import XCTest

@testable import EmployerSearch

struct CoreDataTestStack {

    let persitentContianer: NSPersistentContainer
    let mainContent: NSManagedObjectContext

    init() {
        persitentContianer = NSPersistentContainer(name: "EmployerSearch")
        let description = persitentContianer.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType

        persitentContianer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("unable to load store")
            }
        }

        mainContent = persitentContianer.viewContext
    }
}
