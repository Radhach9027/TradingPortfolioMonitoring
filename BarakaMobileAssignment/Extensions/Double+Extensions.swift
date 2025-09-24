//
//  Double+Extensions.swift
//  BarakaMobileAssignment
//
//  Created by radha chilamkurthy on 24/09/25.
//

import Foundation

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let multiplier = pow(10.0, Double(places))
        return (self * multiplier).rounded() / multiplier
    }
}
