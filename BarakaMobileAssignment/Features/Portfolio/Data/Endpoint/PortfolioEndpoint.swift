//
//  Untitled.swift
//  BarakaMobileAssignment
//
//  Created by radha chilamkurthy on 24/09/25.
//

import Foundation

enum PortfolioEndpoint: NetworkRequestProtocol {
    case fetch
}

extension PortfolioEndpoint {
    var httpMethod: NetworkRequestMethod {
        .get
    }
    
    var urlComponents: URLComponents? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "dummyjson.com"
        components.path = "/c/60b7-70a6-4ee3-bae8"
        return components
    }

    var httpHeaderFields: NetworkHTTPHeaderField? {
        .headerFields(fields: [
            .contentType : .json
        ])
    }
}
