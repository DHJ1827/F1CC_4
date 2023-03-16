//
//  Interdtitial.swift
//  F1CC_4
//
//  Created by David Joyce on 2023-03-16.
//

import Foundation
import SwiftUI
import GoogleMobileAds

class Interstitial : NSObject,GADFullScreenContentDelegate{
   
    var interstitial : GADInterstitialAd = GADInterstitialAd.init()
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad dismissed")
        loadInterstitial()
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print(error.localizedDescription)
    }
        
    let adUnitID: String = "ca-app-pub-3940256099942544/4411468910"
    
    override init() {
        super.init()
        loadInterstitial()
    }
    
    func loadInterstitial(){
        let request = GADRequest()
        
        GADInterstitialAd.load(withAdUnitID: adUnitID, request: request) { (ad, err) in
            if(err !=  nil){
                print(String(describing:err?.localizedDescription))
            }
            else{
            //You can show straight away if you want
            // My use case was using a Button
//                self.showAd()
                self.interstitial = ad!
                self.interstitial.fullScreenContentDelegate = self
            }
        }
    }

    func showAd(){
        let root = UIApplication.shared.windows.first?.rootViewController
        self.interstitial.present(fromRootViewController: root!)
    }
        

}

public extension UIApplication {
    func currentUIWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
        
        let window = connectedScenes.first?
            .windows
            .first { $0.isKeyWindow }

        return window
        
    }
}
