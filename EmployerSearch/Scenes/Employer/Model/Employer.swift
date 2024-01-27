//
//  Employer.swift
//  EmployerSearchApp
//
//  Created by rinto.andrews on 26/01/2024.
//

import Foundation

struct Employer: Codable, Equatable, Hashable {
    let discountPercentage, employerID: Int
    let name, place: String

    enum CodingKeys: String, CodingKey {
        case discountPercentage = "DiscountPercentage"
        case employerID = "EmployerID"
        case name = "Name"
        case place = "Place"
    }
}
