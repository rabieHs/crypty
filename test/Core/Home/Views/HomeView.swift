//
//  HomeView.swift
//  test
//
//  Created by rabie houssaini on 23/5/2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortfolio:Bool = false
    @State private var showProfolioView : Bool = false
    @State private var selectedCoin : CoinModel? = nil
    @State private var showDetailsView : Bool = false
    @State private var showSettingView : Bool = false
    var body: some View {
        ZStack {
            //background layer
            Color.theme.background.ignoresSafeArea()
                .sheet(isPresented: $showProfolioView, content: {
                    PortfolioView().environmentObject(vm)
                })
            
            //content layer
            VStack{
              homeHeader
            
                HomeStatsView(showPortfolio: $showPortfolio)
              
                SearchBarView(searchText: $vm.searchText)

               columnTitles
                
                
                if !showPortfolio{
                 allCoinsList .transition(.move(edge: .leading))
                }
                if showPortfolio {
                    portfolioCoinsList.transition(.move(edge: .trailing))
                }
               
            }.sheet(isPresented: $showSettingView, content: {
                SettingsView()
            })
        }.background(
            NavigationLink(isActive: $showDetailsView,
                           destination: {
                DetailsLoadingView(coin: $selectedCoin)
            }, label: {
                EmptyView()
            }))
    }
}

#Preview {
    NavigationView{
        HomeView().navigationBarHidden(true)
       
    }.environmentObject(DeveloperPreview.instance.homeVM)//.preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}

extension HomeView {
    
    private var homeHeader : some View {
        HStack{
            CircleButtonView(iconName:showPortfolio ? "plus" :"info").onTapGesture {
                if showPortfolio{
                    showProfolioView.toggle()
                }else{
                    showSettingView.toggle()
                }
            }
                .background(
                CircleButtonAnimationView(animate: $showPortfolio)
            )
            
            Spacer()
            Text(showPortfolio ? "Show Portfolio": "Live Prices").animation(.none).font(.headline).fontWeight(.heavy).foregroundColor(Color.theme.accent)
            
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0)).onTapGesture {
                withAnimation(.spring()){
                    showPortfolio.toggle()
                    
                }
            }
        }.padding(.horizontal)
    }
    
    private func navigate(coin:CoinModel){
        selectedCoin = coin
        showDetailsView.toggle()
    }
    
    private var allCoinsList : some View {
        List{
            ForEach(vm.allCoins) {coin in
                CoinRowView(coin: coin, showHoldingColumn: false).listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10)).onTapGesture {
                    navigate(coin: coin)
                }
            }
            }
        .listStyle(PlainListStyle())
        
    }
    
    private var portfolioCoinsList : some View {
        List{
            ForEach(vm.portfolioCoins) {coin in
                CoinRowView(coin: coin, showHoldingColumn: true).listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10)).onTapGesture {
                    navigate(coin: coin)
                }
            }
        }.listStyle(PlainListStyle())
        
    }
    
    
    
    private var columnTitles : some View {
        HStack{
            HStack(spacing: 4){
                Text("Coin")
                Image(systemName: "chevron.down").opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1.0 : 0.0).rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }.onTapGesture {
                withAnimation(.default){
                    if vm.sortOption == .rank {
                        vm.sortOption = .rankReversed
                    }else{
                        vm.sortOption = .rank
                    }

                }            }
            Spacer()
            if showPortfolio{
                HStack(spacing: 4){
                    Text("Holdings")
                    Image(systemName: "chevron.down").opacity((vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1.0 : 0.0).rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
                }.onTapGesture {
                    withAnimation(.default){
                        if vm.sortOption == .holdings {
                            vm.sortOption = .holdingsReversed
                        }else{
                            vm.sortOption = .holdings
                        }
                    }
                    }
            }
            HStack(spacing: 4){
                Text("Price")
                Image(systemName: "chevron.down").opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1.0 : 0.0).rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
            }.frame(width: UIScreen.main.bounds.width / 3.5 , alignment: .trailing).onTapGesture {
                withAnimation(.default){
                    if vm.sortOption == .price {
                        vm.sortOption = .priceReversed
                    }else{
                        vm.sortOption = .price
                    }
                }
            }
           
            
            Button {
                withAnimation(.linear(duration: 2)){
                    vm.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
            }.rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor:.center)

        }.font(.caption).foregroundColor(.theme.secondaryText).padding(.horizontal)
    }
    
    
}
