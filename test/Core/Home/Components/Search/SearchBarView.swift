//
//  SearchBarView.swift
//  test
//
//  Created by rabie houssaini on 26/5/2024.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText:String
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .foregroundColor(searchText.isEmpty ? .theme.secondaryText : .theme.accent)
            TextField("Search by Name or Symbol...", text:$searchText).disableAutocorrection(true)
                .foregroundColor(.theme.accent).overlay(
                    Image(systemName: "xmark.circle.fill").padding().offset(x:10)
                    .foregroundColor(.theme.accent)
                    .opacity(searchText.isEmpty ? 0.0 : 1.0)
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                        searchText = ""
                    },
                    alignment: .trailing
                
                )
        }.font(.headline).padding().background(RoundedRectangle(cornerRadius: 25)
            .fill(Color.theme.background)
            .shadow(color: Color.theme.accent.opacity(0.15),radius: 10))
        .padding()
    }
}

#Preview {
    SearchBarView(searchText: .constant(""))
}
