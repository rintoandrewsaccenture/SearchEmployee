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
    }

    override func tearDownWithError() throws {
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
        let employerVM = EmployerViewModel(repository: Repository(databseRepoProtocol: DataBaseRepository(mainContext: CoreDataTestStack.shared.mainContent),
                                                                  webserviceRepositoryProtocol: WebServiceRepository()))

        employerVM.filter = ""
        do {
            try employerVM.validateForm()
        } catch let error as EmployerViewModel.FormValidationFail {
            XCTAssertEqual(error.validationErrorMessage, "Please enter valid company name")
        }
    }


    func test_EmployerViewModel_WhenQueryEnterdIsEmpty_ValidationShouldFail() throws {
        let employerVM = EmployerViewModel(repository: Repository(databseRepoProtocol: DataBaseRepository(mainContext: CoreDataTestStack.shared.mainContent),
                                                                  webserviceRepositoryProtocol: WebServiceRepository()))

        employerVM.filter = ""
        employerVM.state = .loaded(EmployerView.Config(employerList: [], validationErrorMessage: nil))
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

    func test_DataBaseRepository_SaveAndUpdateQueryDataBase_RetriveSavedQuery() {
        let dbRepository = DataBaseRepository(mainContext: CoreDataTestStack.shared.mainContent)
        /// Save data in Memory
        try? dbRepository.save(queryModel: QueryModel(query: "info", date: Date().addingTimeInterval(7*24*60*60), json: emplopyers.data(using: .utf8)!))

        let query = try? dbRepository.fetchQuery(with: "info")

        XCTAssertEqual(query?.query, "info")
        XCTAssertEqual(emplopyers.data(using: .utf8), query?.response)

        try? dbRepository.updateQuery(query: query!, response: emplopyers2.data(using: .utf8)!)

        let fetchedquery = try? dbRepository.fetchQuery(with: "info")

        XCTAssertEqual(emplopyers2.data(using: .utf8), fetchedquery?.response)
    }

    func test_IfDataNotAvailbleInCache_LoadFromAPI() async {
        let coredataStack = CoreDataTestStack()
        let dbRepository = DataBaseRepository(mainContext: coredataStack.mainContent)
        let employerVM = EmployerViewModel(repository: Repository(databseRepoProtocol: dbRepository,
                                                                  webserviceRepositoryProtocol: MockWebService()))


        let employers = try? await employerVM.repository.getEmployers(with: "infosec")
        XCTAssertEqual(employers?.count, 2)
    }

    func test_IfDataAvailableInCache_LoadFromCache() async {
        let coredataStack = CoreDataTestStack()
        let dbRepository = DataBaseRepository(mainContext: coredataStack.mainContent)
        let employerVM = EmployerViewModel(repository: Repository(databseRepoProtocol: dbRepository,
                                                                  webserviceRepositoryProtocol: MockWebService()))
        /// Simulate exisiting data in database
        try? dbRepository.save(queryModel: QueryModel(query: "info", date: Date().addingTimeInterval(7*24*60*60), json: emplopyers.data(using: .utf8)!))
        let employers = try? await employerVM.repository.getEmployers(with: "info")
        XCTAssertEqual(employers?.count, 2)
    }

}


