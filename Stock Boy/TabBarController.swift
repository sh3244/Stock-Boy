//
//  TabBarController.swift
//  Stock Boy
//
//  Created by Huang, Samuel on 4/18/17.
//  Copyright © 2017 Huang, Samuel. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()
    setupAppearance()
  }

  func setupAppearance() {
    view.backgroundColor = UISettings.backgroundColor

    if UISettings.backgroundColor == .black {
      tabBar.barStyle = .black
    }
    tabBar.tintColor = UISettings.foregroundColor
    tabBar.isTranslucent = false
  }
}
