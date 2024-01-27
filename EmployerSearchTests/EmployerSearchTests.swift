//
//  EmployerSearchTests.swift
//  EmployerSearchTests
//
//  Created by rinto.andrews on 26/01/2024.
//

import Combine
import XCTest
@testable import EmployerSearch

@MainActor
final class EmployerSearchTests: XCTestCase {

    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_EmployerViewModel_WhenUserSearchWithValidQuery_ShouldReturnEmployers() {
        let repository = MockRepository()
        
        let employerVM = EmployerViewModel(repository: repository)

        employerVM.state = .loaded(EmployerView.Config(employerList: Employer.mock()))

        let expection = expectation(description: #function)
        employerVM.$state
            .sink { state in
                let config = state.loadConfig()
                XCTAssertNotNil(config?.employerList)
                expection.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expection], timeout: 0.1)
    }

    func test_EmpolyerViewModel_WhenUserEnterEmptyQuery_ShouldReturnErrorMessage() {
        let repository = MockRepository()
        let employerVM = EmployerViewModel(repository: repository)

        employerVM.state = .loaded(EmployerView.Config(employerList: [],validationErrorMessage: "please enter valid query"))

        let expection = expectation(description: #function)
        employerVM.$state
            .sink { state in
                let config = state.loadConfig()
                XCTAssertNotNil(config?.validationErrorMessage)
                expection.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expection], timeout: 0.1)
    }

    func test_EmployerViewModel_WhenCallAPISuccess_ReturnEmployersList() {
        let repository = MockRepository()
        let employerVM = EmployerViewModel(repository: repository)

        employerVM.state = .loaded(EmployerView.Config(employerList: []))


        let expection = expectation(description: #function)
        employerVM.$state
            .dropFirst(2)
            .sink { state in
                let config = state.loadConfig()
                XCTAssertNotNil(config?.employerList)
                expection.fulfill()
            }
            .store(in: &cancellables)
        employerVM.loadEmployers()
        wait(for: [expection], timeout: 0.1)
    }

    func test_EmployerViewModel_WhenCallAPIFail_ReturnError() {
        let repository = MockRepository()
        repository.error = APIFail.noResponse
        let employerVM = EmployerViewModel(repository: repository)

        employerVM.state = .loaded(EmployerView.Config(employerList: []))


        let expection = expectation(description: #function)
        employerVM.$state
            .dropFirst(2)
            .sink { state in
                let config = state.loadConfig()
                XCTAssertNil(config?.employerList)
                expection.fulfill()
            }
            .store(in: &cancellables)
        employerVM.loadEmployers()
        wait(for: [expection], timeout: 0.1)
    }

    func test_EmployerViewModel_WhenQueryIsEmpty_ValidationThrowError() throws {
        let coredataStack = CoreDataTestStack()

        let employerVM = EmployerViewModel(repository: Repository(databseRepoProtocol: DataBaseRepository(mainContext: coredataStack.mainContent), webserviceRepositoryProtocol: WebServiceRepository()))

        employerVM.filter = ""
        do {
            try employerVM.validateForm()
        } catch let error as EmployerViewModel.FormValidationFail {
            XCTAssertEqual(error.validationErrorMessage, "Please enter valid company name")
        }
    }


    func test_EmployerViewModel_WhenQueryEnterdIsEmpty_ValidationShouldFail() throws {
        let coredataStack = CoreDataTestStack()
        let employerVM = EmployerViewModel(repository: Repository(databseRepoProtocol: DataBaseRepository(mainContext: coredataStack.mainContent), webserviceRepositoryProtocol: WebServiceRepository()))

        employerVM.state = .loaded(EmployerView.Config(employerList: []))
        let expection = expectation(description: #function)
        employerVM.$state
            .dropFirst()
            .sink { state in
                let config = state.loadConfig()
                XCTAssertNotNil(config?.validationErrorMessage)
                expection.fulfill()
            }
            .store(in: &cancellables)
        employerVM.validate {
            XCTFail("should not apss")
        }
        wait(for: [expection], timeout: 0.1)
    }
}


