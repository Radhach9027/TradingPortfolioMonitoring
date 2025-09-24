//
//  PortFolioViewController.swift
//  BarakaMobileAssignment
//
//  Created by radha chilamkurthy on 24/09/25.
//

import UIKit
import Combine

class PortfolioViewController: UIViewController {
    private var viewModel: PortfolioViewModelProtocol
    private var collection: GenericCollectionViewController!
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: PortfolioViewModelProtocol = PortfolioViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Baraka Portfolio"
        bindViewModel()
        viewModel.fetchPortfolio()
    }
}

private extension PortfolioViewController {
    
    func makeGroupedModel(from model: Portfolio?) -> GroupedModel {
        let models = ConfigureCollectionsModel<PositionCell>(
            modelData: model?.positions
        )
        let groupedModel = GroupedModel(
            section: 0,
            rows: model?.positions.count ?? 0,
            bundle: Bundle.main,
            customCell: models
        )
        return groupedModel
    }
    
    func setupCollectionView() {
        let groupedCell = makeGroupedModel(from: nil)
        let groupedData = [0: [groupedCell]]
        collection = GenericCollectionViewController(
            grouped: groupedData,
            layout: .postionsCompostionalLayout,
            cellForItem: { cell, indexPath in
                print("cell Rolling at \(indexPath)")
            },
            didSelectItem: { cell, indexPath in
                print("Selected portfolio item at \(indexPath)")
            }
        )
        
        addChild(collection)
        view.addSubview(collection.view)
        collection.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collection.view.topAnchor.constraint(equalTo: view.topAnchor),
            collection.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collection.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collection.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        collection.didMove(toParent: self)
    }
    
    func bindViewModel() {
        viewModel.portfolioPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] portfolio in
                guard let self = self, let portfolio = portfolio else { return }
                let groupedCell = makeGroupedModel(from: portfolio)
                let groupedData = [0: [groupedCell]]
                self.collection.reloadData(with: groupedData)
            }
            .store(in: &cancellables)
        
        viewModel.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
              self?.collection.setLoading(isLoading)
            }
            .store(in: &cancellables)
        
        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }
            .store(in: &cancellables)
    }
}
