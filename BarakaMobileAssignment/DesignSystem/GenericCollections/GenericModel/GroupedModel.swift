//
//  GroupedModel.swift
//  BarakaMobileAssignment
//
//  Created by radha chilamkurthy on 24/09/25.
//

import Foundation

struct GroupedModel {
    public let section: Int
    public let rows: Int
    public var customCell: RegisterModelType? = nil
    public var header: RegisterModelType? = nil
    public var footer: RegisterModelType? = nil
    public var bundle: Bundle
    
    public init(
        section: Int,
        rows: Int,
        bundle: Bundle,
        customCell: RegisterModelType? = nil,
        header: RegisterModelType? = nil,
        footer: RegisterModelType? = nil
    ) {
        self.section = section
        self.rows = rows
        self.bundle = bundle
        self.customCell = customCell
        self.header = header
        self.footer = footer
    }
}
