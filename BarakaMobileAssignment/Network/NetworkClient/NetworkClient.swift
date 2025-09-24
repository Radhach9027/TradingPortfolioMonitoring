//
//  NetworkClient.swift
//  BarakaMobileAssignment
//
//  Created by radha chilamkurthy on 24/09/25.
//

import Foundation
import Combine

class NetworkClient {
    private(set) var session: URLSessionProtocol

    init(session: URLSessionProtocol) {
        self.session = session
    }
}

extension NetworkClient: NetworkClientProtocol {
    
    func request<T>(
        for request: NetworkRequestProtocol,
        codable: T.Type
    ) -> AnyPublisher<T, Error> where T: Decodable {
        do {
            let urlRequest = try request.makeRequest()
            
            return session.dataTaskPublisher(for: urlRequest)
                .tryMap { output in
                    if let response = output.response as? HTTPURLResponse,
                       !(200...299).contains(response.statusCode) {
                        throw URLError(.badServerResponse)
                    }
                    
                    return try JSONDecoder.dataDecoding(codable: T.self, data: output.data)
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
            
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}
