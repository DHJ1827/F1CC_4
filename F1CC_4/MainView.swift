//
//  MainView.swift
//  F1CC_4
//
//  Created by David Joyce on 2023-03-16.
//
// TO DO
//
// Code
// Mid/max testing:
// fix STPartRecID, STDriverRecID in teamScore calc in Recs
// - Basic says upgrade Onyx, detail doesn't with CL=PL. Can't upgrade max!
//
// UI
// Driver screen has better spacing for sR2 and sR4
// fill in ios icon
// min driver spacing ok, parts not 0  1/0  0  spacing i bad
//
//Test
// Try min, mid, max. Try driver update, part update, coins, extremes= "",0,9999999,2,345,etc. Slider extremes. Check translations with F1 Clash app.
// Analyze calcs, including teamScore
// Check on iPhone 13 and iPhone 8
// Check AdMob
// Check against Android version
// Test: Check for errors and for UI changes for each language. 0 a driver, 0 a part, max a driver, max a part, 0 coins, 100M coins, 0 cards, 100M cards, max a driver/part with 0 cards, max a driver/part with 0 coins, all 0s, slide driver filters to see if CR changes,
//
// Future
// add commas (or . for localization) to Ca and Co for better readibility
// add 10% to drivers when boosted and add up arrow to Recs Detailed drivers when upgrade needed
// when a driver 10% is checked, need to check/unlock the other colours of that same driver- tough

// To print array
// db.sDriver.forEach{print($0)}

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
        .ignoresSafeArea(edges: .top)
        .statusBar(hidden: true)
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

