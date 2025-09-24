//
//  LivePricesRepository.swift
//  BarakaMobileAssignment
//
//  Created by radha chilamkurthy on 24/09/25.
//

import Combine

protocol LivePricesRepositoryProtocol {
    func startLiveUpdates(for positions: [Position]) -> AnyPublisher<[Position], Never>
    func stopLiveUpdates()
}

