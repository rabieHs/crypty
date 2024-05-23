//
//  SettingsView.swift
//  test
//
//  Created by rabie houssaini on 6/6/2024.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    let GithubURL = URL(string: "https://github.com/rabieHs")!
    let linkedinURL = URL(string: "https://www.linkedin.com/in/rabi3hs/")!
    var body: some View {
        NavigationView(content: {
            List{
                aboutSection
            }
            .font(.headline)
            .accentColor(.blue)
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Image(systemName: "xmark")
                                .font(.headline)
                                })
                    }
                })
        })
    }
}

#Preview {
    SettingsView()
}

extension SettingsView{
    
    private var aboutSection : some View {
        Section(header: Text("About Crypty")) {
            VStack(alignment: .leading, content: {
                Image("logo")
                    .resizable()
                    .frame(width: 100,height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was made by Rabie houssaini at @SwiftfulThinking")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.theme.accent)
            }).padding(.vertical)
            
            Link("Github Account", destination: GithubURL)
            Link("Linkedin Account", destination: linkedinURL)
        }
    }
}
