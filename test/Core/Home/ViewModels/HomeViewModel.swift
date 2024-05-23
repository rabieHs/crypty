//
//  HomeViewModel.swift
//  test
//
//  Created by rabie houssaini on 25/5/2024.
//

import Foundation
import Combine

class HomeViewModel : ObservableObject {
    @Published var  statistics : [StatisticModel] = []
    
    @Published var allCoins : [CoinModel] = []
    @Published var portfolioCoins : [CoinModel] = []
    @Published var searchText:String = ""
    @Published var isLoading : Bool = false
    @Published var sortOption: SortOption = .holdings
    
    
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
    case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init(){
     
            downloadData()
        
    }
    
    
    func downloadData(){
    
        $searchText.combineLatest(coinDataService.$allCoins,$sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] (returnedCoins) in
            self?.allCoins = returnedCoins
        }.store(in: &cancellables)
        
        $allCoins.combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink {[weak self] (returnedCoins) in
                guard let self = self else {return}
            self.portfolioCoins = sortPortfolioCoinsifNeeded(coins: returnedCoins)
        }
        
        .store(in: &cancellables)
        marketDataService.$marketData.combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
            self?.statistics = returnedStats
                self?.isLoading = false
        }.store(in: &cancellables)
        
        
      
    }
    
    func reloadData(){
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(notificationType: .success)
    }
    
    
    func updatePortfolio(coin:CoinModel, amount : Double){
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    
    private func filterAndSortCoins(text:String , coins: [CoinModel],sort: SortOption)->[CoinModel]{
        var filteredCoins = filterCoins(text: text, coins: coins)
        let sortedCoins = sortCoins(sort: sort, coins: filteredCoins)
        return sortedCoins
    }
    
 
    private func sortCoins(sort: SortOption, coins: [CoinModel])->[CoinModel]{
        switch sort {
        case .rank,.holdings:
//            coins.sorted { coin1, coin2 in
//                return coin1.rank < coin2.rank
//            }
            
            return coins.sorted(by: {$0.rank < $1.rank})
            
        case .rankReversed,.holdingsReversed:
            return coins.sorted(by: {$0.rank > $1.rank})
    

        case .price:
            return coins.sorted(by: {$0.currentPrice < $1.currentPrice})

        case .priceReversed:
            return coins.sorted(by: {$0.currentPrice > $1.currentPrice})

        }
        
    }
    
    private func sortPortfolioCoinsifNeeded(coins: [CoinModel])->[CoinModel]{
        switch sortOption {
            
        case .holdings:
            return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingsReversed:
            return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
            
        default: return coins
            
        }}
    
    private func filterCoins(text:String , coins: [CoinModel])->[CoinModel]{
     
            guard !text.isEmpty else {
                return coins
            }
            let lowercasedText = text.lowercased()
            return coins.filter { (coin) in
                return coin.name.lowercased().contains(lowercasedText) || coin.symbol.lowercased().contains(lowercasedText) ||
                coin.id.lowercased().contains(lowercasedText)
            }
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins : [CoinModel], portfolioCoins : [PortfolioEntity])->[CoinModel]{
        allCoins
            .compactMap { (coin)->CoinModel? in
                guard let entity = portfolioCoins.first(where: {$0.coinID == coin.id}) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?,potfolioCoins : [CoinModel])->[StatisticModel]{
        
        var stats : [StatisticModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        
        let portfolioValue =
                   portfolioCoins
                       .map({ $0.currentHoldingsValue })
                       .reduce(0, +)
               
               let previousValue =
                   portfolioCoins
                       .map { (coin) -> Double in
                           let currentValue = coin.currentHoldingsValue
                           let percentChange = coin.priceChangePercentage24H ?? 0 / 100
                           let previousValue = currentValue / (1 + percentChange)
                           return previousValue
                       }
                       .reduce(0, +)

               let percentageChange = ((portfolioValue - previousValue) / previousValue)
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "Dominance", value: data.btcDominance)
        let portfolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
        stats.append(contentsOf: [marketCap, volume,btcDominance, portfolio])
        
        return stats
    }
}
