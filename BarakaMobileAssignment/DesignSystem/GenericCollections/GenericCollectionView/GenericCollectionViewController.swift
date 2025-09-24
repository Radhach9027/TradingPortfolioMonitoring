//
//  GenericCollectionViewController.swift
//  BarakaMobileAssignment
//
//  Created by radha chilamkurthy on 24/09/25.
//

import UIKit

class GenericCollectionViewController: UICollectionViewController {
    private(set) var grouped: [Int: [GroupedModel]]?
    private(set) var layout: UICollectionViewCompositionalLayout
    private let cellForItem: (UICollectionViewCell, IndexPath) -> Void
    private let didSelectItem: (UICollectionViewCell, IndexPath) -> Void
    private var loadingIndicator: UIActivityIndicatorView?

    init(
        grouped: [Int: [GroupedModel]]?,
        layout: UICollectionViewCompositionalLayout,
        cellForItem: @escaping (UICollectionViewCell, IndexPath) -> Void,
        didSelectItem: @escaping (UICollectionViewCell, IndexPath) -> Void
    ) {
        self.grouped = grouped
        self.cellForItem = cellForItem
        self.didSelectItem = didSelectItem
        self.layout = layout
        super.init(collectionViewLayout: layout)
        registerCellsAndSupplementaryViews()
        configureCollectionView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("GenericCollectionViewController deinitialized")
    }
}

extension GenericCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return grouped?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return grouped?[section]?.first?.rows ?? 0
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if let customCell = grouped?.filter({ $0.key == indexPath.section }).first?.value.first?.customCell {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: customCell.reuseIdentifier,
                for: indexPath
            )
            customCell.update(
                cell: cell,
                indexPath: indexPath
            )
            cellForItem(cell, indexPath)
            return cell
            
        } else {
            let defaultCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "DefaultCell",
                for: indexPath
            )
            cellForItem(defaultCell, indexPath)
            return defaultCell
        }
    }
}

extension GenericCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        didSelectItem(cell, indexPath)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension GenericCollectionViewController {
    
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = true
        collectionView.accessibilityIdentifier = "GenericCollectionViewController"
    }
    
    func registerCellsAndSupplementaryViews() {
        guard let grouped = grouped else { return }
        
        for (_, models) in grouped {
            for model in models {
                if let cell = model.customCell {
                    let reuseIdentifier = cell.reuseIdentifier
                    if let nibPath = model.bundle.path(forResource: reuseIdentifier, ofType: "nib"),
                       FileManager.default.fileExists(atPath: nibPath) {
                        collectionView.register(
                            UINib(nibName: reuseIdentifier, bundle: model.bundle),
                            forCellWithReuseIdentifier: reuseIdentifier
                        )
                    } else if let cellClass = NSClassFromString(Bundle.main.namespace + "." + reuseIdentifier) as? UICollectionViewCell.Type {
                        collectionView.register(cellClass, forCellWithReuseIdentifier: reuseIdentifier)
                    } else {
                        assertionFailure("❌ Could not find class with name \(reuseIdentifier)")
                    }
                } else {
                    collectionView.register(
                        UICollectionViewCell.self,
                        forCellWithReuseIdentifier: "DefaultCell"
                    )
                }
            }
        }
    }
    
    func reloadData(with grouped: [Int: [GroupedModel]]?) {
        let reload = { [weak self] in
            self?.grouped = grouped
            self?.collectionView.reloadData()
        }
        if Thread.isMainThread {
            reload()
        } else {
            DispatchQueue.main.async(execute: reload)
        }
    }
    
    func setLoading(_ isLoading: Bool) {
        let updateUI = { [weak self] in
            guard let self = self else { return }
            
            if isLoading {
                if loadingIndicator == nil {
                    loadingIndicator = UIActivityIndicatorView.loadingIndicator
                }
                collectionView.backgroundView = loadingIndicator
                loadingIndicator?.startAnimating()
            } else {
                loadingIndicator?.stopAnimating()
                collectionView.backgroundView = nil
                loadingIndicator = nil
            }
        }
        
        if Thread.isMainThread {
            updateUI()
        } else {
            DispatchQueue.main.async(execute: updateUI)
        }
    }
}
