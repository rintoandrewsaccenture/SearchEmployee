//
//  ErrorView.swift
//  EmployerSearch
//
//  Created by rinto.andrews on 26/01/2024.
//

import SwiftUI

struct ErrorView: View {

    let code: Int
    let retry: () -> Void

    init(code: Int, retry: @escaping () -> Void) {
        self.code = code
        self.retry = retry
    }

    var body: some View {
        VStack {
            Text("Some Error Occuoured Please use the error code to find the root cause of the error \(code)")
            Button("Retry") {
                retry()
            }
        }
    }
}

