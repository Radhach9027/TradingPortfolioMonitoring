//
//  URL+Extensions.swift
//  BarakaMobileAssignment
//
//  Created by radha chilamkurthy on 24/09/25.
//

import UIKit

extension URL {
    var isValid: Bool {
        return (
            (self.host != nil)
            && (self.scheme != nil)
            && UIApplication.shared.canOpenURL(self))
    }
}
