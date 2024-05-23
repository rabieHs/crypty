//
//  PortfolioView.swift
//  test
//
//  Created by rabie houssaini on 29/5/2024.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject private var vm : HomeViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedCoin : CoinModel? = nil
    @State private var quantityText = ""
    @State private var showCheckmark : Bool = false
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment:.leading,spacing: 0) {
                    SearchBarView(searchText: $vm.searchText)
                   coinLogoList
                    if selectedCoin != nil {
                  portfolioInputSection
                    }
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    XmarkButton(dismiss: _dismiss)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                  trailingNavBarButton
                }
            })
            .onChange(of: vm.searchText) { value in
                if value == ""{
                    removeSelectedCoin()

                }
            }
                                  
                
        }
    }
}

#Preview {
    PortfolioView().environmentObject(DeveloperPreview.instance.homeVM)
}

extension PortfolioView {
    
    private var coinLogoList : some View {
        ScrollView(.horizontal,showsIndicators: true, content: {
            LazyHStack(spacing:10){
                ForEach(vm.allCoins){coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 1).foregroundColor(selectedCoin?.id == coin.id ? .theme.green : Color.clear))
                }
            }.frame(height: 150)
                .padding(.leading)
        })
    }
    
    private func updateSelectedCoin(coin:CoinModel){
        selectedCoin = coin
        if   let portfolioCoin = vm.portfolioCoins.first(where: {$0.id == coin.id}){
            let amount  = portfolioCoin.currentHoldings
            quantityText = "\(amount ?? 0)"
            
            
        }else{
            quantityText = ""
        }
        
        

    }
    
    private var portfolioInputSection : some View {
        VStack(spacing: 20, content: {
            HStack{
                Text("Current Price of \(selectedCoin?.symbol.uppercased() ?? ""): ")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack{
                Text("Amount holding:")
                Spacer()
                TextField("EX: 1.4",text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack{
                Text("Current Value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }).animation(.none)
            .padding()
            .font(.headline)
    }
    
    private var trailingNavBarButton :some View {
        HStack{
            Image(systemName: "checkmark").opacity(showCheckmark ? 1.0 : 0.0)
            Button(action: {
                saveButtonPressed()
            }, label: {
                Text("save".uppercased())
            }).opacity((selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1.0 : 0
            )
        }.font(.headline)
    }
    
    private func getCurrentValue()->Double{
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0 )
        }
        return 0
        
    }
    
    private func saveButtonPressed(){
        guard let coin = selectedCoin, let amount = Double(quantityText) else {return}
        
        // save to portfolio
        
        vm.updatePortfolio(coin: coin, amount: amount)
        
        //show checkmark
        
        withAnimation(.easeIn) {
            showCheckmark = true
            removeSelectedCoin()
        }
        UIApplication.shared.endEditing()
        
        // hide checkmark
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute:{
            withAnimation(.easeOut){
                showCheckmark = false
            }
        })
    }
    
    private func removeSelectedCoin(){
        selectedCoin = nil
        vm.searchText = ""
    }
    

}
