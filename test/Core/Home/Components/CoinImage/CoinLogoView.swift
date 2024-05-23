//
//  CoinLogoView.swift
//  test
//
//  Created by rabie houssaini on 29/5/2024.
//

import SwiftUI

struct CoinLogoView: View {
    let coin: CoinModel
    var body: some View {
        VStack{
            CoinImageView(coin: coin).frame(width: 50,height: 50)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(.theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(coin.name)
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    CoinLogoView(coin: DeveloperPreview.instance.coin)
}
