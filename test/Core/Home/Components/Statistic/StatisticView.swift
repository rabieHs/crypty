//
//  StatisticView.swift
//  test
//
//  Created by rabie houssaini on 28/5/2024.
//

import SwiftUI

struct StatisticView: View {
    let stat : StatisticModel
    var body: some View {
        VStack(alignment:.leading, spacing: 4) {
            Text(stat.title)
                .font(.caption).foregroundColor(.theme.secondaryText)
            Text(stat.value)
                .font(.headline)
                .foregroundColor(.theme.accent)
            HStack(spacing:4) {
                Image(systemName: "triangle.fill")
                    .font(.caption)
                    .rotationEffect(Angle(degrees: (stat.percentageChange ?? 0) >= 0 ? 0 : 180))
                
                Text(stat.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                .bold()
            }.foregroundColor((stat.percentageChange ?? 0) >= 0 ? .theme.green : .theme.red).opacity(stat.percentageChange == nil ? 0 : 1.0)
            
        }
    }
}

#Preview {
    StatisticView(stat: DeveloperPreview.instance.stat1)
}
