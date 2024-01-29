//
//  EmployersRequest.swift
//  EmployerSearch
//
//  Created by rinto.andrews on 27/01/2024.
//

import Foundation

struct EmployersRequest {

    let query: String
    func urlRequest() -> URLRequest {
        let path = "rest/employers?filter=\(query)&maxRows=100"
        let url = URL(string: "\(hostName)/\(path)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
