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
    let chartImage = resizedIcon(image: #imageLiteral(resourceName: "imageChart"), targetSize: 40)
    chartNav.tabBarItem = UITabBarItem(title: "Chart", image: chartImage, selectedImage: nil)

    let watchlistNav = NavigationController(rootViewController: watchlist)
    let watchlistImage = resizedIcon(image: #imageLiteral(resourceName: "imageCoffee"), targetSize: 50)
    watchlistNav.tabBarItem = UITabBarItem(title: "Watchlist", image: watchlistImage, selectedImage: nil)

    setViewControllers([chartNav, watchlistNav], animated: false)
    selectedViewController = chartNav
  }

}
