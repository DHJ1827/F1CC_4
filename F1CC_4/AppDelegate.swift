//
//  AppDelegate.swift
//  F1CC_4
//
//  Created by David Joyce on 2023-03-16.
//

import Foundation

import GoogleMobileAds
import UIKit

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Initialize Google Mobile Ads SDK
    GADMobileAds.sharedInstance().start(completionHandler: nil)

    return true
  }

}

