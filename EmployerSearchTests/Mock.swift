//
//  Mock.swift
//  EmployerSearchTests
//
//  Created by rinto.andrews on 26/01/2024.
//

import Foundation
import XCTest

@testable import EmployerSearch

class MockRepository: RepositoryProtocol {
    /// Used to test api error case
    var error: Error!
    /// If error is set then throw error to test api failture case
    func getEmployers(with filter: String) async throws -> [Employer] {
        if let error = error {
            throw error
        }
        return Employer.mock()
    }
}

extension Employer {
    static func mock() -> [Employer] {
        return [
            Employer(discountPercentage: 23, employerID: 987, name: "John", place: "USA"),
            Employer(discountPercentage: 13, employerID: 934, name: "Doe", place: "EU"),
            Employer(discountPercentage: 45, employerID: 987, name: "Jane", place: "AUS")
        ]
    }
}

extension EmployerViewModel.State {
    func loadConfig() -> EmployerView.Config? {
        switch self {
        case .loaded(let config):
            return config
        default:
            return nil
        }
    }
}

enum APIFail: Error {
    case noResponse
}
