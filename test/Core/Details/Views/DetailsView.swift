//
//  DetailsView.swift
//  test
//
//  Created by rabie houssaini on 3/6/2024.
//

import SwiftUI

struct DetailsLoadingView : View {
    @Binding var  coin: CoinModel?
    

    var body: some View {
        ZStack{
            if let coin = coin {
                DetailsView(coin: coin)
            }
        }
    }
}

struct DetailsView: View {
    
    @StateObject private var vm: CoinDetailsViewModel
    @State private var showFullDescription : Bool = false
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    
    ]
    
    private let spacing: CGFloat = 30

    
    init(coin: CoinModel) {
        //self.coin = coin
        _vm = StateObject(wrappedValue: CoinDetailsViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView{
            VStack{
                ChartView(coin: vm.coin).padding(.vertical)
                
                
                VStack(spacing: 20){
                    overViewtitle
                    Divider()
                    descriptionSection

                    overViewGrid
                    additionalViewtitle
                    
                    Divider()
                    
                    additionalViewGrid
                    linksSection
                   
                    
                    
                } .padding()
        
            }
           
        }
        .navigationTitle(vm.coin.name).toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
              navigationBarTrailingItems
            }
        })
    }
}

#Preview {
    NavigationView{
        DetailsView(coin:DeveloperPreview.instance.coin)

    }
}

extension DetailsView {
    
    private var navigationBarTrailingItems: some View{
        HStack {
            
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
            .foregroundColor(.theme.secondaryText)
            CoinImageView(coin: vm.coin).frame(width: 25,height: 25)
        }
    }
    
    private var overViewtitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .frame(maxWidth: .infinity,alignment: .leading)
    }
    
    private var additionalViewtitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .frame(maxWidth: .infinity,alignment: .leading)
    }
    
    private var overViewGrid: some View {
        LazyVGrid(columns: columns, spacing: spacing, content: {
            ForEach(vm.overviewStatistics) {stat in
                StatisticView(stat: stat)
            }
        })
    }
    
    private var additionalViewGrid: some View {
        LazyVGrid(columns: columns, spacing: spacing, content: {
            ForEach(vm.additionalStatistics) { stat in
                StatisticView(stat: stat)
            }
        })
    }
    
    private var descriptionSection: some View {
        ZStack{
            if let coinDescription = vm.coinDescription , !coinDescription.isEmpty{
                VStack(alignment:.leading){
                    Text(coinDescription.removingHTMLOccurances).lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(.theme.secondaryText)
                    
                    Button(action: {
                        withAnimation(.easeInOut){
                            showFullDescription.toggle()
                        }
                    }, label: {
                        Text(showFullDescription ? "Show Less" : "Read More...")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical,2)
                        
                    })
                    .accentColor(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var linksSection : some View {
        VStack(alignment:.leading,spacing: 10){
            
            
            if let urlString = vm.websiteURL, let url = URL(string: urlString){
                Link("Website", destination: url)
            }
            
            if let redditString = vm.redditURL, let url = URL(string: redditString){
                Link("Reddit", destination: url)
            }
        }.accentColor(.blue)
            .frame(maxWidth: .infinity,alignment: .leading)
            .font(.headline)
    }
    
}
