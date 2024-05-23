//
//  CoinRowView.swift
//  test
//
//  Created by rabie houssaini on 24/5/2024.
//

import SwiftUI

struct CoinRowView: View {
    let coin : CoinModel
    let showHoldingColumn : Bool
    var body: some View {
        HStack(spacing: 0, content: {
           leftColumn
            Spacer()
            if showHoldingColumn {
            centerColumn
            }
          
               rightColumn
            
        }).font(.subheadline).background(Color.theme.background.opacity(0.001))
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    Group{
        CoinRowView(coin:DeveloperPreview.instance.coin , showHoldingColumn: true )
        
        CoinRowView(coin:DeveloperPreview.instance.coin , showHoldingColumn: true )
    }
}

extension CoinRowView {
    private var leftColumn : some View {
        HStack(spacing: 0) {
            Text("\(coin.rank)").font(.caption).foregroundColor(.theme.secondaryText).frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30,height: 30)
            
            Text(coin.symbol.uppercased() ?? "btc").font(.headline).padding(.leading,6).foregroundColor(.theme.accent)
        }
    }
    
    private var centerColumn : some View {
        VStack(alignment:.trailing){
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals()).bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
        }.foregroundColor(.theme.accent)
    }
    
    private var rightColumn : some View {
        VStack(alignment: .trailing, content: {
            Text((coin.currentPrice.asCurrencyWith2Decimals() ?? "")).bold().foregroundColor(.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "" ).foregroundColor((coin.priceChangePercentage24H ?? 0) >= 0 ? .green : .red)
        }).frame(width: UIScreen.main.bounds.width / 3.5 , alignment: .trailing)
    }
}
