//
//  StockTabBarController.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/18/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit

class StockTabBarController: TabBarController {
  var chart = ChartViewController(symbol: "URRE")
  var watchlist = WatchlistViewController()
  var orders = OrdersViewController()
  var portfolio = PortfolioViewController()
  var login = LoginViewController()

  override func viewDidLoad() {
    super.viewDidLoad()

    let chartNav = NavigationController(rootViewController: chart)
    chartNav.tabBarItem = UITabBarItem(title: "Chart", image: #imageLiteral(resourceName: "iconChart"), selectedImage: nil)

    let watchlistNav = NavigationController(rootViewController: watchlist)
    watchlistNav.tabBarItem = UITabBarItem(title: "Watchlist", image: #imageLiteral(resourceName: "iconList"), selectedImage: nil)

    let ordersNav = NavigationController(rootViewController: orders)
    orders.tabBarItem = UITabBarItem(title: "Orders", image: #imageLiteral(resourceName: "iconOrders"), selectedImage: nil)

    let portfolioNav = NavigationController(rootViewController: portfolio)
    portfolio.tabBarItem = UITabBarItem(title: "Portfolio", image: #imageLiteral(resourceName: "iconPortfolio"), selectedImage: nil)

    let loginNav = NavigationController(rootViewController: login)
    login.tabBarItem = UITabBarItem(title: "Login", image: #imageLiteral(resourceName: "iconTouch"), selectedImage: nil)

    setViewControllers([watchlistNav, chartNav, ordersNav, portfolioNav, loginNav], animated: false)
    selectedViewController = loginNav
  }

}
