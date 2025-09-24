//
//  NetworkRequestProtocol.swift
//  BarakaMobileAssignment
//
//  Created by radha chilamkurthy on 24/09/25.
//

import Foundation

protocol NetworkRequestProtocol {
    var timeoutInterval: TimeInterval { get }
    var httpMethod: NetworkRequestMethod { get }
    var urlComponents: URLComponents? { get }
    var httpHeaderFields: NetworkHTTPHeaderField? { get }
    func makeRequest() throws -> URLRequest
}

extension NetworkRequestProtocol {
    
    var timeoutInterval: TimeInterval {
        30
    }

    func makeRequest() throws -> URLRequest {
        guard let url = urlComponents?.url,
              url.isValid else {
            throw NetworkRequestProtocolError.badUrl
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = timeoutInterval
        request.httpMethod = httpMethod.rawValue
        httpHeaderFields?.headers.forEach {
            request.setValue(
                $0.value.description,
                forHTTPHeaderField: $0.key.description
            )
        }
        return request
    }
}

enum NetworkRequestProtocolError: Error {
    case badUrl
}
