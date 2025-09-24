//
//  PositionCell.swift
//  BarakaMobileAssignment
//
//  Created by radha chilamkurthy on 24/09/25.
//

import UIKit

final class PositionCell: UICollectionViewCell {
    private lazy var tickerLabel = TitleLabel()
    private lazy var companyNameLabel = SubtitleLabel()
    private lazy var priceLabel = TitleLabel()
    private lazy var pnlLabel = SubtitleLabel()
    private lazy var quantityLabel = SubtitleLabel()
    private lazy var stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        style()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PositionCell {
    
    func setupViews() {
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        [
            tickerLabel,
            companyNameLabel,
            priceLabel,
            pnlLabel,
            quantityLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview($0)
        }
        
        contentView.addSubview(stackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
    
    func style() {
        contentView.backgroundColor = UIColor.systemBackground
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        contentView.clipsToBounds = true
        
        tickerLabel.font = .boldSystemFont(ofSize: 16)
        companyNameLabel.font = .systemFont(ofSize: 14)
        priceLabel.font = .systemFont(ofSize: 14)
        pnlLabel.font = .systemFont(ofSize: 14)
        quantityLabel.font = .systemFont(ofSize: 14)
    }
}

extension PositionCell: ModelUpdateProtocol {
    typealias ModelData = Position
    
    func update(modelData: Position, indexPath: IndexPath) {
        let instrument = modelData.instrument
        tickerLabel.text = "\(instrument.ticker) - \(instrument.currency)"
        companyNameLabel.text = instrument.name
        priceLabel.text = String(format: "Last Price: %.2f", instrument.lastTradedPrice)
        quantityLabel.text = String(format: "Qty: %.2f | Cost: %.2f", modelData.quantity, modelData.cost)
        
        let pnl = modelData.pnl
        pnlLabel.text = String(format: "P&L: %.2f (%.2f%%)", pnl, modelData.pnlPercentage)
        pnlLabel.textColor = pnl >= 0 ? .systemGreen : .systemRed
    }
}
