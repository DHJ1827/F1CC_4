//
//  SplashScreenView.swift
//  F1CC_4
//
//  Created by David Joyce on 2023-03-16.
//

import SwiftUI



struct SplashScreenView: View {
    @EnvironmentObject var db: DBHandler
    
    @State private var isSplashActive = false
    @State private var size = 0.7
    @State private var opacity = 0.5
    
    var body: some View {
        if (isSplashActive) {
            MainView()
        } else {
            ZStack {
                Color.colours.backgrd_blue
                    .ignoresSafeArea()
                VStack {
                    VStack {
                        Text("F1 Clash Companion")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.size = 0.9
                            self.opacity = 1.00
                        }
                    }
                }
                
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.isSplashActive = true
                    }
                }
            }
            
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}

