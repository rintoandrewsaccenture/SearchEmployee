//
//  HttpServiceProtocol.swift
//  EmployerSearch
//
//  Created by rinto.andrews on 27/01/2024.
//

import Foundation

struct DecodeError: Error {
    var failedType: String
    var error: Error
}

public enum HttpError: Error, Equatable {
    case unsuccessfulHttpStatus(Int)
    case unexpectedResponseType
    case networkError
}

protocol HttpServiceProtocol {
    func sendRequest<T:Decodable>(_ urlRequest: URLRequest) async throws -> T
    func sendDataRequest(_ urlRequest: URLRequest) async throws -> Data
}

extension HttpServiceProtocol {
    public func sendRequest<T: Decodable>(_ urlRequest: URLRequest) async throws -> T {
        let data = try await self.sendDataRequest(urlRequest)
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw DecodeError(failedType: String(describing: T.self), error: error)
        }
    }
}

protocol UrlSessionProtocol {
    func data(forRequest request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: UrlSessionProtocol {
    func data(forRequest request: URLRequest) async throws -> (Data, URLResponse) {
        return try await self.data(for: request)
    }
}

public final class ApiService: HttpServiceProtocol {

    lazy var urlSession: UrlSessionProtocol = URLSession(configuration: URLSessionConfiguration.default)

    private func networkRequest(_ urlRequest: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (data, urlResponse): (Data, URLResponse)
        do {
            (data, urlResponse) = try await self.urlSession.data(forRequest: urlRequest)
        } catch {
            throw HttpError.networkError
        }

        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            throw HttpError.unexpectedResponseType
        }
        return (data, httpResponse)
    }

    func sendDataRequest(_ urlRequest: URLRequest) async throws -> Data {
        let (data, _) = try await networkRequest(urlRequest)
        return data
    }
}
