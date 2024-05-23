//
//  HomeStatsView.swift
//  test
//
//  Created by rabie houssaini on 28/5/2024.
//

import SwiftUI

struct HomeStatsView: View {
  
    @Binding var showPortfolio : Bool
    @EnvironmentObject private var vm : HomeViewModel
    var body: some View {
        HStack{
            ForEach(vm.statistics) { stat in
                StatisticView(stat: stat).frame(width:UIScreen.main.bounds.width / 3)
            }
        }.frame(width: UIScreen.main.bounds.width,alignment: showPortfolio ? .trailing : .leading)
    }
}

#Preview {
    HomeStatsView(showPortfolio: .constant(false)).environmentObject(DeveloperPreview.instance.homeVM)
    
}
