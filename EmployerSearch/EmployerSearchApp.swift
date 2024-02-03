//
//  EmployerSearchApp.swift
//  EmployerSearch
//
//  Created by rinto.andrews on 26/01/2024.
//

import SwiftUI

@main
struct EmployerSearchApp: App {

    var body: some Scene {
        WindowGroup {
            EmployerView(employerVM: EmployerViewModel(repository: Repository(database: DataBaseRepository(mainContext: CoreDataStack.shared.mainContent),
                                                                              webservice: WebServiceRepository())))
        }
    }
}
