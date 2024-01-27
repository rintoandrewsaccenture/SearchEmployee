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

    /// Used to test  error case
    var error: Error!
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

let emplopyers = """
[
   {
      "DiscountPercentage":17,
      "EmployerID":14116,
      "Name":"Achmea Zeist",
      "Place":"ZEIST"
   },
   {
      "DiscountPercentage":8,
      "EmployerID":50832,
      "Name":"Achmea Vitaliteit b.v. Leusden",
      "Place":"LEUSDEN"
   }
]
"""
