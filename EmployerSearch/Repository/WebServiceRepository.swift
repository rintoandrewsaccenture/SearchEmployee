//
//  WebServiceRepository.swift
//  EmployerSearch
//
//  Created by rinto.andrews on 27/01/2024.
//

import Foundation

protocol WebServiceRepositoryProtocol {
    func getEmployersApi(with filter: String) async throws -> Data
}

final class WebServiceRepository: WebServiceRepositoryProtocol {

    func getEmployersApi(with filter: String) async throws -> Data {
        let url = URL(string: "https://cba.kooijmans.nl/CBAEmployerservice.svc/rest/employers?filter=\(filter)&maxRows=100")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
