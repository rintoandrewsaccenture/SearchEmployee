//
//  Repository.swift
//  EmployerSearch
//
//  Created by rinto.andrews on 26/01/2024.
//

import CoreData

protocol RepositoryProtocol {
    func getEmployers(with query: String) async throws -> [Employer]
}

final class Repository: RepositoryProtocol {

    let database: DataBaseRepositoryProtocol
    let webservice: WebServiceRepositoryProtocol

    init(database: DataBaseRepositoryProtocol,
         webservice: WebServiceRepositoryProtocol ) {

        self.database = database
        self.webservice = webservice
    }

    func getEmployers(with query: String) async throws -> [Employer] {
        if let query = try loadFromDatabase(query: query) {
            if let response = try isQueryNotExpiredThenUseSavedResponse(query: query) {
                return response
            } else {
                return try await fetchAndSaveToDatabase(query: query.query)
            }
        } else {
            return try await fetchAndSaveToDatabase(query: query)
        }
    }

    private func isQueryNotExpiredThenUseSavedResponse(query: QueryModel) throws -> [Employer]? {
        if Date() < query.expiryDate {
            let employers = try JSONDecoder().decode([Employer].self, from: query.response)
            return employers
        }
        return nil
    }

    private func loadFromDatabase(query: String) throws -> QueryModel? {
        guard let query: Query = try database.fetchQuery(with: query.lowercased()),
              let text: String = query.query,
              let expieryDate = query.timestamp,
              let response = query.response else { return nil }
        return QueryModel(query: text, expiryDate: expieryDate, response: response)
    }

    private func fetchAndSaveToDatabase(query: String) async throws -> [Employer] {
        let response = try await webservice.getEmployersApi(with: query)
        let employers = try JSONDecoder().decode([Employer].self, from: response)
        try database.save(queryModel: QueryModel(query: query, expiryDate: Date().addingTimeInterval(7*24*60*60), response: response))
        return employers
    }
}

