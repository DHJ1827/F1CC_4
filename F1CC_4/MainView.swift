//
//  MainView.swift
//  F1CC_4
//
//  Created by David Joyce on 2023-03-16.
//
// TO DO
//
// Fix
// calcs, including teamScore are all mixed up!
//
//
// UI
// fix strings 0-2 with min, mid and max. NCo = 0?
// spacing on parts string 3. rj alignment of PL column in German is offset, is Aero and Grip translated?
//
// Checks
// Check on iPhone 13 and iPhone 8
// Check AdMob
// Check calcs
// Check min, max, mid text files
// Check against Android version



import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var db: DBHandler    // use db

    var body: some View {
        
        TabView {
            DriverView()
                .environmentObject(db)
                .tabItem {
                    Label("", systemImage: "steeringwheel")
                        .foregroundColor(.black)
                }
            
            CarView()
                .environmentObject(db)
                .tabItem {
                    Label("", systemImage: "wrench.and.screwdriver")
                }
            
            RecsView()
                .environmentObject(db)
                .tabItem {
                    Label("", systemImage: "flag.checkered")
                }
            
//            TestView()
//                .environmentObject(db)
//                .tabItem {
//                    Label("Test", systemImage: "list.dash")
//                }
        }
        .accentColor(.colours.backgrd_blue)
        .toolbarBackground(Color.white)
        .onAppear(perform: start)
    }
    
    func start() {
        print("!! MV start()...")
    }
}



struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello preview")
        
    }
}

