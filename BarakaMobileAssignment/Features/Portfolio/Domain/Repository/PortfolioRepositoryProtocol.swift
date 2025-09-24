//
//  Repository.swift
//  BarakaMobileAssignment
//
//  Created by radha chilamkurthy on 24/09/25.
//

import Combine

protocol PortfolioRepositoryProtocol {
    func fetchPortfolio(endpoint: PortfolioEndpoint) -> AnyPublisher<Portfolio, Error>
}

