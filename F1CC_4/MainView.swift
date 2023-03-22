//
//  MainView.swift
//  F1CC_4
//
//  Created by David Joyce on 2023-03-16.
//
// TO DO
// Check Recs detail
//    - fix string 0 for Driver and Part: line 42 and 54 for varied spacing depending on string lengths. Ok for min. Try with mid and max. NCo = 0?
//    - fix string 1 for Driver and Part: line 42 and 54 for varied spacing depending on string lengths. Ok for min. Try with mid and max. NCo = 0?
//    - add section breaks/titles
//    - add ST/MT/LT to all details margins
//    - add Team Score??
//
// Check on iPhone 13 and iPhone 8
// Check AdMob
// Check calcs
// Check min, max, mid text files
// Check against Android version
// need consistent font and colours for headings and titles throughout
//      - design recs basic. Add team score to Recs?
// create page logos for bottom icons, remove names, remove Test
// create app icon


import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var db: DBHandler    // use db

    var body: some View {
        
        TabView {
            DriverView()
                .environmentObject(db)
                .tabItem {
                    Label("Driver", systemImage: "globe")
                }
            
            CarView()
                .environmentObject(db)
                .tabItem {
                    Label("Car", systemImage: "command")
                }
            
            RecsView()
                .environmentObject(db)
                .tabItem {
                    Label("Recs", systemImage: "list.dash")
                }
            
            TestView()
                .environmentObject(db)
                .tabItem {
                    Label("Test", systemImage: "list.dash")
                }
        }
        .onAppear(perform: start)
    }
    
    func start() {
        //print("!! MV start()...")
    }
}



struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello preview")
        
    }
}

