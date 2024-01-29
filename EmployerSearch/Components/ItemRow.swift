//
//  ItemRow.swift
//  EmployerSearch
//
//  Created by rinto.andrews on 26/01/2024.
//

import SwiftUI

struct ItemRow: View {

    let employer: Employer

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(employer.name)
                    .bold()
                    .font(.system(size: 18))
                Text(employer.place)
                    .foregroundStyle(Color.gray)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 10) {
                Text("ID: \(employer.employerID)")
                    .bold()
                    .font(.system(size: 18))
                Text("Discount: \(employer.discountPercentage)%")
                    .foregroundStyle(Color.green)
            }
        }
        .padding()
    }
}

#Preview {
    ItemRow(employer: Employer(discountPercentage: 34, employerID: 87343, name: "Info Systems Limited", place: "USA"))
}
