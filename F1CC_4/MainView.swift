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
// Fix mid, min and max by changing 10% to 0, not 1
// create app icon
// chjange in PartView ' / ' to '/'
//
// UI
// fix string 1 for Driver and Part: line 42 and 54 for varied spacing depending on string lengths. Ok for min. Try with mid and max. NCo = 0?
// fix Driver display when PC > CL rows. right justify NCa so that NCO is aligned
// fix Part display spacing
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

