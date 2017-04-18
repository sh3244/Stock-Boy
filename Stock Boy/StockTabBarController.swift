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
  var second = SecondViewController()

  override func viewDidLoad() {
    super.viewDidLoad()

    let chartNav = NavigationController(rootViewController: chart)
    let chartImage = resizedIcon(image: #imageLiteral(resourceName: "imageChart"), targetSize: 40)
    chartNav.tabBarItem = UITabBarItem(title: "Chart", image: chartImage, selectedImage: nil)

    let secondNav = NavigationController(rootViewController: second)
    let secondImage = resizedIcon(image: #imageLiteral(resourceName: "imageCoffee"), targetSize: 50)
    secondNav.tabBarItem = UITabBarItem(title: "Second", image: secondImage, selectedImage: nil)

    setViewControllers([chartNav, secondNav], animated: false)
    selectedViewController = chartNav
  }

}
