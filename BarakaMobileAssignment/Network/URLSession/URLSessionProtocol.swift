//
//  URLSessionProtocol.swift
//  BarakaMobileAssignment
//
//  Created by radha chilamkurthy on 24/09/25.
//

import Foundation

protocol URLSessionProtocol {
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
}

extension URLSession: URLSessionProtocol {}
