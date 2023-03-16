//
//  MainView.swift
//  F1CC_4
//
//  Created by David Joyce on 2023-03-16.
//

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

