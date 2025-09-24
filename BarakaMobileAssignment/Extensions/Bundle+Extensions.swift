//
//  Bundle+Extensions.swift
//  BarakaMobileAssignment
//
//  Created by radha chilamkurthy on 24/09/25.
//

import Foundation

extension Bundle {
    var namespace: String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
}
