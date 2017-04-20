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
  var quote = QuoteViewController()

  override func viewDidLoad() {
    super.viewDidLoad()

    let chartNav = NavigationController(rootViewController: chart)
    let chartImage = resizedIcon(image: #imageLiteral(resourceName: "imageChart"), targetSize: 40)
    chartNav.tabBarItem = UITabBarItem(title: "Chart", image: chartImage, selectedImage: nil)

    let quoteNav = NavigationController(rootViewController: quote)
    let quoteImage = resizedIcon(image: #imageLiteral(resourceName: "imageCoffee"), targetSize: 50)
    quoteNav.tabBarItem = UITabBarItem(title: "quote", image: quoteImage, selectedImage: nil)

    setViewControllers([chartNav, quoteNav], animated: false)
    selectedViewController = chartNav
  }

}
