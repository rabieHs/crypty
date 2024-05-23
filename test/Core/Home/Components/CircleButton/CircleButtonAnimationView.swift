//
//  CircleButtonAnimationView.swift
//  test
//
//  Created by rabie houssaini on 23/5/2024.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    @Binding  var animate: Bool

    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1.0 : 0.0).opacity(animate ? 0.0 : 1.0)
            .animation(animate ? Animation.easeInOut(duration: 1.0): .none )
        
    }
}

#Preview {
    CircleButtonAnimationView(animate: .constant(false)).frame(width: 20,height: 20).foregroundColor(.red).previewLayout(.sizeThatFits)
}
