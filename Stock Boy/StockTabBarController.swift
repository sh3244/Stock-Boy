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
  var orders = OrdersViewController()
  var portfolio = PortfolioViewController()

  override func viewDidLoad() {
    super.viewDidLoad()

    let chartNav = NavigationController(rootViewController: chart)
    chartNav.tabBarItem = UITabBarItem(title: "Chart", image: #imageLiteral(resourceName: "iconChart"), selectedImage: nil)

    let watchlistNav = NavigationController(rootViewController: watchlist)
    watchlistNav.tabBarItem = UITabBarItem(title: "Watchlist", image: #imageLiteral(resourceName: "iconList"), selectedImage: nil)

    let ordersNav = NavigationController(rootViewController: orders)
    orders.tabBarItem = UITabBarItem(title: "Orders", image: #imageLiteral(resourceName: "iconList"), selectedImage: nil)

    let portfolioNav = NavigationController(rootViewController: portfolio)
    portfolio.tabBarItem = UITabBarItem(title: "Portfolio", image: #imageLiteral(resourceName: "iconList"), selectedImage: nil)

    setViewControllers([watchlistNav, chartNav, ordersNav, portfolioNav], animated: false)
    selectedViewController = watchlistNav

    // Login override point

    if !LoginManager.shared.loggedIn {
      let login = LoginViewController()
      let loginNav = NavigationController(rootViewController: login)
      self.present(loginNav, animated: true, completion: { 
        
      })
    }
  }

}
