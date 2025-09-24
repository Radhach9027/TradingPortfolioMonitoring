//
//  PortfolioRepository.swift
//  BarakaMobileAssignment
//
//  Created by radha chilamkurthy on 24/09/25.
//

import Foundation
import Combine

struct PortfolioRepository: PortfolioRepositoryProtocol {
    private let network: NetworkClientProtocol

    init(network: NetworkClientProtocol = NetworkClient(session: URLSession.shared)) {
        self.network = network
    }

    func fetchPortfolio(endpoint: PortfolioEndpoint) -> AnyPublisher<Portfolio, Error> {
        return network
            .request(for: endpoint, codable: PortfolioWrapper.self)
            .map(\.portfolio)
            .eraseToAnyPublisher()
    }
}
