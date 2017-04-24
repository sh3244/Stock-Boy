//
//  StockTabBarController.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/18/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit

class StockTabBarController: TabBarController {
  var chart = ChartViewController()
  var watchlist = WatchlistViewController()

  override func viewDidLoad() {
    super.viewDidLoad()

    let chartNav = NavigationController(rootViewController: chart)
    chartNav.tabBarItem = UITabBarItem(title: "Chart", image: #imageLiteral(resourceName: "iconChart"), selectedImage: nil)

    let watchlistNav = NavigationController(rootViewController: watchlist)
    watchlistNav.tabBarItem = UITabBarItem(title: "Watchlist", image: #imageLiteral(resourceName: "iconList"), selectedImage: nil)

    setViewControllers([watchlistNav, chartNav], animated: false)
    selectedViewController = watchlistNav
  }

}
