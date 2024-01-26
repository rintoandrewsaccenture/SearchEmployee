//
//  EmployerView.swift
//  EmployerSearchApp
//
//  Created by rinto.andrews on 26/01/2024.
//

import SwiftUI

struct EmployerView: View {

    @ObservedObject var employerVM: EmployerViewModel

    init(employerVM: EmployerViewModel) {
        self.employerVM = employerVM
    }

    struct Config: Equatable {
        var employerList: [Employer] = []
        var validationErrorMessage: String?
    }

    var body: some View {
        VStack {
            switch employerVM.state {
            case .loading:
                filterInputView()
                progressView()
            case .loaded(let config):
                filterInputView(errorMessage: config.validationErrorMessage)
                fliteredList(employers: config.employerList)
            case .loadedWithError(let code, let retry):
                ErrorView(code: code, retry: retry)
            }
        }
    }

    func filterInputView(errorMessage: String? = nil) -> some View {
        VStack(alignment: .leading) {
            HStack {
                TextField("Please enter employer name", text: $employerVM.filter)
                Button("Search") {
                    employerVM.validate {
                        employerVM.loadEmployers()
                    }
                }
            }
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .modifier(ErrorTextModifier())
            }
        }
        .padding(12)
    }

    func fliteredList(employers: [Employer]) -> some View {
        List(employers, id: \.self) { employer in
            ItemRow(employer: employer)
        }
    }

    func progressView() -> some View {
        VStack {
            Spacer()
            ProgressView()
                .progressViewStyle(.circular)
            Spacer()
        }
    }
}

#Preview {
    EmployerView(employerVM: EmployerViewModel(repository: Repository()))
}
