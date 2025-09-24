//
//  File.swift
//  BarakaMobileAssignment
//
//  Created by radha chilamkurthy on 24/09/25.
//

import UIKit

final class SubtitleLabel: BaseLabel {
    init(text: String? = nil, alignment: NSTextAlignment = .left, numberOfLines: Int = 1) {
        super.init(
            text: text,
            font: .systemFont(ofSize: 14, weight: .regular),
            textColor: .secondaryLabel,
            textAlignment: alignment,
            numberOfLines: numberOfLines
        )
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
