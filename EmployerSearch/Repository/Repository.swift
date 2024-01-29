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

    let dataBaseRepositoryProtocol: DataBaseRepositoryProtocol
    let webserviceRepositoryProtocol: WebServiceRepositoryProtocol

    init(databseRepoProtocol: DataBaseRepositoryProtocol,
         webserviceRepositoryProtocol: WebServiceRepositoryProtocol ) {

        self.dataBaseRepositoryProtocol = databseRepoProtocol
        self.webserviceRepositoryProtocol = webserviceRepositoryProtocol
    }

    func getEmployers(with query: String) async throws -> [Employer] {
        if let savedQuery: Query = try dataBaseRepositoryProtocol.fetchQuery(with: query.lowercased()),
           let expiery = savedQuery.timestamp,
           let employerlist = savedQuery.response {

            if Date() < expiery {
                let employers = try JSONDecoder().decode([Employer].self, from: employerlist)
                return employers
            } else {
                let data = try await webserviceRepositoryProtocol.getEmployersApi(with: query)
                let employers = try JSONDecoder().decode([Employer].self, from: data)
                try dataBaseRepositoryProtocol.updateQuery(query: savedQuery, response: data)
                return employers
            }
        } else {
            let data = try await webserviceRepositoryProtocol.getEmployersApi(with: query)
            let employers = try JSONDecoder().decode([Employer].self, from: data)
            try dataBaseRepositoryProtocol.save(queryModel: QueryModel(query: query, date: Date().addingTimeInterval(7*24*60*60), json: data))
            return employers
        }
    }
}

