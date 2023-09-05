//
//  MainView.swift
//  F1CC_4
//
//  Created by David Joyce on 2023-03-16.
//
// TO DO
//
// Code
// figure out if rear wing is first or front wing is in cars, update, recs, etc.
// detailed Recs- sr4 spacing when NCa and NCo are 0 vs when sR4 is multiline and NCa is larger
// add space to RSide of factor when PL value is < 10 ie. right justify just like LH is already- or is this  already done?!
// fix team score calcs
// 
//
// Translations
// sR1 and sR4 spacing in driver, car, recs
//
// UI
// adjusr spacing in driver update LH column for Level Check pasrt update as well for same spacing issue?
// Team score in Fr is missing
// fill in ios icon
//
//Test
// LAST: check all screens for translations
// check all buttons for good/bad input eg. 0, -2, 6,000, HJU, 3.2, 4,567,892,332, etc.
// check all drivers, parts= 0
// Try min, mid, max. Try driver update, part update, coins, extremes= "",0,9999999,2,345,etc. Slider extremes. Check translations with F1 Clash app.
// Check all screens for long strings- with long names, ACa, NCa, ACo, NCo
// Analyze calcs, including teamScore and against Android version
// Check when CL is max, what to do with NCa, NCo
// Check on iPhone 13 and iPhone 8
// Check AdMob
// Test: Check for errors and for UI changes for each language. 0 a driver, 0 a part, max a driver, max a part, 0 coins, 100M coins, 0 cards, 100M cards, max a driver/part with 0 cards, max a driver/part with 0 coins, all 0s, slide driver filters to see if CR changes,
//
// Future
// add commas (or . for localization) to Ca and Co for better readibility
// add 10% to drivers when boosted and add up arrow to Recs Detailed drivers when upgrade needed
// when a driver 10% is checked, need to check/unlock the other colours of that same driver- tough
// change tabview icons to android
// To print array: db.sDriver.forEach{print($0)}

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

