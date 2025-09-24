//
//  NetworkClientProtocol.swift
//  BarakaMobileAssignment
//
//  Created by radha chilamkurthy on 24/09/25.
//

import Foundation
import Combine

protocol NetworkClientProtocol {
    func request<T>(
        for request: NetworkRequestProtocol,
        codable: T.Type,
    ) -> AnyPublisher<T, Error> where T: Decodable
}
