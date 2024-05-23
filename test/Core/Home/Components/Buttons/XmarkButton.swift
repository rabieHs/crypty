//
//  XmarkButton.swift
//  test
//
//  Created by rabie houssaini on 29/5/2024.
//

import SwiftUI

struct XmarkButton: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button(action: {
dismiss()
}, label: {
Image(systemName: "xmark").font(.headline)
})
    }
}

#Preview {
    XmarkButton()
}
