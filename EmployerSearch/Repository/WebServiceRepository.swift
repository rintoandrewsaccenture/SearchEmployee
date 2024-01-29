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

    var httpService: HttpServiceProtocol
    init() {
        self.httpService = ApiService()
    }

    func getEmployersApi(with filter: String) async throws -> Data {
        let employersRequest = EmployersRequest(query: filter)
        let response = try await httpService.sendDataRequest(employersRequest.urlRequest())
        return response
    }
}
