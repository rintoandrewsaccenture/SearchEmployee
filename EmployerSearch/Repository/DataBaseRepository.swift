//
//  DataBaseRepository.swift
//  EmployerSearch
//
//  Created by rinto.andrews on 27/01/2024.
//

import CoreData

protocol DataBaseRepositoryProtocol {
    func save(queryModel: QueryModel) throws
    func updateQuery(query: Query, response: Data) throws
    func fetchQuery(with keyword: String) throws -> Query?
}

final class DataBaseRepository: DataBaseRepositoryProtocol {

    let mainContext: NSManagedObjectContext

    init(mainContext: NSManagedObjectContext) {
        self.mainContext = mainContext
    }

    func save(queryModel: QueryModel) throws {
        let query = Query(context: mainContext)
        query.query = queryModel.query.lowercased()
        query.timestamp = queryModel.expiryDate
        query.response = queryModel.response

        do {
            try mainContext.save()
        } catch {
            throw error
        }
    }

    func updateQuery(query: Query, response: Data) throws {
        query.timestamp = Date().addingTimeInterval(7*24*60*60)
        query.response = response

        do {
            try mainContext.save()
        } catch {
            throw error
        }
    }

    func fetchQuery(with keyword: String) throws -> Query?  {
        let fetchRequest = Query.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "query = %@", keyword)

        do {
            let result = try mainContext.fetch(fetchRequest).first
            return result
        } catch {
            throw error
        }
    }
}

