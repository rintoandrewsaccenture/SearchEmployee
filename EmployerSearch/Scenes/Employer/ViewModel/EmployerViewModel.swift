//
//  EmployerViewModel.swift
//  EmployerSearchApp
//
//  Created by rinto.andrews on 26/01/2024.
//

import SwiftUI

@MainActor
final class EmployerViewModel: ObservableObject { 

    enum State {
        case loading
        case loaded(EmployerView.Config)
        case loadedWithError(_ code: Int, _ retry: () -> Void)
    }

    @Published var employers: [Employer] = []
    @Published var state: State = .loaded(.init(employerList: []))
    @Published var filter: String = ""

    let repository: RepositoryProtocol

    init(repository: RepositoryProtocol) {
        self.repository = repository
    }

    func loadEmployers() {
        Task {
            do {
                state = .loading
                let employers = try await repository.getEmployers(with: filter)
                state = .loaded(EmployerView.Config(employerList: employers))
            } catch {
                state = .loadedWithError(1897, {
                    self.loadEmployers()
                })
            }
        }
    }

    func validate(success: @escaping () -> Void) {
        if case State.loaded(var config) = self.state {

            let clearValidation: () -> Void = {
                config.validationErrorMessage = nil
            }

            Task {
                do {
                    clearValidation()
                    try validateForm()
                    state = .loaded(config)
                    success()
                } catch let error as FormValidationFail {
                    config.validationErrorMessage = error.validationErrorMessage
                    state = .loaded(config)
                } catch {
                    assert(false, "error")
                }
            }
        } 
    }

    func validateForm() throws {
        var validation = FormValidationFail()
        var failed = false

        if filter == "" {
            validation.validationErrorMessage = "Please enter valid company name"
            failed = true
        }

        if failed {
            throw validation
        }
    }
}

extension EmployerViewModel {
    struct FormValidationFail: Error, Equatable {
        var validationErrorMessage: String?
    }
}
