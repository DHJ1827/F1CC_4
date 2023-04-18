//
//  MainView.swift
//  F1CC_4
//
//  Created by David Joyce on 2023-03-16.
//
// TO DO
//
// Fix
// Analyze calcs, including teamScore.
// On Recs, move basic/detail left and legend to right. divide legend for better readibility
// add + and - to sliders// fill in ios icon
//
// UI
// fix strings 0-2 with min, mid and max. NCo = 0?
// RecsDisp are messed up when translated (Name, CL, CR....ACo) and (PL, PR, MR...NCo)
// add new picts
//
// Checks
// Check on iPhone 13 and iPhone 8
// Check AdMob
// Check calcs
// Check min, max, mid text files
// Check against Android version
// Test: Check for errors and for UI changes for each language. 0 a driver, 0 a part, max a driver, max a part, 0 coins, 100M coins, 0 cards, 100M cards, max a driver/part with 0 cards, max a driver/part with 0 coins, all 0s, slide driver filters to see if CR changes,

// Future
// add commas (or . for localization) to Ca and Co for better readibility



import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var db: DBHandler    // use db

    init() {
    UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    var body: some View {
        
        TabView {
            DriverView()
                .environmentObject(db)
                .tabItem {
                    Label("", systemImage: "person.3")
                        .foregroundColor(.blue)
                }
            
            CarView()
                .environmentObject(db)
                .tabItem {
                    Label("", systemImage: "wrench.and.screwdriver.fill")
                        .foregroundColor(.blue)
                }
            
            RecsView()
                .environmentObject(db)
                .tabItem {
                    Label("", systemImage: "checkerboard.rectangle")
                        .foregroundColor(.blue)
                }
            
//            TestView()
//                .environmentObject(db)
//                .tabItem {
//                    Label("Test", systemImage: "list.dash")
//                }
        }
        .accentColor(.colours.backgrd_blue)
        //.toolbarBackground(Color.white)
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

