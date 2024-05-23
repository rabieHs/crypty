//
//  LuanchView.swift
//  test
//
//  Created by rabie houssaini on 6/6/2024.
//

import SwiftUI

struct LuanchView: View {
    @State private var loadingText : [String] = "Loading Portfolio...".map{String($0)}
    @State private var showLoadingText:Bool = false
    @Binding  var showLuanch:Bool
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var counter : Int = 0
    @State private var loops : Int = 0
    var body: some View {
        ZStack{
            Color.launchBackground
                .ignoresSafeArea()
            Image("logo-transparent")
                .resizable()
                .frame(width: 100,height: 100)
            ZStack{
                if showLoadingText {

                    HStack(spacing:0){
                        ForEach(loadingText.indices) { index in
                            Text(loadingText[index])   
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundColor(Color.launchAccent)
                                .offset(y:counter == index ? -5 : 0)
                        }
                    }
                    .transition(AnyTransition.scale.animation(.easeIn))
                }
               
            }
            .offset(y:70)
        }.onAppear{
            showLoadingText.toggle()
        }
        .onReceive(timer, perform: { _ in
            withAnimation(.spring()){
                let lastIndex = loadingText.count - 1
                if counter == lastIndex {
                    counter = 0
                    loops += 1
                    if loops >= 2 {
                        showLuanch = false
                    }
                }else{
                    counter += 1

                }
                
            }
            
        })
    }
}

#Preview {
    LuanchView(showLuanch: .constant(true))
}
