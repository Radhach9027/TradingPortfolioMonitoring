//
//  LivePricesRepository.swift
//  BarakaMobileAssignment
//
//  Created by radha chilamkurthy on 24/09/25.
//

import Foundation
import Combine

final class LivePricesRepository: LivePricesRepositoryProtocol {
    private var timer: Timer?
    private var subject = PassthroughSubject<[Position], Never>()
    private var originalPositions: [Position] = []

    func startLiveUpdates(for positions: [Position]) -> AnyPublisher<[Position], Never> {
        originalPositions = positions
        startTimer()
        return subject.eraseToAnyPublisher()
    }

    func stopLiveUpdates() {
        timer?.invalidate()
        timer = nil
    }
}

private extension LivePricesRepository {
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.simulatePriceChanges()
        }
    }

    func simulatePriceChanges() {
        let updated = originalPositions.map { position -> Position in
            let oldPrice = position.instrument.lastTradedPrice
            let fluctuation = Double.random(in: -0.1...0.1) // ±10%
            let newPrice = (oldPrice * (1 + fluctuation)).rounded(toPlaces: 2)

            let marketValue = position.quantity * newPrice
            let pnl = marketValue - position.cost
            let pnlPercentage = (pnl * 100 / position.cost).rounded(toPlaces: 2)

            return Position(
                instrument: Instrument(
                    ticker: position.instrument.ticker,
                    name: position.instrument.name,
                    exchange: position.instrument.exchange,
                    currency: position.instrument.currency,
                    lastTradedPrice: newPrice
                ),
                quantity: position.quantity,
                averagePrice: position.averagePrice,
                cost: position.cost,
                marketValue: marketValue,
                pnl: pnl,
                pnlPercentage: pnlPercentage
            )
        }

        subject.send(updated)
    }
}
