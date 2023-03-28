//
//  MainView.swift
//  F1CC_4
//
//  Created by David Joyce on 2023-03-16.
//
// TO DO
// Check Recs detail
//    - design recs basic and details- try mid so that there's some possible upgrades to drivers and parts. Also fix spacing for various scenarios
//    - fix string 1 for Driver and Part: line 42 and 54 for varied spacing depending on string lengths. Ok for min. Try with mid and max. NCo = 0?
//    - add Team Score- use CR or PR sum for all ST drivers and parts
//    - fix Driver display when PC > CL rows. right justify NBCa so that NCO is aligned
//    - fix Part display spacing

// Fix mid, min and max by changing 10% to 0, not 1
// Check on iPhone 13 and iPhone 8
// Check AdMob
// Check calcs
// Check min, max, mid text files
// Check against Android version
// need consistent font and colours for headings and titles throughout
//      - design recs basic. Add team score to Recs?
// create app icon


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
        //print("!! MV start()...")
    }
}



struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello preview")
        
    }
}

