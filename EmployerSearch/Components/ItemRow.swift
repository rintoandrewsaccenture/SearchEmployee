//
//  ItemRow.swift
//  EmployerSearch
//
//  Created by rinto.andrews on 26/01/2024.
//

import SwiftUI
//Test commit
struct ItemRow: View {

    let employer: Employer

    var body: some View {
        HStack {
            VStack {
                Text(employer.name)
                Text(employer.place)
            }
            Spacer()
            VStack {
                Text("Employee ID \(employer.employerID)")
                Text("Discount Percentage\(employer.discountPercentage)%")
            }
        }
        .padding()
    }
}

#Preview {
    ItemRow(employer: Employer(discountPercentage: 34, employerID: 87343, name: "John", place: "USA"))
}
