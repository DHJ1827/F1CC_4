//
//  F1CC_4App.swift
//  F1CC_4
//
//  Created by David Joyce on 2023-03-16.
//
// To do
// Check Recs detail for spacing
// Design recs basic
// Check sliders
// Check on iPhone 13 and iPhone 8
// Check AdMob
// Check calcs
// Check min, max, mid text files
// Check againt Android version

import SwiftUI
import GoogleMobileAds

@main
struct F1CC_4App: App {
    
    @StateObject var db = DBHandler()    //establish state object
    var appDel = AppDelegate()   // instantiate GADMobileAds
    
    
    var body: some Scene {
        
        WindowGroup {
            //MainView()
                //.environmentObject(db)    // allow all files to access db
            SplashScreenView()
                .environmentObject(db)    // allow all files to access db
        }
    }  // scene
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }
    
    
}  //struct
