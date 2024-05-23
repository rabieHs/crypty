//
//  CircleButtonView.swift
//  test
//
//  Created by rabie houssaini on 23/5/2024.
//

import SwiftUI

struct CircleButtonView: View {
    let iconName :String
    
    var body: some View {
        Image(systemName: iconName).font(.headline).foregroundColor(Color.theme.accent).frame(width: 50,height: 50).background( Circle().foregroundColor(Color.theme.background).opacity(0.2)).shadow(color: Color.theme.accent, radius: 10).padding()
    }
}

#Preview {
    CircleButtonView(iconName: "info").previewLayout(.sizeThatFits)
}
