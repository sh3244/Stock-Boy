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
    view.backgroundColor = .darkGray

    tabBar.barStyle = .black
    tabBar.isTranslucent = false
  }
}
