//
//  testApp.swift
//  test
//
//  Created by rabie houssaini on 23/5/2024.
//

import SwiftUI

@main

struct Crypty: App {
    @StateObject private var vm = HomeViewModel()
    @State private var showLuanchView : Bool = true
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack{
                NavigationView{
                    HomeView().navigationBarHidden(true)
                }.environmentObject(vm)
                
                ZStack{
                    if showLuanchView{
                        LuanchView(showLuanch: $showLuanchView)
                            .transition(.move(edge: .leading))

                    }
                       
                }
                .zIndex(2.0)
                
            }
        }
    }
}
