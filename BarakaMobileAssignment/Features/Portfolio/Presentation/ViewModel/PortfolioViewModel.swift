//
//  PortfolioViewModel.swift
//  BarakaMobileAssignment
//
//  Created by radha chilamkurthy on 24/09/25.
//
import Foundation
import Combine

protocol PortfolioViewModelProtocol {
    var portfolioPublisher: Published<Portfolio?>.Publisher { get }
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    func fetchPortfolio()
}

class PortfolioViewModel: PortfolioViewModelProtocol {
    @Published private(set) var portfolio: Portfolio?
    @Published private(set) var isLoading: Bool = true
    @Published private(set) var error: Error?
    var portfolioPublisher: Published<Portfolio?>.Publisher { $portfolio }
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    private let repository: PortfolioRepositoryProtocol
    private let livePircesRepository: LivePricesRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    init(
        repository: PortfolioRepositoryProtocol = PortfolioRepository(),
        livePircesRepository: LivePricesRepositoryProtocol = LivePricesRepository()
    ) {
        self.repository = repository
        self.livePircesRepository = livePircesRepository
    }

    func fetchPortfolio() {
        error = nil

        repository.fetchPortfolio(endpoint: .fetch)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let err) = completion {
                    self?.error = err
                }
            } receiveValue: { [weak self] portfolio in
                guard let self else { return }
                self.subscribeToLivePrices(for: portfolio)
            }
            .store(in: &cancellables)
    }
    
    deinit {
        livePircesRepository.stopLiveUpdates()
        cancellables.removeAll()
    }
}

private extension PortfolioViewModel {

    func subscribeToLivePrices(for portfolio: Portfolio) {
        livePircesRepository
            .startLiveUpdates(for: portfolio.positions)
            .sink { [weak self] updatedPositions in
                guard let self = self else { return }

                let balance = self.calculateBalance(from: updatedPositions)
                self.portfolio = Portfolio(
                    balance: balance,
                    positions: updatedPositions
                )
            }
            .store(in: &cancellables)
    }

    func calculateBalance(from positions: [Position]) -> Balance {
        let netValue = positions.map { $0.marketValue }.reduce(0, +)
        let pnl = positions.map { $0.pnl }.reduce(0, +)
        let cost = positions.map { $0.cost }.reduce(0, +)
        let pnlPercentage = cost != 0 ? (pnl * 100 / cost) : 0
        return Balance(
            netValue: netValue.rounded(toPlaces: 2),
            pnl: pnl.rounded(toPlaces: 2),
            pnlPercentage: pnlPercentage.rounded(toPlaces: 2)
        )
    }
}

