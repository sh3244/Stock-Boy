//
//  StockTabBarController.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/18/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit

class StockTabBarController: TabBarController {
  let chart = ChartViewController("Chart", #imageLiteral(resourceName: "iconChart"))
  let watchlist = WatchlistViewController("Watchlist", #imageLiteral(resourceName: "iconList"))
  let orders = OrdersViewController("Orders", #imageLiteral(resourceName: "iconOrders"))
  let portfolio = PortfolioViewController("Portfolio", #imageLiteral(resourceName: "iconPortfolio"))
  let login = LoginViewController("Login", #imageLiteral(resourceName: "iconTouch"))
  let trade = TradeViewController("Trade", #imageLiteral(resourceName: "iconOrders"))

  override func viewDidLoad() {
    super.viewDidLoad()

    let chartNav = NavigationController(rootViewController: chart)

    let watchlistNav = NavigationController(rootViewController: watchlist)

    let ordersNav = NavigationController(rootViewController: orders)

    let portfolioNav = NavigationController(rootViewController: portfolio)

    let loginNav = NavigationController(rootViewController: login)

    let tradeNav = NavigationController(rootViewController: trade)

    setViewControllers([watchlistNav, chartNav, ordersNav, portfolioNav, loginNav, tradeNav], animated: false)
    selectedViewController = loginNav
  }

}
