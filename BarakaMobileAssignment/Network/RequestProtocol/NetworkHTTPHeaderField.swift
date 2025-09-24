//
//  NetworkHTTPHeaderField.swift
//  BarakaMobileAssignment
//
//  Created by radha chilamkurthy on 24/09/25.
//

import Foundation

enum NetworkHTTPHeaderField {
    case headerFields(fields: [NetworkHTTPHeaderKeys: NetworkHTTPHeaderValues])

    var headers: [NetworkHTTPHeaderKeys: NetworkHTTPHeaderValues] {
        switch self {
        case let .headerFields(httpHeaders):
            return httpHeaders
        }
    }
}

enum NetworkHTTPHeaderKeys {
    case contentType
    case acceptType
}

enum NetworkHTTPHeaderValues {
    case json
}

extension NetworkHTTPHeaderKeys: Hashable {
    var description: String {
        switch self {
        case .contentType:
            return "Content-Type"
        case .acceptType:
            return "Accept"
        }
    }
}

extension NetworkHTTPHeaderValues: Hashable {
    var description: String {
        switch self {
        case .json:
            return "application/json"
        }
    }
}
