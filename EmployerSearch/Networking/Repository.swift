//
//  Repository.swift
//  EmployerSearch
//
//  Created by rinto.andrews on 26/01/2024.
//

import Foundation

protocol RepositoryProtocol {
    func getEmployers(with filter: String) async throws -> [Employer]
}

final class Repository: RepositoryProtocol {

    func getEmployers(with filter: String) async throws -> [Employer] {
        let url = URL(string: "https://cba.kooijmans.nl/CBAEmployerservice.svc/rest/employers?filter=\(filter)&maxRows=100")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let emplyers = try JSONDecoder().decode([Employer].self, from: data)
        return emplyers
    }
}
