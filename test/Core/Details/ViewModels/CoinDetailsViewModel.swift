//
//  CoinDetailsViewModel.swift
//  test
//
//  Created by rabie houssaini on 4/6/2024.
//

import Foundation
import Combine
class CoinDetailsViewModel: ObservableObject {
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    
    
    @Published var coin: CoinModel
    private let coinDetailsService :CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    
    
    init(coin : CoinModel){
        self.coin = coin
        self.coinDetailsService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }
    
    
    private func addSubscribers(){
        coinDetailsService.$CoinDetails.combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self](returnedArrays) in
                self?.overviewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additional
        
        }.store(in: &cancellables)
        
        coinDetailsService.$CoinDetails.sink {  [weak self](returnedCoinDetail) in
            self?.coinDescription = returnedCoinDetail?.readableDescription
            self?.websiteURL = returnedCoinDetail?.links?.homepage?.first
            self?.redditURL = returnedCoinDetail?.links?.subredditURL
        }.store(in: &cancellables)
    }
    
    
    
    
    
    
    
    private func mapDataToStatistics(coinDetailModel : CoinDetailModel?, coinModel : CoinModel)-> (overview: [StatisticModel] , additional: [StatisticModel] ){
 
        
        let overviewArray = createOverViewArray(coinModel: coinModel)
        let additionalArray = createAdditionalArray(coinDetailModel: coinDetailModel, coinModel: coinModel)
        return (overviewArray,additionalArray)
    }
    
    func createOverViewArray(coinModel: CoinModel)->[StatisticModel]{
        
        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price,percentageChange: pricePercentChange)
        
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentageChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Cap", value: marketCap,percentageChange: marketCapPercentageChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        let overviewArray:[StatisticModel] = [
        priceStat, marketCapStat, rankStat, volumeStat
        ]
        
        return overviewArray
    }
    
    func createAdditionalArray(coinDetailModel: CoinDetailModel?, coinModel: CoinModel)->[StatisticModel]{
        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let hightStat = StatisticModel(title: "25h High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = StatisticModel(title: "24h Low", value: low)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentChnage = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Market Cap Change", value: priceChange,percentageChange: pricePercentChnage)
        
        
        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapChangePrcentage = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange,percentageChange: marketCapChangePrcentage)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray : [StatisticModel] = [
        hightStat, lowStat, priceChangeStat , marketCapChangeStat, blockStat, hashingStat
        ]
        
        return additionalArray    }
}
