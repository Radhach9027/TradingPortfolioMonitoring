//
//  File.swift
//  BarakaMobileAssignment
//
//  Created by radha chilamkurthy on 24/09/25.
//

import Foundation

struct Portfolio: Decodable {
    let balance: Balance
    let positions: [Position]
}

struct Balance: Decodable {
    let netValue, pnl, pnlPercentage: Double
}

struct Position: Decodable {
    let instrument: Instrument
    let quantity, averagePrice, cost, marketValue: Double
    let pnl, pnlPercentage: Double
}

struct Instrument: Decodable {
    let ticker, name, exchange, currency: String
    let lastTradedPrice: Double
}
