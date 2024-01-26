//
//  ErrorTextStyle.swift
//  EmployerSearch
//
//  Created by rinto.andrews on 26/01/2024.
//

import SwiftUI

struct ErrorTextStyleExample: View {
    var body: some View {
        Text("Error Occoured")
            .modifier(ErrorTextModifier())
    }
}

struct ErrorTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 12))
            .foregroundColor(.red)
    }
}

#Preview {
    ErrorTextStyleExample()
}
