//
//  CoinDetailDataService.swift
//  test
//
//  Created by rabie houssaini on 4/6/2024.
//

import Foundation
import Combine

class CoinDetailDataService{
    @Published var CoinDetails : CoinDetailModel? = nil
    var coinDetailSubscription : AnyCancellable?
    let coin : CoinModel
    
    init(coin:CoinModel) {
        self.coin = coin
        getCoinsDetails()
    }
    
     func getCoinsDetails(){
         guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else {
            return
        }
         coinDetailSubscription = NetworkingManager.download(url: url).decode(type: CoinDetailModel.self, decoder: JSONDecoder()).sink(receiveCompletion: NetworkingManager.handleCompletion(completion:), receiveValue: { [weak self] (returnedCoinDetails) in
            self?.CoinDetails = returnedCoinDetails
            self?.coinDetailSubscription?.cancel()
        })
    }
}
