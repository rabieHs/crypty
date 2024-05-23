//
//  CoinImageServices.swift
//  test
//
//  Created by rabie houssaini on 26/5/2024.
//

import Foundation
import SwiftUI
import Combine
class CoinImageServices{
    @Published   var image : UIImage? = nil
    private  var imageSubscription : AnyCancellable?
    private let coin: CoinModel
    private let fileManager = LocaleFileManager.instance
    private let coinFolderName = "coin_images"
    private let imageName : String

    init(Coin: CoinModel){
        self.coin = Coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage(){
        if let savedImage =  fileManager.getImage(imageName: coin.id, folderName: coinFolderName) {
            image = savedImage
            
        }else{
            downloadCoinImage()
        }
    }
    private func downloadCoinImage(){
        guard let url = URL(string: coin.image) else {
            return
        }
        imageSubscription = NetworkingManager.download(url: url).tryMap({ (data)->UIImage? in
            UIImage(data: data)
        })
            .sink(receiveCompletion: NetworkingManager.handleCompletion(completion:), receiveValue: { [weak self] (returnedImage) in
                guard let self = self , let downloadedImage = returnedImage else {return}
            self.image = returnedImage
            self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage, ImageName: self.imageName, folderName: self.coinFolderName)
                
        })
        
    }
    
}
