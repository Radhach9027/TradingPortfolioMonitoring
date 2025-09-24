//
//  TitleLabel.swift
//  BarakaMobileAssignment
//
//  Created by radha chilamkurthy on 24/09/25.
//

import UIKit

open class BaseLabel: UILabel {
    
    init(
        text: String? = nil,
        font: UIFont = .systemFont(ofSize: 14),
        textColor: UIColor = .label,
        textAlignment: NSTextAlignment = .left,
        numberOfLines: Int = 1,
        lineHeight: CGFloat? = nil
    ) {
        super.init(frame: .zero)
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let lineHeight = lineHeight {
            setLineHeight(lineHeight)
        }
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setLineHeight(_ lineHeight: CGFloat) {
        guard let text = text, !text.isEmpty else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.alignment = textAlignment
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes([
            .paragraphStyle: paragraphStyle,
            .baselineOffset: (lineHeight - font.lineHeight) / 4
        ], range: NSRange(location: 0, length: attributedString.length))
        
        attributedText = attributedString
    }
}

