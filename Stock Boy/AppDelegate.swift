//
//  AppDelegate.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/18/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit
import FLEX

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var tabBarController: StockTabBarController!

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    let tabBarController = StockTabBarController()

    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = tabBarController
    window?.makeKeyAndVisible()

    FLEXManager.shared().showExplorer()

    return true
  }
}

